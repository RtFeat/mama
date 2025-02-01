import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:skit/skit.dart';

part 'messages.g.dart';

class MessagesStore extends _MessagesStore with _$MessagesStore {
  MessagesStore({
    required super.apiClient,
    required super.chatType,
    super.pageSize = 20,
  });
}

abstract class _MessagesStore extends PaginatedListStore<MessageItem>
    with Store, FilterableDataMixin<MessageItem> {
  _MessagesStore({
    required super.apiClient,
    required this.chatType,
    required super.pageSize,
  }) : super(
            basePath: Endpoint().messages,
            fetchFunction: (params, path) =>
                apiClient.get('$path/$chatType', queryParams: params),
            transformer: (raw) {
              final List<MessageItem>? data = (raw['messages'] as List?)
                  ?.map((e) => MessageItem.fromJson(e))
                  .toList();

              final List? attachedMessagesIds = raw['attached'];

              if (data != null && attachedMessagesIds != null) {
                for (var message in data) {
                  if (attachedMessagesIds.contains(message.id)) {
                    message.setIsAttached(true);
                  }
                }
              }

              return data ?? [];
            });

  @observable
  String? chatType;

  @action
  void setChatType(String? type) => chatType = type;

  @observable
  String? chatId;

  @action
  void setChatId(String? id) => chatId = id;

  @computed
  ObservableList<MessageItem> get messages => ObservableList.of(listData);

  // need for show date in top
  @observable
  MessageItem? currentShowingMessage;

  @action
  void setCurrentShowingMessage(MessageItem? message) {
    currentShowingMessage = message;
  }

  @action
  void addMessage(MessageItem message) {
    listData.insert(0, message);
  }

  @action
  void removeMessage(String messageId) {
    listData.removeWhere((e) => e.id == messageId);
  }

  @observable
  MessageItem? mentionedMessage;

  @action
  void setMentionedMessage(MessageItem? message) => mentionedMessage = message;

  @observable
  int selectedPinnedMessageIndex = 0;

  @computed
  MessageItem? get pinnedMessage => attachedMessages.isNotEmpty
      ? attachedMessages[selectedPinnedMessageIndex]
      : null;

  @computed
  ObservableList<MessageItem> get attachedMessages =>
      ObservableList.of(listData.where((e) => e.isAttached));

  @action
  void nextPinnedMessage() {
    if (selectedPinnedMessageIndex < attachedMessages.length - 1) {
      selectedPinnedMessageIndex += 1;
    } else {
      selectedPinnedMessageIndex = 0;
    }
    scrollController?.scrollToIndex(messages.indexOf(pinnedMessage),
        preferPosition: AutoScrollPosition.begin);
  }

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

  AutoScrollController? scrollController;

  void init() {
    resetPagination();
    scrollController = AutoScrollController();
  }

  void dispose() {
    scrollController?.dispose();
  }
}
