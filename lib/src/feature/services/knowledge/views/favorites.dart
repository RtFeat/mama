import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class FavoriteArticlesView extends StatelessWidget {
  const FavoriteArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => FavoriteArticlesStore(
              apiClient: context.read<Dependencies>().apiClient,
            ),
        builder: (context, child) {
          final FavoriteArticlesStore store = context.watch();

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(t.services.favoriteAtriclesTitle),
            ),
            body: _Body(
              store: store,
            ),
          );
        });
  }
}

class _Body extends StatefulWidget {
  final FavoriteArticlesStore store;
  const _Body({
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  initState() {
    widget.store.loadPage();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    widget.store.resetPagination();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedLoadingWidget(
      emptyData: const SizedBox.shrink(),
      store: widget.store,
      separator: (index, item) {
        return const Divider(
          height: 1,
          color: AppColors.greyColor,
        );
      },
      itemBuilder: (context, item, _) {
        return ArticleWidget(
          favoriteArticle: item,
        );
      },
    );
  }
}
