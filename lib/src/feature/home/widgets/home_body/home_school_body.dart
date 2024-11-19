import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/home/home.dart';
import 'package:provider/provider.dart';

class HomeSchoolBody extends StatefulWidget {
  final UserStore userStore;
  // final ArticleStore articleStore;
  const HomeSchoolBody(
      {super.key,
      // required this.articleStore,

      required this.userStore});

  @override
  State<HomeSchoolBody> createState() => _HomeSchoolBodyState();
}

class _HomeSchoolBodyState extends State<HomeSchoolBody> {
  // @override
  // void initState() {
  //   widget.articleStore.fetchOwnList(widget.userStore.account.id!);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final HomeViewStore homeStore = context.watch<HomeViewStore>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          /// #good afternoon title
          GreetingTitle(title: t.home.goodAfternoon.title),

          /// #today's date subtitle
          const DateSubtitle(),
          24.h,

          if (homeStore.ownArticlesStore.listData.isNotEmpty)

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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// #articles
                  // ArticlesListView(
                  //   listData: widget.articleStore.ownListData.toList(),
                  // ),

                  SizedBox(
                      height: 220,
                      child: PaginatedLoadingWidget(
                        store: homeStore.ownArticlesStore,
                        itemBuilder: (context, item) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ArticleBox(
                              model: item,
                            ),
                          );
                        },
                      )),

                  const SizedBox(height: 24),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
