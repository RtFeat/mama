import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/diapers/diapers_dao_impl.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

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
              apiClient: context.read<Dependencies>().apiClient,
              onLoad: () => context.read<DiapersDataSourceLocal>().getIsShow(),
              onSet: (value) =>
                  context.read<DiapersDataSourceLocal>().setShow(value),
            ),
          ),
        ],
        builder: (context, _) {
          return _Body(
            store: context.watch(),
          );
        });
  }
}

class _Body extends StatefulWidget {
  final DiapersStore store;
  const _Body({
    required this.store,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage(
        queryParams: {'child_id': '5533793a-4752-4378-ac45-7ebdbe2f2f45'});

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
          20.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {},
              ),
              Column(
                children: [
                  Text(
                    '11 сентября - 17 сентября',
                    style: AppTextStyles.f14w400,
                  ),
                  Text(
                    t.trackers.diaperforday,
                    style: AppTextStyles.f10w400,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          10.h,
          // Основное содержимое календаря
          BuildDaySection('17\nсентября', [
            BuilldGridItem(
              '09:56',
              t.trackers.wet.wet,
              t.trackers.wet.many,
              AppColors.purpleLighterBackgroundColor,
              AppColors.primaryColor,
            ),
            BuilldGridItem(
              '11:25',
              t.trackers.dirty.dirty,
              t.trackers.dirty.solid,
              AppColors.yellowBackgroundColor,
              AppColors.orangeTextColor,
            ),
            BuilldGridItem(
              '13:30',
              t.trackers.mixed.mixed,
              t.trackers.mixed.soft,
              AppColors.greenLighterBackgroundColor,
              AppColors.greenTextColor,
            ),
            BuilldGridItem(
              '15:00',
              t.trackers.wet.wet,
              t.trackers.wet.average,
              AppColors.purpleLighterBackgroundColor,
              AppColors.primaryColor,
            ),
            BuilldGridItem(
              '18:00',
              t.trackers.mixed.mixed,
              t.trackers.mixed.soft,
              AppColors.greenLighterBackgroundColor,
              AppColors.greenTextColor,
            ),
            BuilldGridItem(
              '20:00',
              t.trackers.wet.wet,
              t.trackers.wet.littleBit,
              AppColors.purpleLighterBackgroundColor,
              AppColors.primaryColor,
            ),
          ]),
          const SizedBox(height: 70),
        ],
      );
    });
  }
}
