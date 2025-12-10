import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/home/home.dart';
import 'package:mama/src/feature/home/widgets/calendar/calendar.dart';
import 'package:skit/skit.dart';

class HomeSpecialistBody extends StatefulWidget {
  final HomeViewStore homeViewStore;
  final UserStore userStore;
  final DoctorStore doctorStore;
  const HomeSpecialistBody({
    super.key,
    required this.homeViewStore,
    required this.userStore,
    required this.doctorStore,
  });

  @override
  State<HomeSpecialistBody> createState() => _HomeSpecialistBodyState();
}

class _HomeSpecialistBodyState extends State<HomeSpecialistBody> {
  @override
  void initState() {
    widget.homeViewStore.loadOwnArticles(widget.userStore.account.id!);
    widget.doctorStore.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return LoadingWidget(
      future: widget.doctorStore.fetchFuture,
      builder: (data) => Observer(builder: (context) {
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

            16.h,

            const SpecialistCalendarWidget(),

            16.h,
            if (widget.homeViewStore.ownArticlesStore.listData.isNotEmpty)

              /// #my articles
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
                        t.home.yourArticles,
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
                              store: widget.homeViewStore.ownArticlesStore,
                              itemBuilder: (context, item, _) {
                                return ArticleBox(
                                  model: item,
                                );
                              },
                            ))),
                    24.h,
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}
