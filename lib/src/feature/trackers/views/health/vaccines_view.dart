import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class VaccinesScreen extends StatelessWidget {
  const VaccinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VaccinesStore vaccinesStore = context.watch();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle? titlesStyle = textTheme.bodyMedium;

    return Provider(
        create: (context) => VaccinesViewStore(
            model: vaccinesStore.vaccine,
            restClient: context.read<Dependencies>().restClient),
        builder: (context, _) {
          final VaccinesViewStore store = context.watch();
          return TrackerBody(
            learnMoreWidgetText: t.trackers.findOutMoreTextVaccinations,
            onPressClose: () {},
            onPressLearnMore: () {},
            stackWidget:

                /// #bottom buttons
                Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonsLearnPdfAdd(
                    onTapLearnMore: () {},
                    onTapPDF: () {},
                    onTapAdd: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CalendarVaccines(),
                        ),
                      );
                    },
                    titileAdd: t.trackers.vaccines.calendarButton,
                    maxLinesAddButton: 2,
                    typeAddButton: CustomButtonType.outline,
                    iconAddButton: AppIcons.calendarBadgeCross,
                  ),
                ],
              ),
            ),
            children: [
              /// #main content
              Column(
                children: [
                  16.h,

                  /// #doctor visit
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: listVaccines.length,
                    itemBuilder: (BuildContext context, int index) {
                      VaccineItem item = listVaccines[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: item.isDone
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Observer(
                                        builder: (_) {
                                          return AddVaccine(
                                            titlesStyle: titlesStyle,
                                            nameVaccine: item.vaccineName,
                                            recomendedAge: item.recommendedAge,
                                            store: store,
                                            vaccinesStore: vaccinesStore,
                                            type: AddVaccineType.fromList,
                                            editType: EditVaccineType.edit,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: VaccineContainer(
                            nameVaccine: item.vaccineName,
                            recommendedAge: item.recommendedAge,
                            timeDate: item.date,
                            recommendedAgeSubtitle: item.recommendedAgeSubtitle,
                            isDone: item.isDone,
                            onTapAdd: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Observer(
                                    builder: (_) {
                                      return AddVaccine(
                                        titlesStyle: titlesStyle,
                                        nameVaccine: item.vaccineName,
                                        recomendedAge: item.recommendedAge,
                                        store: store,
                                        vaccinesStore: vaccinesStore,
                                        type: AddVaccineType.fromList,
                                        editType: EditVaccineType.add,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      // top: 8.0,
                      bottom: 100.0,
                    ),
                    child: CustomButton(
                      height: 55,
                      width: double.infinity,
                      // contentPadding: const EdgeInsets.symmetric(
                      //   vertical: 8,
                      //   horizontal: 5,
                      // ),
                      title: t.trackers.vaccines.addNewButton,
                      maxLines: 1,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Observer(builder: (_) {
                              return AddVaccine(
                                titlesStyle: titlesStyle,
                                store: store,
                                vaccinesStore: vaccinesStore,
                                type: AddVaccineType.newVac,
                                editType: EditVaccineType.add,
                              );
                            }),
                          ),
                        );
                      },
                      icon: AppIcons.syringeFill,
                      iconSize: 28,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
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
