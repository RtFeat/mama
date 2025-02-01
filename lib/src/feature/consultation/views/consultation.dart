import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class ConsultationView extends StatelessWidget {
  final DoctorModel? doctor;
  final Consultation? consultation;
  final int? selectedTab;
  const ConsultationView({
    super.key,
    this.doctor,
    this.consultation,
    this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    final DoctorStore doctorStore = context.watch<DoctorStore>();

    return Provider(
      create: (context) => ConsultationStore(
        apiClient: context.read<Dependencies>().apiClient,
      ),
      builder: (context, child) => _Body(
        doctor: doctor,
        consultation: consultation,
        role: userStore.role,
        selectedTab: selectedTab,
        consultationsSlots: consultation != null
            ? doctorStore
                .weekConsultations[consultation!.startedAt!.weekday - 1]
            : null,
        store: context.watch<ConsultationStore>(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final DoctorModel? doctor;
  final Consultation? consultation;
  final Role role;
  final ConsultationStore store;
  final List<ConsultationSlot>? consultationsSlots;
  final int? selectedTab;
  const _Body({
    this.doctor,
    required this.consultationsSlots,
    this.consultation,
    required this.role,
    required this.store,
    required this.selectedTab,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    if (widget.role == Role.doctor) {
      widget.store.setSelectedPage(widget.selectedTab ?? 0);
      widget.store.loadData(
          id: widget.consultation?.id ??
              widget.consultationsSlots?[widget.selectedTab ?? 0].id);
      tabController = TabController(
          length: widget.consultationsSlots?.length ?? 1,
          vsync: this,
          initialIndex: widget.selectedTab ?? 0);
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  // void load() {
  //   widget.store.loadData(id: widget.consultationsSlots[selectedPage].id);
  // }

  // void prevPage() {
  //   if (selectedPage > 0) {
  //     selectedPage--;
  //     tabController?.animateTo(selectedPage);
  //     load();
  //   }
  // }

  // void nextPage() {
  //   if (selectedPage < widget.consultationsSlots.length - 1) {
  //     selectedPage++;
  //     tabController?.animateTo(selectedPage);
  //     load();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Observer(builder: (_) {
          return Text(
            t.consultation.consultTitle,
            style: textTheme.titleLarge?.copyWith(
              color: switch (widget.consultation?.status) {
                ConsultationStatus.completed => AppColors.greenTextColor,
                ConsultationStatus.rejected => AppColors.redColor,
                _ => AppColors.primaryColor,
              },
            ),
          );
        }),
        action: widget.consultationsSlots != null &&
                widget.consultationsSlots!.length > 1 &&
                widget.role == Role.doctor
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        widget.store.prevPage(
                            consultationsSlots: widget.consultationsSlots!,
                            tabController: tabController);

                        setState(() {});
                      },
                      child: const Icon(Icons.arrow_left_rounded)),
                  GestureDetector(
                      onTap: () {
                        widget.store.nextPage(
                          consultationsSlots: widget.consultationsSlots!,
                          tabController: tabController,
                        );
                        setState(() {});
                      },
                      child: const Icon(Icons.arrow_right_rounded)),
                ],
              )
            : null,
      ),
      body: widget.role == Role.doctor
          ? TabBarView(
              controller: tabController,
              children: widget.consultationsSlots!
                  .map((e) => LoadingWidget(
                        future: widget.store.fetchFuture,
                        builder: (data) {
                          return _RoleBody(
                              patient: data?.patient,
                              doctor: data?.doctor ?? widget.doctor,
                              consultation: data);
                        },
                      ))
                  .toList())
          : _RoleBody(
              doctor: widget.consultation?.doctor ?? widget.doctor,
              patient:
                  widget.store.data?.patient ?? widget.consultation?.patient,
              consultation:
                  widget.store.data ?? widget.consultation ?? Consultation(),
            ),
    );
  }
}

class _RoleBody extends StatelessWidget {
  final Consultation? consultation;
  final DoctorModel? doctor;
  final AccountModel? patient;

  const _RoleBody({
    required this.doctor,
    required this.consultation,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final UserStore userStore = context.watch<UserStore>();

    final Color color = switch (consultation?.status) {
      ConsultationStatus.completed => AppColors.greenTextColor,
      ConsultationStatus.rejected => AppColors.redColor,
      _ => AppColors.primaryColor,
    };

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        switch (userStore.role) {
          Role.doctor => ConsultationItem(
              url: consultation?.patient?.avatarUrl ?? patient?.avatarUrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    consultation?.patient?.name ?? patient?.name ?? '',
                    maxLines: 1,
                    style: textTheme.bodyMedium,
                  ),
                  4.h,
                  Text(
                    consultation?.patient?.info ?? patient?.info ?? '',
                    maxLines: 4,
                    style: textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // '${patient?.firstName} ${patient?.secondName}'),
                ],
              )),
          _ => Column(
              children: [
                AvatarWidget(
                    url: doctor?.account?.avatarUrl,
                    size: const Size(175, 175),
                    radius: 12),
                6.h,
                AutoSizeText(
                  doctor?.account?.name ??
                      consultation?.doctor?.fullName ??
                      doctor?.fullName ??
                      '',
                ),
                // doctor?.account?.name ?? ''),
                // '${doctor?.account?.firstName} ${doctor?.account?.secondName}'),
                6.h,
                SizedBox(
                  height: 26,
                  child: ConsultationBadge(
                    title: doctor?.profession ?? '',
                  ),
                ),
              ],
            ),
        },
        20.h,
        consultation != null && consultation!.startedAt != null
            ? MyConsultationWidget(
                consultation: consultation!,
                color: color,
              )
            : NewConsultationWidget(
                doctorId: doctor?.id ?? '',
                workTime: doctor?.workTime,
              ),
      ],
    );
  }
}
