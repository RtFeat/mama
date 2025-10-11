import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart' hide LocaleSettings;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartData {
  final double x; // Numerical x-value (days since first record)
  final double value;
  final String label; // Tooltip label (DD.MM)
  final String xLabel; // Month name for axis labels
  final int epochDays; // Absolute days since epoch for axis label reconstruction

  // Backward compatible: epochDays is optional and defaults to 0
  ChartData(this.x, this.value, this.label, this.xLabel, [this.epochDays = 0]);
}

class FlProgressChart extends StatelessWidget {
  final double min;
  final double max;
  final List<ChartData> chartData;

  const FlProgressChart({
    super.key,
    required this.min,
    required this.max,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    final data = chartData;
    final bool isSingle = data.length == 1;
    final double minX = data.isEmpty ? 0 : data.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final double maxX = data.isEmpty ? 0 : data.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    double pad = (maxX - minX).abs();
    if (pad < 15) pad = 30; // Ensure visibility for single/close points (~2 weeks)

    if (data.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.greyColorMedicard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart,
                size: 48,
                color: AppColors.greyBrighterColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Нет данных для отображения',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyBrighterColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    double xMin, xMax;
    if (data.isEmpty) {
      xMin = 0;
      xMax = 30;
    } else if (isSingle) {
      xMin = data.first.x - 1; // 1 day before
      xMax = data.first.x + 1; // 1 day after
    } else {
      xMin = minX - 5;
      xMax = maxX + 5;
    }

    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.transparent,
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
      ),
      primaryXAxis: NumericAxis(
        minimum: xMin,
        maximum: xMax,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          // Convert relative day to absolute using first point's epochDays
          final baseDays = data.isNotEmpty ? data.first.epochDays : 0;
          final days = baseDays + details.value.toInt();
          final date = DateTime.fromMillisecondsSinceEpoch(
            days * Duration.millisecondsPerDay,
            isUtc: false,
          );
          return ChartAxisLabel(
            DateFormat.MMM(
              LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
            ).format(date).capitalizeFirstLetter(),
            details.textStyle,
          );
        },
        axisLine: const AxisLine(color: Colors.transparent),
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
        isInversed: false,
        interval: 30,
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        minorGridLines: const MinorGridLines(color: Colors.transparent),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        minorTickLines: const MinorTickLines(color: Colors.transparent),
        axisLine: const AxisLine(color: Colors.transparent),
        minimum: min,
        maximum: max,
        interval: 1,
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
      ),
      series: <CartesianSeries<ChartData, double>>[
        if (!isSingle) ...[
          SplineAreaSeries<ChartData, double>(
            dataSource: data,
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
            borderWidth: 3,
          ),
          LineSeries<ChartData, double>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.value,
            markerSettings: const MarkerSettings(
              height: 9,
              width: 9,
              isVisible: true,
              borderColor: AppColors.greyColor,
              color: Colors.white,
            ),
            color: AppColors.primaryColor,
            width: 3,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              labelPosition: ChartDataLabelPosition.outside,
              margin: const EdgeInsets.only(bottom: 20),
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(
                              fontWeight: FontWeight.w400, 
                              fontSize: 8,
                              color: AppColors.greyBrighterColor,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        ScatterSeries<ChartData, double>(
          dataSource: data,
          xValueMapper: (ChartData d, _) => d.x,
          yValueMapper: (ChartData d, _) => d.value,
          markerSettings: const MarkerSettings(
            height: 10,
            width: 10,
            isVisible: true,
            borderColor: AppColors.greyColor,
            color: Colors.white,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: isSingle,
            labelAlignment: ChartDataLabelAlignment.top,
            labelPosition: ChartDataLabelPosition.outside,
            margin: const EdgeInsets.only(bottom: 20),
            builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                            fontWeight: FontWeight.w400, 
                            fontSize: 8,
                            color: AppColors.greyBrighterColor,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}