import 'package:mobx/mobx.dart';

part 'add_note.g.dart';

class AddNoteStore extends _AddNoteStore with _$AddNoteStore {
  AddNoteStore();
}

abstract class _AddNoteStore with Store {
  @observable
  String? content;

  @action
  void setContent(String? value) => content = value;
}
