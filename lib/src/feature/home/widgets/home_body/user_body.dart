import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class HomeUserBody extends StatefulWidget {
  final HomeViewStore homeViewStore;
  final UserStore userStore;
  final TabController tabController;
  const HomeUserBody({
    super.key,
    required this.userStore,
    required this.tabController,
    required this.homeViewStore,
  });

  @override
  State<HomeUserBody> createState() => _HomeUserBodyState();
}

class _HomeUserBodyState extends State<HomeUserBody> {
  @override
  initState() {
    super.initState();
    widget.homeViewStore.loadAllArticles();
    widget.homeViewStore.loadForMeArticles(widget.userStore.account.id ?? '');
    // widget.articleStore.fetchAll();
    // widget.articleStore.fetchForMe(widget.userStore.account.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    // final ArticleStore articleStore = context.watch<ArticleStore>();

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

          if (widget.userStore.children.isNotEmpty) ...[
            24.h,
            const ChildInfo(),
          ],
          26.h,

          /// #services
          CustomBackground(
            height: 540,
            padding: 16,
            child: Column(
              children: [
                SubscribeBlockItem(
                  child: Column(
                    children: [
                      /// #custom service box
                      Row(
                        children: [
                          /// #
                          CustomServiceBox(
                            imagePath: Assets.images.chat.path,
                            text: t.home.supportChats.title,
                            onTap: () => widget.tabController.animateTo(2),
                          ),
                          8.w,

                          /// #
                          CustomServiceBox(
                            maxLines: 2,
                            imagePath: Assets.images.chatVideo.path,
                            text: t.home.onlineConsultation.title,
                            onTap: () =>
                                context.pushNamed(AppViews.consultations),
                          ),
                        ],
                      ),
                      8.h,

                      /// #custom service box
                      Row(
                        children: [
                          /// #
                          CustomServiceBox(
                            imagePath: Assets.images.progress.path,
                            text: t.home.progressDiary.title,
                            onTap: () => widget.tabController.animateTo(1),
                          ),
                          8.w,

                          /// #
                          CustomServiceBox(
                            imagePath: Assets.images.moon.path,
                            text: t.home.musicForSleep.title,
                            onTap: () {
                              context
                                  .pushNamed(AppViews.servicesSleepMusicView);
                            },
                          ),
                        ],
                      ),
                      8.h,
                    ],
                  ),
                ),

                /// #long box
                CustomServiceBoxTwo(
                  imagePath: Assets.images.hat.path,
                  text: t.home.knowledgeCenter.title,
                  onTap: () {
                    context.pushNamed(AppViews.serviceKnowlegde);
                  },
                ),
              ],
            ),
          ),
          16.h,

          // if (articleStore.hasResults)

          if (widget.homeViewStore.allArticlesStore.listData.isNotEmpty)

            /// #current
            CustomBackground(
              height: null,
              padding: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.h,

                  /// #article category text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      t.home.current.title,
                      style: textTheme.headlineSmall?.copyWith(fontSize: 24),
                    ),
                  ),
                  16.h,

                  /// #articles

                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(
                          height: 250,
                          child: PaginatedLoadingWidget(
                            scrollDirection: Axis.horizontal,
                            store: widget.homeViewStore.allArticlesStore,
                            itemBuilder: (context, item, _) {
                              return ArticleBox(
                                model: item,
                              );
                            },
                          ))),
                  // ArticlesListView(
                  //   listData: articleStore.listData.toList(),
                  // ),

                  24.h,
                ],
              ),
            ),
          16.h,

          /// #for you
          // if (articleStore.listForMe.isNotEmpty)
          if (widget.homeViewStore.forMeArticlesStore.listData.isNotEmpty)
            CustomBackground(
                height: null,
                padding: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.h,

                      /// #article category text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          t.home.forYou.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      16.h,

                      /// #articles
                      // ArticlesListView(
                      //   listData: articleStore.listForMe.toList(),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                            height: 250,
                            child: PaginatedLoadingWidget(
                              scrollDirection: Axis.horizontal,
                              store: widget.homeViewStore.forMeArticlesStore,
                              itemBuilder: (context, item, _) {
                                return ArticleBox(
                                  model: item,
                                );
                              },
                            )),
                      ),
                      24.h,
                    ])),

          16.h
          //       SizedBox(height: 24),
        ],
      );
    });
  }
}
