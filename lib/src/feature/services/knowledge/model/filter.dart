import 'package:mobx/mobx.dart';

part 'filter.g.dart';

class KnowledgeFilter extends _KnowledgeFilter with _$KnowledgeFilter {
  final Function() onTap;
  final String title;
  KnowledgeFilter({
    required this.onTap,
    required this.title,
  });
}

abstract class _KnowledgeFilter with Store {
  @observable
  bool isSelected = false;

  @action
  void setSelected(bool value) => isSelected = value;
}
