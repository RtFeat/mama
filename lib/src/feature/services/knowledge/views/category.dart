import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();
    final CategoriesStore store = knowledgeStore.categoriesStore;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !store.isConfirmed) {
          store.setMarkAllNotSelected();
        }
        store.setConfirmed(false);
      },
      child: Scaffold(
          backgroundColor: AppColors.lightBlue,
          appBar: CustomAppBar(
            title: t.services.categoriesBtn.title,
          ),
          body: KnowledgeFilterBody(
            store: store,
            titleBuilder: (item) => (item as CategoryModel).title,
            countBuilder: (item) => '${(item as CategoryModel).count}',
          ),
          bottomNavigationBar: FilterBottomBarWidget(
            onClear: () {
              store.setMarkAllNotSelected();
            },
            onConfirm: () {
              knowledgeStore.onConfirm();
            },
          )),
    );
  }
}
