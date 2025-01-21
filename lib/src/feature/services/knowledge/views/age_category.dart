import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class AgeCategoryView extends StatelessWidget {
  const AgeCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();
    final CategoriesStore categoriesStore = knowledgeStore.categoriesStore;
    final AgeCategoriesStore store = knowledgeStore.ageCategoriesStore;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !store.isConfirmed) {
          store.setMarkAllNotSelected();
        }
        store.setConfirmed(false);
      },
      child: Scaffold(
          appBar: CustomAppBar(
            title: t.services.ageBtn.title,
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
                'categories':
                    categoriesStore.selectedItems.map((e) => e.title).toList(),
                'ages': store.selectedItems.map((e) => e.title).toList()
              });
            },
          )),
    );
  }
}
