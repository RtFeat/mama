import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'consultation.g.dart';

class ConsultationStore extends _ConsultationStore with _$ConsultationStore {
  ConsultationStore({
    required super.restClient,
  });
}

abstract class _ConsultationStore extends SingleDataStore<Consultation>
    with Store {
  final RestClient restClient;

  _ConsultationStore({required this.restClient})
      : super(
            fetchFunction: (id) =>
                restClient.get('${Endpoint.consultation}/$id'),
            transformer: (raw) {
              if (raw?['consultation'] != null) {
                final data = Consultation.fromJson(raw?['consultation']);
                return data;
              }
              return Consultation();
            });

  void addConsultation({
    required String doctorId,
    required String userId,
    required String comment,
    required String slot,
    required ConsultationType type,
    required DateTime weekStart,
    required int weekDay,
  }) {
    restClient.post(Endpoint().addConsultation, body: {
      'comment': comment,
      'day': switch (weekDay) {
        1 => 'monday',
        2 => 'tuesday',
        3 => 'wednesday',
        4 => 'thursday',
        5 => 'friday',
        6 => 'saturday',
        7 => 'sunday',
        _ => '',
      },
      'doctor_id': doctorId,
      'slot': slot,
      'time_week': weekStart.toUtc().toIso8601String(),
      'type': type.name.toUpperCase(),
      'user_id': userId,
    }).then((v) {
      if (v?['status_code'] != 500) {
        DelightToastBar(
          autoDismiss: true,
          builder: (context) => ToastCard(
            title: Text(
              t.consultation.consultationAdded,
            ),
          ),
        ).show(navKey.currentContext!);
      } else {
        DelightToastBar(
          autoDismiss: true,
          builder: (context) => ToastCard(
            title: Text(
              t.consultation.hasConsultation,
            ),
          ),
        ).show(navKey.currentContext!);
      }
    });
  }

  @observable
  int selectedPage = 0;

  @action
  void setSelectedPage(int value) => selectedPage = value;

  @action
  void nextPage(
      {required List<ConsultationSlot> consultationsSlots,
      required TabController? tabController}) {
    if (selectedPage < consultationsSlots.length - 1) {
      selectedPage++;
      tabController?.animateTo(selectedPage);
      loadData(id: consultationsSlots[selectedPage].id);
    }
  }

  @action
  void prevPage(
      {required List<ConsultationSlot> consultationsSlots,
      required TabController? tabController}) {
    if (selectedPage > 0) {
      selectedPage--;
      tabController?.animateTo(selectedPage);
      loadData(id: consultationsSlots[selectedPage].id);
    }
  }
}
