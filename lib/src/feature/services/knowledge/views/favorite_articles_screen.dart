import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class FavoriteArticlesScreen extends StatelessWidget {
  const FavoriteArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final KnowledgeStore knowledgeStore = context.watch();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          t.services.favoriteAtriclesTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Container(
        color: AppColors.whiteColor,
        padding: const EdgeInsets.all(10),
        child: PaginatedLoadingWidget(
          emptyData: const SizedBox.shrink(),
          store: knowledgeStore,
          separator: (index, item) {
            return const Divider(
              color: AppColors.greyColor,
            );
          },
          padding: EdgeInsets.zero,
          itemBuilder: (context, item) {
            return ArticleWidget(
              article: item,
            );
          },
        ),
      ),
    );
  }
}

//TODO: add favorite articles store