import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

class HomeSchoolBody extends StatefulWidget {
  final UserStore userStore;
  final HomeViewStore homeViewStore;
  // final ArticleStore articleStore;
  const HomeSchoolBody(
      {super.key,
      required this.homeViewStore,
      // required this.articleStore,

      required this.userStore});

  @override
  State<HomeSchoolBody> createState() => _HomeSchoolBodyState();
}

class _HomeSchoolBodyState extends State<HomeSchoolBody> {
  @override
  void initState() {
    widget.homeViewStore.loadOwnArticles(widget.userStore.account.id!);
    super.initState();
  }

  // @override
  // void initState() {
  //   widget.articleStore.fetchOwnList(widget.userStore.account.id!);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Observer(builder: (context) {
      return ListView(
        children: [
          /// #good afternoon title

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GreetingTitle(title: t.home.goodAfternoon.title),
          ),

          /// #today's date subtitle
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DateSubtitle()),
          24.h,

          if (widget.homeViewStore.ownArticlesStore.listData.isNotEmpty)

            /// #my articles
            CustomBackground(
              height: null,
              padding: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  /// #article category text
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        t.home.yourArticles,
                        style: textTheme.headlineSmall?.copyWith(fontSize: 24),
                      )),
                  const SizedBox(height: 16),

                  /// #articles
                  // ArticlesListView(
                  //   listData: widget.articleStore.ownListData.toList(),
                  // ),

                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(
                          height: 250,
                          child: PaginatedLoadingWidget(
                            scrollDirection: Axis.horizontal,
                            store: widget.homeViewStore.ownArticlesStore,
                            itemBuilder: (context, item) {
                              return ArticleBox(
                                model: item,
                              );
                            },
                          ))),

                  const SizedBox(height: 24),
                ],
              ),
            ),
        ],
      );
    });
  }
}
