import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleBody extends StatelessWidget {
  final String id;
  final NativeArticleStore store;
  const ArticleBody({
    super.key,
    required this.id,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return LoadingWidget(
        future: store.fetchFuture,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 60),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: ConsultationItem(
                        url: store.data?.author?.avatarUrl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConsultationItemTitle(
                              name:
                                  '${store.data?.author?.firstName} ${store.data?.author?.secondName ?? ''}',
                              badgeTitle: store.data?.author?.profession,
                            ),
                            Row(children: [
                              Expanded(
                                child: AutoSizeText(
                                  store.data?.author?.info ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall!.copyWith(
                                      color: textTheme.bodyLarge!.color,
                                      fontSize: 14),
                                ),
                              ),
                            ]),
                            ConsultationTags(tags: [
                              (t.consultation.articles(
                                  n: store.data?.countArticlesAuthor ?? 0)),
                              // if (schoolModel?.isCourse ?? false)
                              // t.consultation.course,
                            ])
                          ],
                        ))),
                //   SliverList.builder(
                //       itemCount: store.data?.articles?.length,
                //       // padding: const EdgeInsets.only(
                //       //   top: kToolbarHeight,
                //       //   left: padding,
                //       //   right: padding,
                //       // ),
                //       itemBuilder: (context, index) {
                //         final NativeArticle article = store
                //                 .data?.articles?[index] ??
                //             NativeArticle(data: '', type: NativeArticleType.text);

                //         if (article.data == null) return const SizedBox.shrink();

                //         switch (article.type) {
                //           case NativeArticleType.text:
                //             return Text(
                //               article.data!,
                //               style: textTheme.titleSmall,
                //             );
                //           case NativeArticleType.image:
                //             return Image.network(
                //               article.data!,
                //               errorBuilder: (context, error, stackTrace) {
                //                 logger.error('error',
                //                     error: error, stackTrace: stackTrace);
                //                 return const SizedBox.shrink();
                //               },
                //             );
                //           case NativeArticleType.list:
                //             return Column(
                //               children: List.from(
                //                   jsonDecode(article.data!).map((e) => ListTile(
                //                           title: Row(
                //                         children: [
                //                           const Icon(
                //                             Icons.circle,
                //                             size: 8,
                //                           ),
                //                           10.w,
                //                           Text(
                //                             e.toString(),
                //                             style: textTheme.titleSmall,
                //                           ),
                //                         ],
                //                       )))),
                //             );
                //         }
                //       }),

                SliverFillRemaining(
                    child: _WebBody(
                        data: store.data?.articles
                                ?.where((e) => e.data != null)
                                .firstOrNull
                                ?.data ??
                            ''))
              ],
            ),
          );
        });
  }
}

class _WebBody extends StatefulWidget {
  final String data;
  const _WebBody({
    required this.data,
  });

  @override
  State<_WebBody> createState() => __WebBodyState();
}

class __WebBodyState extends State<_WebBody> {
  late final WebViewController controller;

  late final String payload;

  @override
  void initState() {
    payload = '''
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Document</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            overflow-x: hidden; /* Убираем горизонтальный скролл */
        }
        img {
            max-width: 100%; /* Ограничиваем ширину изображений */
            height: auto; /* Сохраняем пропорции */
            display: block; /* Убираем лишние отступы */
            margin: 0 auto; /* Центрируем изображение */
        }
    </style>
</head>
<body>
${widget.data}
</body>
</html>
  ''';
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(payload);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
