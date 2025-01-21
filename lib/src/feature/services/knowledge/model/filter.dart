import 'package:mobx/mobx.dart';

part 'filter.g.dart';

class KnowledgeFilter extends _KnowledgeFilter with _$KnowledgeFilter {
  final Function() onTap;
  final String title;
  final bool isSelected;
  KnowledgeFilter({
    required this.onTap,
    required this.title,
    this.isSelected = false,
  });
}

abstract class _KnowledgeFilter with Store {}
