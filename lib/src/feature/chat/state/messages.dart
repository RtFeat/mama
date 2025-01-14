import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'messages.g.dart';

class MessagesStore extends _MessagesStore with _$MessagesStore {
  MessagesStore({
    required super.restClient,
    required super.chatType,
    super.pageSize = 20,
  });
}

abstract class _MessagesStore extends PaginatedListStore<MessageItem>
    with Store, FilterableDataMixin<MessageItem> {
  _MessagesStore({
    required RestClient restClient,
    required String chatType,
    required super.pageSize,
  }) : super(
            fetchFunction: (params) => restClient
                .get('${Endpoint().messages}/$chatType', queryParams: params),
            transformer: (raw) {
              final List<MessageItem>? data = (raw['messages'] as List?)
                  ?.map((e) => MessageItem.fromJson(e))
                  .toList();

              final List<MessageItem>? attachedMessages = (raw['attached']
                      as List?)
                  ?.map(
                      (e) => MessageItem.fromJson(e).copyWith(isAttached: true))
                  .toList();

              data?.addAll(attachedMessages ?? []);

              return data ?? [];
            });

  @computed
  ObservableList<MessageItem> get messages =>
      ObservableList.of(listData.where((e) => !e.isAttached));

  // need for show date in top
  @observable
  MessageItem? currentShowingMessage;

  @action
  void setCurrentShowingMessage(MessageItem? message) {
    currentShowingMessage = message;
  }

  @observable
  MessageItem? mentionedMessage;

  @action
  void setMentionedMessage(MessageItem? message) => mentionedMessage = message;

  @observable
  int selectedPinnedMessageIndex = -1;

  @computed
  MessageItem? get pinnedMessage => selectedPinnedMessageIndex != -1
      ? listData[selectedPinnedMessageIndex]
      : null;

  @computed
  ObservableList<MessageItem> get attachedMessages => ObservableList.of([
        MessageItem(
          id: 'attached',
          text: 'Attached',
          isAttached: true,
        ),
        MessageItem(
          id: 'attached',
          text: 'Attached',
          isAttached: true,
        ),
        MessageItem(
          id: 'attached',
          text: 'Attached',
          isAttached: true,
        ),
      ]);
  // ObservableList.of(listData.where((e) => e.isAttached));

  @observable
  bool isSearching = false;

  @action
  void setIsSearching(bool value) => isSearching = value;

  @observable
  String? query;

  @action
  void setQuery(String value) {
    logger.info('query $value', runtimeType: runtimeType);
    query = value;
    formGroup.control('search').value = value;
  }

  @action
  @override
  void setFilters(Map<String, FilterFunction<MessageItem>> filters) {
    super.setFilters(filters);
    filteredMessages = applyFilters(listData);
  }

  @observable
  ObservableList<MessageItem> filteredMessages = ObservableList();

  FormGroup formGroup = FormGroup({
    'search': FormControl<String>(),
    'message': FormControl<String>(),
  });
}
