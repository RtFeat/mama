import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();
    final CategoriesStore store = knowledgeStore.categoriesStore;
    final AgeCategoriesStore ageCategoriesStore =
        knowledgeStore.ageCategoriesStore;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !store.isConfirmed) {
          store.setMarkAllNotSelected();
        }
        store.setConfirmed(false);
      },
      child: Scaffold(
          appBar: CustomAppBar(
            title: t.services.categoriesBtn.title,
          ),
          body: KnowledgeFilterBody(store: store),
          bottomNavigationBar: FilterBottomBarWidget(
            onClear: () {
              store.setMarkAllNotSelected();
            },
            onConfirm: () {
              store.setConfirmed(true);
              knowledgeStore.resetPagination();
              knowledgeStore.loadPage(queryParams: {
                'categories': store.selectedItems.map((e) => e.title).toList(),
                'ages': ageCategoriesStore.selectedItems
                    .map((e) => e.title)
                    .toList()
              });
            },
          )),
    );
  }
}
