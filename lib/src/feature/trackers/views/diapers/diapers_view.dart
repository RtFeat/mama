import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/diapers/diapers_dao_impl.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart' as skit;

class DiapersView extends StatelessWidget {
  const DiapersView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
              create: (context) => DiapersDataSourceLocal(
                  sharedPreferences:
                      context.read<Dependencies>().sharedPreferences)),
          Provider(
            create: (context) => DiapersStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
              onLoad: () => context.read<DiapersDataSourceLocal>().getIsShow(),
              onSet: (value) =>
                  context.read<DiapersDataSourceLocal>().setShow(value),
            ),
          ),
        ],
        builder: (context, _) {
          final UserStore userStore = context.watch<UserStore>();
          return _Body(
            store: context.watch(),
            childId: userStore.selectedChild?.id ?? '',
          );
        });
  }
}

class _Body extends StatefulWidget {
  final DiapersStore store;
  final String childId;
  const _Body({
    required this.store,
    required this.childId,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final format = DateFormat(
      'dd MMMM', LocaleSettings.currentLocale.flutterLocale.toLanguageTag());

  @override
  void initState() {
    widget.store.loadPage(queryParams: {
      'child_id': widget.childId,
      'from_time': widget.store.startOfWeek.toUtc().toIso8601String(),
      'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
    });

    widget.store.getIsShowInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return TrackerBody(
        learnMoreStore: widget.store,
        learnMoreWidgetText: t.trackers.findOutMoreTextDiapers,
        isShowLearnMore: widget.store.isShowInfo,
        onPressClose: () {
          widget.store.setIsShowInfo(false);
        },
        onPressLearnMore: () {},
        appBar: CustomAppBar(
          appBarColor: AppColors.deeperAppBarColor,
          title: t.trackers.trackersName.diapers,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          action: const ProfileWidget(),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: AppColors.trackerColor, fontSize: 20),
        ),
        stackWidget:

            /// #bottom buttons
            Align(
          alignment: Alignment.bottomCenter,
          child: ButtonsLearnPdfAdd(
            onTapLearnMore: () {},
            onTapPDF: () {},
            onTapAdd: () {
              context.pushNamed(AppViews.addDiaper);
            },
            iconAddButton: AppIcons.diaperFill,
          ),
        ),
        children: [
          SliverToBoxAdapter(child: 20.h),
          SliverToBoxAdapter(
            child: DateRangeSelectorWidget(
              startDate: widget.store.startOfWeek,
            ),
          ),
          SliverToBoxAdapter(child: 10.h),
          skit.PaginatedLoadingWidget(
            store: widget.store,
            isFewLists: true,
            itemBuilder: (context, item, index) {
              final DiapersMain diapersMain = item as DiapersMain;

              return BuildDaySection(
                  date: diapersMain.data ?? '$index',
                  items: diapersMain.diapersSub?.map((e) {
                    return BuilldGridItem(
                      time: 'time',
                      type: e.typeOfDiapers ?? '',
                      description: e.howMuch ?? '',
                      // AppColors.purpleLighterBackgroundColor,
                      // AppColors.primaryColor,
                    );
                  }).toList());
            },
          ),
        ],
      );
    });
  }
}
