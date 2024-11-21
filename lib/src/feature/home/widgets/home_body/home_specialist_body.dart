import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/home/home.dart';

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

    final meetingsListOne = [
      for (int i = 0; i < 5; i++)
        MeetingBox(
          scheduledTime: t.home.timeScheduleOne.title,
          meetingType: t.home.chat.title,
          isCancelled: i == 2 ? true : false,
          tutorFullName: t.home.tutorFullNameOne.title,
          whichSection: 1,
        ),
    ];

    final meetingsListTwo = [
      for (int i = 0; i < 7; i++)
        MeetingBox(
          scheduledTime: t.home.timeScheduleOne.title,
          meetingType: t.home.chat.title,
          isCancelled: false,
          tutorFullName: t.home.tutorFullNameOne.title,
          whichSection: 2,
        ),
    ];

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

            /// #meetings
            CustomBackground(
              padding: 16,
              height: null,
              child: Column(
                children: [
                  /// #switch section
                  DateSwitchSection(
                    leftButtonOnPressed: () {},
                    rightButtonOnPressed: () {},
                    calendarButtonOnPressed: () {},
                  ),
                  const SizedBox(height: 8),

                  /// #meetings section one
                  MeetingsSection(
                    whichSection: 1,
                    meetingsList: meetingsListOne,
                  ),
                  8.h,

                  /// #meetings section two
                  MeetingsSection(
                    whichSection: 2,
                    meetingsList: meetingsListTwo,
                  ),
                ],
              ),
            ),
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
                              store: widget.homeViewStore.allArticlesStore,
                              itemBuilder: (context, item) {
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
