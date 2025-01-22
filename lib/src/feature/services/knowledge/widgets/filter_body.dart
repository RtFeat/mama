import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

class KnowledgeFilterBody extends StatefulWidget {
  final PaginatedListStore<CategoryModel> store;
  const KnowledgeFilterBody({super.key, required this.store});

  @override
  State<KnowledgeFilterBody> createState() => _KnowledgeFilterBodyState();
}

class _KnowledgeFilterBodyState extends State<KnowledgeFilterBody> {
  @override
  void initState() {
    widget.store.loadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return PaginatedLoadingWidget(
      store: widget.store,
      itemsPadding: EdgeInsets.zero,
      itemBuilder: (context, item) {
        return Observer(builder: (_) {
          return CheckboxListTile(
            title: Text(
              item.title,
              style: textTheme.titleSmall,
            ),
            value: item.isSelected,
            onChanged: (value) => item.setSelected(value ?? false),
          );
        });
      },
    );
  }
}
