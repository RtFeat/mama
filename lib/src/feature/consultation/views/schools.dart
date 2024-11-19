import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class SchoolsView extends StatefulWidget {
  final ConsultationViewStore store;
  const SchoolsView({
    super.key,
    required this.store,
  });

  @override
  State<SchoolsView> createState() => _SchoolsViewState();
}

class _SchoolsViewState extends State<SchoolsView> {
  @override
  initState() {
    super.initState();
    widget.store.loadAllSchools();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return PaginatedLoadingWidget(
        store: widget.store.schoolsState,
        itemBuilder: (context, item) {
          final SchoolModel? schoolModel = item;

          return ConsultationItem(
              url: schoolModel?.account?.avatarUrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConsultationItemTitle(
                    name: schoolModel?.account?.firstName ?? '',
                    badgeTitle: null,
                  ),
                  Row(children: [
                    Expanded(
                      child: AutoSizeText(
                        schoolModel?.account?.info ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall!
                            .copyWith(color: textTheme.bodyLarge!.color),
                      ),
                    ),
                  ]),
                  ConsultationTags(tags: [
                    (t.consultation
                        .articles(n: schoolModel?.articlesCount ?? 0)),
                    if (schoolModel?.isCourse ?? false) t.consultation.course,
                  ])
                ],
              ));
        });
  }
}
