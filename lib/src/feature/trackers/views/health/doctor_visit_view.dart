import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class DoctorVisitScreen extends StatelessWidget {
  const DoctorVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorVisitStore doctorVisitStore = context.watch();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle? titlesStyle = textTheme.bodyMedium;

    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextDoctorVisit,
      onPressClose: () {},
      onPressLearnMore: () {},
      stackWidget:

          /// #bottom buttons
          Provider(
              create: (context) => DoctorVisitViewStore(
                  model: doctorVisitStore.doctorVisit,
                  restClient: context.read<Dependencies>().restClient),
              builder: (context, _) {
                final DoctorVisitViewStore store = context.watch();

                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonsLearnPdfAdd(
                        onTapLearnMore: () {},
                        onTapPDF: () {},
                        onTapAdd: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => Observer(builder: (_) {
                          // return AddMedicine(
                          //   titlesStyle: titlesStyle,
                          //   store: store,
                          //   medicineStore: medicineStore,
                          //   type: AddMedicineType.add,
                          // );
                          //     }),
                          //   ),
                          // );
                        },
                        titileAdd: t.trackers.doctor.calendarButton,
                        maxLinesAddButton: 2,
                        typeAddButton: CustomButtonType.outline,
                        iconAddButton: AppIcons.calendarBadgeCross,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16).copyWith(
                          top: 8,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 16.0, right: 16.0, left: 16.0),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Observer(builder: (_) {
                                  return AddDocVisit(
                                    titlesStyle: titlesStyle,
                                    store: store,
                                    doctorVisitStore: doctorVisitStore,
                                    type: AddDocVisitType.add,
                                  );
                                }),
                              ),
                            );
                          },
                          icon: AppIcons.stethoscope,
                        ),
                      ),
                    ],
                  ),
                );
              }),
      children: [
        /// #main content
        Column(
          children: [
            16.h,

            /// #doctor visit
            ListView.builder(
              shrinkWrap: true,
              itemCount: 2, // TODO изменить при подключении бэка на state
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // TODO редактирование приема
                    },
                    child: const PillAndDocVisitContainer(
                      // TODO настроить вывод приема
                      imageUrl: 'assets/images/on_boarding_3.png',
                      title: 'Педиатр Евраева',
                      timeDate: '24 сентября',
                      description:
                          'Температура скакала, записались на анализы и прописали сироп Нурофен чтобы ее сбивать Анализы сдаем завтра в 8:00 Купить безболезненный ланцет в аптеке на Ильича',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
