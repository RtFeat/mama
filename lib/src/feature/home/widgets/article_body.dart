import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class ArticleBody extends StatefulWidget {
  final String id;
  final NativeArticleStore store;
  const ArticleBody({
    super.key,
    required this.id,
    required this.store,
  });

  @override
  State<ArticleBody> createState() => _ArticleBodyState();
}

class _ArticleBodyState extends State<ArticleBody> {
  @override
  void initState() {
    widget.store.getData(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 10;

    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return LoadingWidget(
        future: widget.store.fetchFuture,
        builder: (context) {
          return ListView.builder(
              itemCount: 1,
              // widget.store.listData.length,
              padding: const EdgeInsets.only(
                top: kToolbarHeight,
                left: padding,
                right: padding,
              ),
              itemBuilder: (context, index) {
                final NativeArticle article = widget.store.listData[index]!;

                if (article.data == null) return const SizedBox.shrink();

                switch (article.type) {
                  case NativeArticleType.text:
                    return Text(
                      article.data!,
                      style: textTheme.titleSmall,
                    );
                  case NativeArticleType.image:
                    return Image.network(
                      article.data!,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    );
                  case NativeArticleType.list:
                    return Column(
                      children: List.from(
                          jsonDecode(article.data!).map((e) => ListTile(
                                  title: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                  ),
                                  10.w,
                                  Text(
                                    e.toString(),
                                    style: textTheme.titleSmall,
                                  ),
                                ],
                              )))),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              });
        });
  }
}
