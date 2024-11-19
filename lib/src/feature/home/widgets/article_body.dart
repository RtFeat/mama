import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
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
    widget.store.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return LoadingWidget(
        future: widget.store.fetchFuture,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 60),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: ConsultationItem(
                        url: widget.store.data?.author?.avatarUrl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConsultationItemTitle(
                              name:
                                  '${widget.store.data?.author?.firstName} ${widget.store.data?.author?.secondName ?? ''}',
                              badgeTitle: widget.store.data?.author?.profession,
                            ),
                            Row(children: [
                              Expanded(
                                child: AutoSizeText(
                                  widget.store.data?.author?.info ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall!.copyWith(
                                      color: textTheme.bodyLarge!.color),
                                ),
                              ),
                            ]),
                            ConsultationTags(tags: [
                              (t.consultation.articles(
                                  n: widget.store.data?.countArticlesAuthor ??
                                      0)),
                              // if (schoolModel?.isCourse ?? false)
                              // t.consultation.course,
                            ])
                          ],
                        ))),
                SliverList.builder(
                    itemCount: widget.store.data?.articles?.length,
                    // padding: const EdgeInsets.only(
                    //   top: kToolbarHeight,
                    //   left: padding,
                    //   right: padding,
                    // ),
                    itemBuilder: (context, index) {
                      final NativeArticle article = widget
                              .store.data?.articles?[index] ??
                          NativeArticle(data: '', type: NativeArticleType.text);

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
                            errorBuilder: (context, error, stackTrace) {
                              logger.error('error',
                                  error: error, stackTrace: stackTrace);
                              return const SizedBox.shrink();
                            },
                          );
                        case NativeArticleType.list:
                          return Column(
                            children: List.from(
                                jsonDecode(article.data!).map((e) => ListTile(
                                        title: Row(
                                      children: [
                                        const Icon(
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
                    }),
              ],
            ),
          );
        });
  }
}
