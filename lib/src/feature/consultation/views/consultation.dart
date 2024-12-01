import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ConsultationView extends StatelessWidget {
  final DoctorModel? doctor;
  final Consultation? consultation;
  const ConsultationView({
    super.key,
    this.doctor,
    this.consultation,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    final DoctorStore doctorStore = context.watch<DoctorStore>();

    return Provider(
      create: (context) => ConsultationStore(
        restClient: context.read<Dependencies>().restClient,
      ),
      builder: (context, child) => _Body(
        doctor: doctor,
        consultation: consultation,
        role: userStore.role,
        workSlots: consultation != null
            ? doctorStore.weekSlots[consultation?.startedAt?.day ?? 0]
            : [],
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
  final List<WorkSlot> workSlots;
  const _Body({
    this.doctor,
    required this.workSlots,
    this.consultation,
    required this.role,
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  TabController? tabController;

  int selectedPage = 0;

  @override
  void initState() {
    if (widget.role == Role.doctor) {
      widget.store.loadData(id: widget.workSlots.first.consultationId);
      tabController =
          TabController(length: widget.workSlots.length, vsync: this);
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  void load() {
    widget.store.loadData(id: widget.workSlots[selectedPage].consultationId);
  }

  void prevPage() {
    if (selectedPage > 0) {
      selectedPage--;
      tabController?.animateTo(selectedPage);
      load();
    }
  }

  void nextPage() {
    if (selectedPage < widget.workSlots.length - 1) {
      selectedPage++;
      tabController?.animateTo(selectedPage);
      load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: t.consultation.consultTitle,
        action: widget.workSlots.length > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        prevPage();
                      },
                      child: const Icon(Icons.arrow_left_rounded)),
                  GestureDetector(
                      onTap: () {
                        nextPage();
                      },
                      child: const Icon(Icons.arrow_right_rounded)),
                ],
              )
            : null,
      ),
      body: widget.role == Role.doctor
          ? TabBarView(
              controller: tabController,
              children: widget.workSlots
                  .map((e) => LoadingWidget(
                        future: widget.store.fetchFuture,
                        builder: (data) => _RoleBody(
                          doctor: widget.doctor,
                          consultation: widget.consultation,
                        ),
                      ))
                  .toList())
          : _RoleBody(
              doctor: widget.doctor,
              consultation: widget.consultation,
            ),
    );
  }
}

class _RoleBody extends StatelessWidget {
  final Consultation? consultation;
  final DoctorModel? doctor;

  const _RoleBody({
    required this.doctor,
    required this.consultation,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        switch (userStore.role) {
          Role.doctor => const SizedBox(),
          _ => Column(
              children: [
                AvatarWidget(
                    url: doctor?.account?.avatarUrl,
                    size: const Size(175, 175),
                    radius: 12),
                6.h,
                AutoSizeText(doctor?.account?.name ?? ''),
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
        consultation != null
            ? MyConsultationWidget(
                consultation: consultation!,
              )
            : NewConsultationWidget(
                workTime: doctor?.workTime,
              ),
      ],
    );
  }
}
