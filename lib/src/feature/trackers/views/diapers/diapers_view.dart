import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:mama/src/feature/trackers/state/diapers/diapers_dao_impl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart' as skit;
import 'package:skit/skit.dart';

class DiapersView extends StatelessWidget {
  const DiapersView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO нужно учесть utc время и переход на следующий день - где-то в slots.dart есть реализация.

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
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      skit.SkitFilter(
          field: 'child_id',
          operator: skit.FilterOperator.equals,
          value: widget.childId),
      skit.SkitFilter(
          field: 'from_time',
          operator: skit.FilterOperator.equals,
          value: widget.store.startOfWeek.toUtc().toIso8601String()),
      skit.SkitFilter(
          field: 'to_time',
          operator: skit.FilterOperator.equals,
          value: widget.store.endOfWeek.toUtc().toIso8601String())
    ]
        //   queryParams: {
        //   'child_id': widget.childId,
        //   'from_time': widget.store.startOfWeek.toUtc().toIso8601String(),
        //   'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
        // }
        );

    widget.store.getIsShowInfo().then((v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return TrackerBody(
        // learnMoreStore: widget.store,

        isShowInfo: widget.store.isShowInfo,
        setIsShowInfo: (v) {
          widget.store.setIsShowInfo(v).then((v) {
            setState(() {});
          });
        },
        learnMoreWidgetText: t.trackers.findOutMoreTextDiapers,
        onPressLearnMore: () {
          context.pushNamed(AppViews.serviceKnowlegde);
        },
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
        bottomNavigatorBar: ButtonsLearnPdfAdd(
          onTapLearnMore: () {
            // TODO change url
            context.pushNamed(AppViews.webView, extra: {
              'url': 'https://google.com',
            });
          },
          onTapPDF: () {
            PdfService.generateAndViewDiapersPdf(
              context: context,
              typeOfPdf: 'diapers',
              title: t.trackers.trackersName.diapers,
              onStart: () => _showSnack(context, 'Генерация PDF...', bg: const Color(0xFFE1E6FF)),
              onSuccess: () => _showSnack(context, 'PDF успешно создан!', bg: const Color(0xFFDEF8E0), seconds: 3),
              onError: (message) => _showSnack(context, message),
            );
          },
          onTapAdd: () {
            context.pushNamed(AppViews.addDiaper, extra: {
              'onSave': (DiapersCreateDiaperDto data) {
                logger.info('Time: ${data.timeToEnd}');
                DateTime? time = DateTime.tryParse(data.timeToEnd ?? '');

                final String day =
                    '${time?.day} ${t.home.monthsData.withNumbers[(time?.month ?? 1) - 1]}';

                final EntityDiapersMain? item = widget.store.listData
                    .firstWhereOrNull((element) => element.data == day);

                if (item != null) {
                  item.diapersSub?.add(EntityDiapersSubMain(
                    howMuch: data.howMuch,
                    notes: data.howMuch,
                    time: time?.formattedTime ?? 'time',
                    typeOfDiapers: data.typeOfDiapers,
                  ));
                } else {
                  widget.store.listData.add(EntityDiapersMain(
                      data:
                          '${time?.day} ${t.home.monthsData.withNumbers[(time?.month ?? 1) - 1]}',
                      diapersSub: ObservableList.of([
                        EntityDiapersSubMain(
                          howMuch: data.howMuch,
                          notes: data.howMuch,
                          time: time?.formattedTime ?? 'time',
                          typeOfDiapers: data.typeOfDiapers,
                        )
                      ])));
                }
              }
            });
          },
          iconAddButton: AppIcons.diaperFill,
        ),
        children: [
          SliverToBoxAdapter(child: 20.h),
          SliverToBoxAdapter(
            child: DateRangeSelectorWidget(
              startDate: widget.store.startOfWeek,
              subtitle: t.trackers.diaper
                  .averageCount(n: widget.store.averageOfDiapers),
              onLeftTap: () {
                widget.store.resetPagination();
                widget.store.setSelectedDate(
                    widget.store.startOfWeek.subtract(const Duration(days: 7)));
                widget.store.loadPage(newFilters: [
                  skit.SkitFilter(
                      field: 'child_id',
                      operator: skit.FilterOperator.equals,
                      value: widget.childId),
                  skit.SkitFilter(
                      field: 'from_time',
                      operator: skit.FilterOperator.greaterThan,
                      value:
                          widget.store.startOfWeek.toUtc().toIso8601String()),
                  skit.SkitFilter(
                      field: 'to_time',
                      operator: skit.FilterOperator.lessThan,
                      value: widget.store.endOfWeek.toUtc().toIso8601String()),
                ]
                    //   queryParams: {
                    //   'child_id': widget.childId,
                    //   'from_time': widget.store.startOfWeek
                    //     ..toUtc().toIso8601String(),
                    //   'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
                    // }
                    );
              },
              onRightTap: () {
                widget.store.resetPagination();
                widget.store.setSelectedDate(
                    widget.store.startOfWeek.add(const Duration(days: 7)));
                widget.store.loadPage(
                  newFilters: [
                    skit.SkitFilter(
                        field: 'child_id',
                        operator: skit.FilterOperator.equals,
                        value: widget.childId),
                    skit.SkitFilter(
                        field: 'from_time',
                        operator: skit.FilterOperator.greaterThan,
                        value:
                            widget.store.startOfWeek.toUtc().toIso8601String()),
                    skit.SkitFilter(
                        field: 'to_time',
                        operator: skit.FilterOperator.lessThan,
                        value:
                            widget.store.endOfWeek.toUtc().toIso8601String()),
                  ],
                  //   queryParams: {
                  //   'child_id': widget.childId,
                  //   'from_time': widget.store.startOfWeek
                  //     ..toUtc().toIso8601String(),
                  //   'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
                  // }
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: 10.h),
          skit.PaginatedLoadingWidget(
            store: widget.store,
            isFewLists: true,
            emptyData: SliverToBoxAdapter(child: SizedBox.shrink()),
            itemBuilder: (context, item, index) {
              final EntityDiapersMain diapersMain = item;

              return BuildDaySection(
                  date: diapersMain.data,
                  // date: diapersMain.data ?? '$index',
                  items: diapersMain.diapersSub?.map((e) {
                    final dateTime = DateTime.utc(
                      0,
                      0,
                      0,
                      int.parse(e.time!.split(':')[0]),
                      int.parse(e.time!.split(':')[1]),
                    ).toLocal();

                    return BuildGridItem(
                      time: dateTime.formattedTime,
                      title: e.typeOfDiapers ?? '',
                      // type: switch (e.typeOfDiapers) {
                      //   ''
                      // },
                      // type: e.typeOfDiapers ?? '',
                      type: TypeOfDiapers.dirty,
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

  void _showSnack(BuildContext ctx, String message, {Color? bg, int seconds = 2}) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        // Определяем цвет текста в зависимости от сообщения
        Color textColor = Colors.white; // по умолчанию
        if (message == 'Генерация PDF...') {
          textColor = const Color(0xFF4D4DE8); // primaryColor
        } else if (message == 'PDF успешно создан!') {
          textColor = const Color(0xFF059613); // greenLightTextColor
        }
        
        ScaffoldMessenger.of(ctx)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            backgroundColor: bg,
            duration: Duration(seconds: seconds),
          ));
      } catch (e) {
        // Ignore snackbar errors
      }
    });
  }
}
