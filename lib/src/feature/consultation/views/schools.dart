import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

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
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        itemsPadding: EdgeInsets.symmetric(vertical: 4),
        itemBuilder: (context, item, _) {
          final SchoolModel? schoolModel = item;

          return ConsultationItem(
              url: schoolModel?.account?.avatarUrl,
              onTap: () {
                context.pushNamed(
                  AppViews.profileInfo,
                  extra: {
                    'model': schoolModel?.account,
                    'schoolId': schoolModel?.id,
                  },
                );
              },
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
