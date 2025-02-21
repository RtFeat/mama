import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class KnowledgeFilterBody extends StatefulWidget {
  final PaginatedListStore<KnowledgeFilterModel> store;
  final String Function(KnowledgeFilterModel) titleBuilder;
  final String Function(KnowledgeFilterModel)? countBuilder;
  final String Function(KnowledgeFilterModel)? profession;
  final Widget Function(KnowledgeFilterModel)? iconBuilder;
  const KnowledgeFilterBody(
      {super.key,
      required this.store,
      this.countBuilder,
      this.profession,
      this.iconBuilder,
      required this.titleBuilder});

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
      itemBuilder: (context, item, _) {
        return Observer(builder: (_) {
          return ListTile(
            horizontalTitleGap: 10,
            leading: widget.iconBuilder?.call(item),
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.only(left: 16),
            onTap: () {
              item.setSelected(!item.isSelected);
            },
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titleBuilder(item),
                    style: textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.profession != null &&
                    widget.profession!(item).isNotEmpty) ...[
                  8.w,
                  ConsultationBadge(
                    title: widget.profession!(item),
                  ),
                ]
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.countBuilder != null)
                  Text(
                    widget.countBuilder!(item),
                    maxLines: 1,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.greyBrighterColor,
                    ),
                  ),
                Checkbox(
                  value: item.isSelected,
                  onChanged: (value) => item.setSelected(value ?? false),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
