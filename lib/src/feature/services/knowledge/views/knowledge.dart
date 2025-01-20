import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

import '../widgets/filter.dart';

class KnowledgeView extends StatelessWidget {
  const KnowledgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<KnowledgeFilter> filters = [
      KnowledgeFilter(
          onTap: () {
            context.pushNamed(AppViews.categories);
          },
          title: t.services.categoriesBtn.title),
      KnowledgeFilter(onTap: () {}, title: t.services.ageBtn.title),
      KnowledgeFilter(onTap: () {}, title: t.services.authorBtn.title),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: t.services.knowledgeCenter.title,
        action: IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.bookmark,
            )),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                  children: filters
                      .map((e) => KnowledgeFilterWidget(
                            filter: e,
                          ))
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }
}
