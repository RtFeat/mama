import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

import 'package:skit/skit.dart';

part 'consultation.g.dart';

class ConsultationStore extends _ConsultationStore with _$ConsultationStore {
  ConsultationStore({
    required super.apiClient,
    required super.faker,
    required super.chatsViewStore,
    required super.messagesStore,
    required super.socket,
  });
}

abstract class _ConsultationStore extends SingleDataStore<Consultation>
    with Store {
  final ChatsViewStore chatsViewStore;
  final MessagesStore messagesStore;
  final ChatSocket socket;
  _ConsultationStore({
    required super.apiClient,
    required super.faker,
    required this.chatsViewStore,
    required this.messagesStore,
    required this.socket,
  }) : super(
            testDataGenerator: () {
              return Consultation(
                id: faker.datatype.uuid(),
              );
            },
            fetchFunction: (id) =>
                apiClient.get('${Endpoint.consultation}/$id'),
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
    apiClient.post(Endpoint().addConsultation, body: {
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

  @action
  Future createChat(String userId) async {
    apiClient.post(Endpoint().createChat, body: {
      'account_id': userId,
    }).then((v) {
      final Map<String, dynamic>? map = v != null && v.keys.contains('chat')
          ? v['chat'] as Map<String, dynamic>?
          : null;

      if (map != null) {
        final SingleChatItem chat = SingleChatItem.fromJson(map);

        chatsViewStore.chats.listData.insert(0, chat);

        messagesStore.setChatId(chat.id);
        chatsViewStore.setSelectedChat(chat);

        socket.initialize(forceReconnect: true);

        router.goNamed(AppViews.chatView, extra: {'item': chat});
      }
    });
  }
}
