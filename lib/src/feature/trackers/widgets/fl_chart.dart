import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart' hide LocaleSettings;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartData {
  final double x; // Numerical x-value (day of year)
  final double value;
  final String label; // Tooltip label (DD.MM)
  final String xLabel; // Month name for axis labels

  ChartData(this.x, this.value, this.label, this.xLabel);
}

class FlProgressChart extends StatelessWidget {
  final double min;
  final double max;
  final List<ChartData> chartData;

  const FlProgressChart(
      {super.key,
      required this.min,
      required this.max,
      required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.transparent,
      // enableAxisAnimation: true,
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
      ),
      primaryXAxis: NumericAxis(
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          final date = DateTime(DateTime.now().year, 1, 1)
              .add(Duration(days: details.value.toInt()));
          return ChartAxisLabel(
              DateFormat.MMMM(
                LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
              )
                  .format(
                    date,
                  )
                  .capitalizeFirstLetter(),
              details.textStyle);
        },
        axisLine: const AxisLine(color: Colors.transparent),
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
        interval: 30,
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(
          color: Colors.transparent,
        ),
        minorGridLines: MinorGridLines(
          color: Colors.transparent,
        ),
        majorTickLines: MajorTickLines(
          color: Colors.transparent,
        ),
        minorTickLines: MinorTickLines(
          color: Colors.transparent,
        ),
        axisLine: const AxisLine(color: Colors.transparent),
        minimum: min,
        maximum: max,
        interval: 1,
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
      ),
      series: [
        SplineAreaSeries<ChartData, double>(
          dataSource: chartData,
          color: Colors.white,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.value,
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.green.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: Colors.green.withOpacity(0.3),
          borderWidth: 30,
        ),
        LineSeries<ChartData, double>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return SizedBox(
                  height: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${point.y}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: AppColors.blackColor),
                      ),
                      Text(
                        '${data.label}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w400, fontSize: 8),
                      ),
                    ],
                  ),
                );
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: AppColors.blackColor)),
          markerSettings: const MarkerSettings(
            height: 9,
            width: 9,
            isVisible: true,
            borderColor: AppColors.greyColor,
            color: Colors.white,
          ),
          color: AppColors.primaryColor,
          width: 3,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
