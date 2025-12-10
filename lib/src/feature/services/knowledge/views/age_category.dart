import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class AgeCategoryView extends StatelessWidget {
  const AgeCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();
    final AgeCategoriesStore store = knowledgeStore.ageCategoriesStore;

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
            title: t.services.ageBtn.title,
          ),
          body: KnowledgeFilterBody(
              store: store,
              countBuilder: (item) => '${(item as AgeCategoryModel).count}',
              titleBuilder: (item) =>
                  (item as AgeCategoryModel).localizedTitle),
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
