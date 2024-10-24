import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class ConsultationView extends StatelessWidget {
  final bool isMadeAppointment;
  final DoctorModel? doctor;
  const ConsultationView({
    super.key,
    this.doctor,
    this.isMadeAppointment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: t.consultation.consultTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Column(
            children: [
              AvatarWidget(
                  url: doctor?.account?.avatarUrl,
                  size: const Size(175, 175),
                  radius: 12),
              6.h,
              AutoSizeText(
                  '${doctor?.account?.firstName} ${doctor?.account?.secondName}'),
              6.h,
              SizedBox(
                height: 26,
                child: ConsultationBadge(
                  title: doctor?.profession ?? '',
                ),
              ),
            ],
          ),
          20.h,
          NewConsultationWidget(
            workTime: doctor?.workTime,
          ),
        ],
      ),
    );
  }
}
