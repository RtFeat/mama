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

    return Provider(
      create: (context) => ConsultationStore(
          restClient: context.read<Dependencies>().restClient,
          id: consultation?.id),
      builder: (context, child) => _Body(
        doctor: doctor,
        consultation: consultation,
        role: userStore.role,
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
  const _Body({
    this.doctor,
    this.consultation,
    required this.role,
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    if (widget.role == Role.doctor) {
      widget.store.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    final body = ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        switch (userStore.role) {
          Role.doctor => const SizedBox(),
          _ => Column(
              children: [
                AvatarWidget(
                    url: widget.doctor?.account?.avatarUrl,
                    size: const Size(175, 175),
                    radius: 12),
                6.h,
                AutoSizeText(
                    '${widget.doctor?.account?.firstName} ${widget.doctor?.account?.secondName}'),
                6.h,
                SizedBox(
                  height: 26,
                  child: ConsultationBadge(
                    title: widget.doctor?.profession ?? '',
                  ),
                ),
              ],
            ),
        },
        20.h,
        widget.consultation != null
            ? MyConsultationWidget(
                consultation: widget.consultation!,
              )
            : NewConsultationWidget(
                workTime: widget.doctor?.workTime,
              ),
      ],
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: t.consultation.consultTitle,
      ),
      body: widget.role == Role.doctor
          ? LoadingWidget(
              future: widget.store.fetchFuture,
              builder: (data) => body,
            )
          : body,
    );
  }
}
