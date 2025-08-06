import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class TemperatureView extends StatelessWidget {
  const TemperatureView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) {
        return TemperatureStore(
            apiClient: context.read<Dependencies>().apiClient,
            faker: context.read<Dependencies>().faker);
      },
      builder: (context, child) {
        final TemperatureStore store = context.watch();

        return TrackerBody(
          learnMoreWidgetText: t.trackers.findOutMoreTextTemp,
          onPressClose: () {},
          onPressLearnMore: () {},
          stackWidget:

              /// #bottom buttons
              Align(
            alignment: Alignment.bottomCenter,
            child: ButtonsLearnPdfAdd(
              onTapLearnMore: () {},
              onTapPDF: () {},
              onTapAdd: () {
                context.pushNamed(AppViews.trackersHealthAddMedicineView);
              },
              iconAddButton: AppIcons.thermometer,
              addButtonTextStyle:
                  Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 17,
                      ),
            ),
          ),
          children: [
            SliverToBoxAdapter(child: 14.h),

            /// #actual table
            SliverToBoxAdapter(
                child: TemperatureHistory(
              store: context.watch(),
              childId: context.watch<UserStore>().selectedChild?.id,
            )),
          ],
        );
      },
    );
  }
}
