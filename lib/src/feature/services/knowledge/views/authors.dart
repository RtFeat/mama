import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class AuthorsView extends StatelessWidget {
  const AuthorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();
    final CategoriesStore store = knowledgeStore.categoriesStore;
    final AuthorsStore authorsStore = knowledgeStore.authorsStore;

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
          body: KnowledgeFilterBody(
              store: authorsStore,
              iconBuilder: (item) => AvatarWidget(
                  url: (item as AuthorModel).writer?.photoId,
                  size: const Size(32, 32),
                  radius: 25),
              profession: (item) =>
                  (item as AuthorModel).writer?.profession ?? '',
              countBuilder: (item) => '${(item as AuthorModel).count}',
              titleBuilder: (item) =>
                  (item as AuthorModel).writer?.fullName ?? ''),
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
