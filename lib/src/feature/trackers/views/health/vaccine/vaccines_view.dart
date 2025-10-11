import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart' hide Space;

class VaccinesScreen extends StatelessWidget {
  const VaccinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (context) => VaccineDataSourceLocal(
                sharedPreferences:
                    context.read<Dependencies>().sharedPreferences)),
        Provider(create: (context) {
          return VaccinesStore(
            apiClient: context.read<Dependencies>().apiClient,
            onLoad: () => context.read<VaccineDataSourceLocal>().getIsShow(),
            onSet: (value) =>
                context.read<VaccineDataSourceLocal>().setShow(value),
            faker: context.read<Dependencies>().faker,
          );
        })
      ],
      builder: (context, child) {
        final VaccinesStore store = context.watch();
        final UserStore userStore = context.watch<UserStore>();

        return _Body(
          store: store,
          childId: userStore.selectedChild?.id ?? '',
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.store,
    required this.childId,
  });

  final VaccinesStore store;
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
      learnMoreWidgetText: t.trackers.findOutMoreTextVaccinations,
      // learnMoreStore: widget.store,

      isShowInfo: widget.store.isShowInfo,
      setIsShowInfo: (v) {
        widget.store.setIsShowInfo(v).then((v) {
          setState(() {});
        });
      },
      onPressLearnMore: () {
        context.pushNamed(AppViews.serviceKnowlegde);
      },
      bottomNavigatorBar: ButtonsLearnPdfAdd(
        onTapLearnMore: () {
          context.pushNamed(AppViews.serviceKnowlegde);
        },
        onTapPDF: () {
          PdfService.generateAndViewVaccinePdf(
            context: context,
            typeOfPdf: 'vaccines',
            title: t.trackers.vaccinations.title,
            onStart: () => _showSnack(context, 'Генерация PDF...', bg: const Color(0xFFE1E6FF)),
            onSuccess: () => _showSnack(context, 'PDF успешно создан!', bg: const Color(0xFFDEF8E0), seconds: 3),
            onError: (message) => _showSnack(context, message),
          );
        },
        onTapAdd: () {
          context.pushNamed(AppViews.vaccinesCalendar);
        },
        titileAdd: t.trackers.vaccines.calendarButton,
        maxLinesAddButton: 2,
        typeAddButton: CustomButtonType.outline,
        iconAddButton: AppIcons.calendarBadgeCross,
      ),
      // stackWidget:

      //     /// #bottom buttons
      //     Align(
      //   alignment: Alignment.bottomCenter,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       ButtonsLearnPdfAdd(
      //         onTapLearnMore: () {},
      //         onTapPDF: () {},
      //         onTapAdd: () {
      //           context.pushNamed(AppViews.vaccinesCalendar);
      //         },
      //         titileAdd: t.trackers.vaccines.calendarButton,
      //         maxLinesAddButton: 2,
      //         typeAddButton: CustomButtonType.outline,
      //         iconAddButton: AppIcons.calendarBadgeCross,
      //       ),
      //     ],
      //   ),
      // ),
      children: [
        /// #main content
        SliverToBoxAdapter(
            child: Column(children: [
          SizedBox(height: 16.h),
          _Header(),
          SizedBox(height: 5.h),
        ])),

        PaginatedLoadingWidget(
            store: widget.store,
            itemsPadding: EdgeInsets.all(4),
            isFewLists: true,
            emptyData: SliverToBoxAdapter(child: SizedBox.shrink()),
            additionalLoadingWidget:
                SliverToBoxAdapter(child: SizedBox.shrink()),
            initialLoadingWidget: SliverToBoxAdapter(child: SizedBox.shrink()),
            itemBuilder: (context, item, index) {
              final EntityVaccinationMain model = item;

              return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      AppViews.addVaccine,
                      extra: {
                        'data': model,
                        'store': widget.store,
                      },
                    );
                  },
                  child: VaccineContainer(
                    model: model,
                  ));
            }),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 100.0,
            ),
            child: CustomButton(
              height: 48,
              borderRadius: 16,
              width: double.infinity,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 5,
              ),
              title: t.trackers.vaccines.addNewButton,
              maxLines: 1,
              onTap: () {
                context.pushNamed(
                  AppViews.addVaccine,
                  extra: {
                    'store': widget.store,
                  },
                );
              },
              icon: AppIcons.syringeFill,
              iconSize: 28,
            ),
          ),
        )
      ],
    );
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 5,
          child: AutoSizeText(
            t.trackers.vaccines.vaccinesListTitle1,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(letterSpacing: -0.5),
          ),
        ),
        Expanded(
          flex: 2,
          child: AutoSizeText(
            t.trackers.vaccines.vaccinesListTitle2,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(letterSpacing: -0.5),
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                child: AutoSizeText(
                  t.trackers.vaccines.vaccinesListTitle3,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(letterSpacing: -0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//TODO при повторном заходе на страницу срабаотывает ошибка  Exception has occurred. LateError (LateInitializationError: Field 'formGroup' has already been initialized.)

List<VaccineItem> listVaccines = [
  VaccineItem(
    vaccineName: 'Вирусный гепатит В, первая прививка (ВГВ-1)',
    recommendedAge: 'Первые 24 часа жизни',
  ),
  VaccineItem(
    vaccineName: 'Туберкулез (БЦЖ)',
    recommendedAge: '3–7 сутки жизни',
    isDone: true,
    date: '4 июля 2023',
  ),
  VaccineItem(
    vaccineName: 'Вирусный гепатит В, вторая прививка (ВГВ-2)',
    recommendedAge: '1 месяц',
  ),
  VaccineItem(
    vaccineName: 'Пневмококковая инфекция, первая прививка',
    recommendedAge: '2 месяца',
  ),
  VaccineItem(
    vaccineName:
        'АКДС: Дифтерия, коклюш, столбняк и полиомиелит, первая прививка (АКДС-1)',
    recommendedAge: '3 месяца',
  ),
  VaccineItem(
    vaccineName: 'Хиб-инфекция (гемофильная инфекция) типа b, первая прививка',
    recommendedAge: '4–5 месяцев',
  ),
  VaccineItem(
    vaccineName:
        'АКДС: Дифтерия, коклюш, столбняк и полиомиелит, вторая прививка (АКДС-2)',
    recommendedAge: '4–5 месяцев',
  ),
  VaccineItem(
    vaccineName: 'Пневмококковая инфекция, вторая прививка',
    recommendedAge: '4–5 месяцев',
    recommendedAgeSubtitle: 'Зависит от даты первой прививки',
  ),
  VaccineItem(
    vaccineName: 'Вирусный гепатит В, третья прививка (ВГВ-3)',
    recommendedAge: '4–5 месяцев',
  ),
  VaccineItem(
    vaccineName: 'Хиб-инфекция (гемофильная инфекция) типа b, вторая прививка',
    recommendedAge: '4–5 месяцев',
  ),
  VaccineItem(
    vaccineName: 'Пневмококковая инфекция, третья прививка',
    recommendedAge: '6 месяцев',
    recommendedAgeSubtitle: 'Зависит от даты первой прививки',
  ),
  VaccineItem(
    vaccineName: 'Вирусный гепатит В, третья прививка (ВГВ-4)',
    recommendedAge: '12 месяцев',
  ),
  VaccineItem(
    vaccineName: 'Пневмококковая инфекция, четвертая прививка',
    recommendedAge: '15 месяцев',
    recommendedAgeSubtitle: 'Зависит от даты первой прививки',
  ),
];
