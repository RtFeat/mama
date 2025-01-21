import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import '../widgets/filter.dart';

class KnowledgeView extends StatelessWidget {
  const KnowledgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();

    return Observer(builder: (context) {
      final int selectedCategoriesCount =
          knowledgeStore.categoriesStore.selectedItemsCount;
      final bool isSelectedCategories = selectedCategoriesCount >= 1;

      final int selectedAgesCount =
          knowledgeStore.ageCategoriesStore.selectedItemsCount;
      final bool isSelectedAges = selectedAgesCount >= 1;

      final List<KnowledgeFilter> filters = [
        KnowledgeFilter(
            isSelected: isSelectedCategories,
            onTap: () {
              context.pushNamed(AppViews.categories);
            },
            title: switch (selectedCategoriesCount) {
              1 => knowledgeStore.categoriesStore.selectedItems.first.title,
              > 1 =>
                '$selectedCategoriesCount ${t.services.categoriesBtn.title.toLowerCase()}',
              _ => t.services.categoriesBtn.title,
            }),
        KnowledgeFilter(
            isSelected: isSelectedAges,
            onTap: () {
              context.pushNamed(AppViews.ages);
            },
            title: switch (selectedAgesCount) {
              1 => knowledgeStore.ageCategoriesStore.selectedItems.first.title,
              > 1 =>
                '${knowledgeStore.ageCategoriesStore.selectedItems.first.title}+',
              _ => t.services.ageBtn.title,
            }),
        KnowledgeFilter(onTap: () {}, title: t.services.authorBtn.title),
      ];

      return Scaffold(
        appBar: CustomAppBar(
          title: t.services.knowledgeCenter.title,
          action: IconButton(
              onPressed: () {},
              icon: const Icon(
                AppIcons.bookmark,
              )),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                      children: filters
                          .map((e) => KnowledgeFilterWidget(
                                filter: e,
                              ))
                          .toList()),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _Body(knowledgeStore: knowledgeStore)),
          ],
        ),
      );
    });
  }
}

class _Body extends StatefulWidget {
  final KnowledgeStore knowledgeStore;
  const _Body({required this.knowledgeStore});

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.knowledgeStore.loadPage(queryParams: {
      'categories': widget.knowledgeStore.categoriesStore.selectedItems
          .map((e) => e.title)
          .toList(),
      'ages': widget.knowledgeStore.ageCategoriesStore.selectedItems
          .map((e) => e.title)
          .toList(),
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedLoadingWidget(
      emptyData: const SizedBox.shrink(),
      store: widget.knowledgeStore,
      separator: (index, item) {
        return const Divider(
          color: AppColors.greyColor,
        );
      },
      itemBuilder: (context, item) {
        return ArticleWidget(
          article: item,
        );
      },
    );
  }
}
