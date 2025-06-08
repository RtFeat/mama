import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        builder: (model) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight * 1.5),
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
                      )),
                )),
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
                SliverToBoxAdapter(
                  child: 20.h,
                ),
                SliverToBoxAdapter(
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
  late Future future;
  late String payload;
  double webViewHeight = 1;

  Future<String> loadFontBase64() async {
    ByteData fontData = await rootBundle.load(Assets.fonts.sFProTextMedium);
    Uint8List bytes = fontData.buffer.asUint8List();
    return base64Encode(bytes);
  }

  Future<void> setupWebView() async {
    String base64Font = await loadFontBase64();
    String fontFace = '''
      @font-face {
        font-family: 'SF Pro Text';
        src: url(data:font/ttf;base64,$base64Font) format('truetype');
      }
    ''';

    payload = '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
          <title>Document</title>
          <style>
              $fontFace
              * {
                  -webkit-touch-callout: none;
                  -webkit-user-select: none;
                  -khtml-user-select: none;
                  -moz-user-select: none;
                  -ms-user-select: none;
                  user-select: none;
                  caret-color: transparent !important;
              }
              body {
                  margin: 0;
                  padding: 0;
                  overflow-x: hidden;
                  font-family: 'SF Pro Text', sans-serif;
                  background-color: transparent;
              }
              img {
                  max-width: 100%;
                  height: auto;
                  display: block;
                  margin: 0 auto;
                  pointer-events: none;
              }
              input, textarea {
                  display: none !important;
              }
          </style>
          <script>
              document.addEventListener('contextmenu', function(e) {
                  e.preventDefault();
              });
              document.addEventListener('selectstart', function(e) {
                  e.preventDefault();
              });
              document.addEventListener('mousedown', function(e) {
                  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
                      e.preventDefault();
                  }
              });
          </script>
      </head>
      <body>
        ${widget.data}
      </body>
      </html>
    ''';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..clearCache()
      // ..enableZoom(false)
      // ..setBackgroundColor(Colors.transparent)
      // ..setNavigationDelegate(NavigationDelegate(
      //   onNavigationRequest: (request) {
      //     return NavigationDecision.prevent;
      //   },
      // ))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          _updateWebViewHeight();
        },
      ))
      ..loadHtmlString(payload);
  }

  Future<void> _updateWebViewHeight() async {
    final String heightScript = "document.documentElement.scrollHeight";
    final dynamic result =
        await controller.runJavaScriptReturningResult(heightScript);

    if (mounted) {
      setState(() {
        // Parse the height and add some padding
        webViewHeight = double.parse(result.toString()) + 20;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    future = setupWebView();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AbsorbPointer(
            child: SizedBox(
              height: webViewHeight,
              child: WebViewWidget(
                controller: controller,
                gestureRecognizers: {
                  Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()
                        ..onStart = (_) {}
                        ..onDown = (_) {}
                        ..onUpdate = (_) {}
                        ..onEnd = (_) {}),
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
