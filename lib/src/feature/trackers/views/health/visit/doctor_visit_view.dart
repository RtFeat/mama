import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class DoctorVisitScreen extends StatelessWidget {
  const DoctorVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
              create: (context) => DoctorVisitsDataSourceLocal(
                  sharedPreferences:
                      context.read<Dependencies>().sharedPreferences)),
          Provider(create: (context) {
            return DoctorVisitsStore(
              apiClient: context.read<Dependencies>().apiClient,
              onLoad: () {
                return context.read<DoctorVisitsDataSourceLocal>().getIsShow();
              },
              onSet: (value) {
                return context
                    .read<DoctorVisitsDataSourceLocal>()
                    .setShow(value);
              },
              faker: context.read<Dependencies>().faker,
            );
          })
        ],
        builder: (context, _) {
          final DoctorVisitsStore store = context.watch();
          final UserStore userStore = context.watch<UserStore>();

          return _Body(
            store: store,
            childId: userStore.selectedChild?.id ?? '',
          );
        });
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.store,
    required this.childId,
  });

  final DoctorVisitsStore store;
  final String childId;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: widget.childId),
    ]);

    widget.store.getIsShowInfo().then((v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextDoctorVisit,
      // learnMoreStore: widget.store,
      onPressLearnMore: () {},
      isShowInfo: widget.store.isShowInfo,
      setIsShowInfo: (v) {
        widget.store.setIsShowInfo(v).then((v) {
          setState(() {});
        });
      },
      bottomNavigatorBar:

          /// #bottom buttons

          SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonsLearnPdfAdd(
              onTapLearnMore: () {},
              onTapPDF: () {},
              onTapAdd: () {},
              titileAdd: t.trackers.doctor.calendarButton,
              maxLinesAddButton: 2,
              typeAddButton: CustomButtonType.outline,
              iconAddButton: AppIcons.calendarBadgeCross,
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
                top: 8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
              child: CustomButton(
                height: 55,
                width: double.infinity,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                title: t.trackers.doctor.addNewVisitButton,
                maxLines: 1,
                onTap: () {
                  context.pushNamed(AppViews.addVisit,
                      extra: {'data': null, 'store': widget.store});
                },
                icon: AppIcons.stethoscope,
              ),
            ),
          ],
        ),
      ),
      children: [
        SliverToBoxAdapter(child: 16.h),
        PaginatedLoadingWidget(
            store: widget.store,
            itemsPadding: EdgeInsets.all(8),
            isFewLists: true,
            emptyData: SliverToBoxAdapter(child: SizedBox.shrink()),
            additionalLoadingWidget:
                SliverToBoxAdapter(child: SizedBox.shrink()),
            initialLoadingWidget: SliverToBoxAdapter(child: SizedBox.shrink()),
            itemBuilder: (context, item, index) {
              final EntityMainDoctor model = item;

              final bool hasImage =
                  model.photos != null && model.photos!.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  context.pushNamed(AppViews.addVisit,
                      extra: {'data': model, 'store': widget.store});
                },
                child: PillAndDocVisitContainer(
                    imageUrl:
                        !model.isLocal && hasImage ? model.photos![0] : null,
                    imagePath:
                        model.isLocal && hasImage ? model.photos![0] : null,
                    title: model.doctor ?? '',
                    timeDate: model.date,
                    description: model.notes),
              );
            }),
      ],
    );
  }
}
