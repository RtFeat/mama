import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/entity/pumping_data.dart';
import 'package:skit/skit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphicWidget extends StatelessWidget {
  final List<GraphicData> listOfData;
  final String topColumnText;
  final String bottomColumnText;
  final double minimum;
  final double maximum;
  final double interval;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final String? rangeLabel;
  final String? averageLabel;
  const GraphicWidget(
      {super.key,
      required this.listOfData,
      required this.topColumnText,
      required this.bottomColumnText,
      required this.minimum,
      required this.maximum,
      required this.interval,
      this.onPrev,
      this.onNext,
      this.rangeLabel,
      this.averageLabel});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              // icon: SvgPicture.asset(
              //   Assets.icons.icArrowLeftFilled,
              //   height: 15,
              //   colorFilter: const ColorFilter.mode(
              //       AppColors.primaryColor, BlendMode.srcIn),
              // ),
              icon: const Icon(
                AppIcons.chevronBackward,
                color: AppColors.primaryColor,
              ),
              onPressed: onPrev,
            ),
            10.w,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(rangeLabel ?? '',
                    style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black)),
                Text(averageLabel ?? '',
                    style: textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.w400))
              ],
            ),
            10.w,
            IconButton(
              onPressed: onNext,
              // icon: SvgPicture.asset(
              //   height: 15,
              //   Assets.icons.icArrowRightFilled,
              //   colorFilter: const ColorFilter.mode(
              //       AppColors.primaryColor, BlendMode.srcIn),
              // ),
              icon: const Icon(AppIcons.chevronForward,
                  color: AppColors.primaryColor),
            ),
          ],
        ),
        10.h,
        SfCartesianChart(
          borderColor: Colors.transparent,
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          isTransposed: true,
          series: [
            StackedBarSeries<GraphicData, String>(
                width: 0.8,
                color: AppColors.purpleBrighterBackgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
                dataLabelSettings: DataLabelSettings(
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      final model = data as GraphicData;
                      if (model.bottom == 0) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '$bottomColumnText\n${model.bottom}',
                        textAlign: TextAlign.center,
                        style: textTheme.labelSmall
                            ?.copyWith(color: AppColors.trackerColor),
                      );
                    },
                    margin: const EdgeInsets.only(top: 0),
                    isVisible: true,
                    showCumulativeValues: true),
                dataSource: listOfData,
                xValueMapper: (GraphicData data, _) => data.weekDay,
                yValueMapper: (GraphicData data, _) => data.bottom),
            StackedBarSeries<GraphicData, String>(
                width: 0.8,
                color: AppColors.greenBrighterBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                dataLabelSettings: DataLabelSettings(
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      final model = data as GraphicData;
                      if (model.top == 0) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '$topColumnText\n${model.top}',
                        textAlign: TextAlign.center,
                        style: textTheme.labelSmall
                            ?.copyWith(color: AppColors.trackerColor),
                      );
                    },
                    margin: const EdgeInsets.only(top: 0),
                    isVisible: true,
                    showCumulativeValues: false),
                dataSource: listOfData,
                xValueMapper: (GraphicData data, _) => data.weekDay,
                yValueMapper: (GraphicData data, _) => data.top),
          ],
          primaryXAxis: CategoryAxis(
            tickPosition: TickPosition.outside,
            labelStyle:
                textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelStyle:
                textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
            minimum: minimum,
            maximum: maximum,
            interval: interval,
          ),
        ),
      ],
    );
  }
}
