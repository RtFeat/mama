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

class NormData {
  final double x;
  final double median;
  final double sd1Lower;
  final double sd1Upper;
  final double sd2Lower;
  final double sd2Upper;
  final double sd3Lower;
  final double sd3Upper;

  NormData({
    required this.x,
    required this.median,
    required this.sd1Lower,
    required this.sd1Upper,
    required this.sd2Lower,
    required this.sd2Upper,
    required this.sd3Lower,
    required this.sd3Upper,
  });
}

class FlProgressChart extends StatelessWidget {
  final double min;
  final double max;
  final List<ChartData> chartData;
  final List<NormData>? normData;

  const FlProgressChart({
    super.key,
    required this.min,
    required this.max,
    required this.chartData,
    this.normData,
  });

  @override
  Widget build(BuildContext context) {
    final data = chartData;
    final bool isSingle = data.length == 1;
    final double minX = data.isEmpty ? 0 : data.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final double maxX = data.isEmpty ? 0 : data.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    double pad = (maxX - minX).abs();
    if (pad < 15) pad = 30; // Ensure visibility for single/close points (~2 weeks)
    
    // Use provided min/max as base, but expand if data goes beyond
    double dynamicMin = min;
    double dynamicMax = max;
    
    if (data.isNotEmpty) {
      final double dataMin = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
      final double dataMax = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
      
      // If data goes below min, expand downward
      if (dataMin < dynamicMin) {
        dynamicMin = (dataMin / 5).floorToDouble() * 5;
        if (dynamicMin < 0) dynamicMin = 0;
      }
      
      // If data goes above max, expand upward
      if (dataMax > dynamicMax) {
        dynamicMax = (dataMax / 5).ceilToDouble() * 5;
      }
    }
    
    // Use provided norm data (should come from WHO standards via backend)
    List<NormData>? effectiveNormData = normData;
    // Note: normData should contain WHO growth standards (median and SD)
    // for each age point, not follow the actual child's data

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
      xMin = minX - 2; // Reduced padding
      xMax = maxX + 15; // More padding on right for labels
    }

    return SfCartesianChart(
      plotAreaBackgroundColor: const Color(0xFFF5F5F5), // Серый фон как на скрине
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
        majorGridLines: const MajorGridLines(
          width: 1,
          color: Colors.white, // Вертикальные белые линии сетки
        ),
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
        minimum: dynamicMin,
        maximum: dynamicMax,
        interval: _calculateYAxisInterval(dynamicMin, dynamicMax),
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
      ),
      series: <CartesianSeries>[
        // Norm zones (if provided) - draw from widest to narrowest
        if (effectiveNormData != null && effectiveNormData.isNotEmpty) ...[
          // -3SD to +3SD zone (lightest green - furthest from median)
          RangeAreaSeries<NormData, double>(
            dataSource: effectiveNormData,
            xValueMapper: (NormData data, _) => data.x,
            highValueMapper: (NormData data, _) => data.sd3Upper,
            lowValueMapper: (NormData data, _) => data.sd3Lower,
            color: const Color(0xFF90EE90).withOpacity(0.2),
            borderColor: Colors.transparent,
            borderWidth: 0,
          ),
          // -2SD to +2SD zone (medium green)
          RangeAreaSeries<NormData, double>(
            dataSource: effectiveNormData,
            xValueMapper: (NormData data, _) => data.x,
            highValueMapper: (NormData data, _) => data.sd2Upper,
            lowValueMapper: (NormData data, _) => data.sd2Lower,
            color: const Color(0xFF90EE90).withOpacity(0.35),
            borderColor: Colors.transparent,
            borderWidth: 0,
          ),
          // -1SD to +1SD zone (darkest green - closest to median)
          RangeAreaSeries<NormData, double>(
            dataSource: effectiveNormData,
            xValueMapper: (NormData data, _) => data.x,
            highValueMapper: (NormData data, _) => data.sd1Upper,
            lowValueMapper: (NormData data, _) => data.sd1Lower,
            color: const Color(0xFF90EE90).withOpacity(0.5),
            borderColor: Colors.transparent,
            borderWidth: 0,
          ),
          // Median line (green)
          LineSeries<NormData, double>(
            dataSource: effectiveNormData,
            xValueMapper: (NormData data, _) => data.x,
            yValueMapper: (NormData data, _) => data.median,
            color: const Color(0xFF32CD32),
            width: 2,
          ),
        ],
        if (!isSingle) ...[
          // Straight lines with sharp angles between points
          LineSeries<ChartData, double>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.value,
            markerSettings: const MarkerSettings(
              height: 9,
              width: 9,
              isVisible: true,
              borderColor: Color(0xFFBDBDBD), // Серая обводка точек
              color: Colors.white,
              borderWidth: 2,
            ),
            color: const Color(0xFF4169E1), // Синий цвет линии как на скрине
            width: 3,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              labelPosition: ChartDataLabelPosition.outside,
              margin: EdgeInsets.zero,
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${point.y}',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${data.label}',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                            fontWeight: FontWeight.w400, 
                            fontSize: 9,
                            color: const Color(0xFF9E9E9E),
                          ),
                    ),
                  ],
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
            borderColor: Color(0xFFBDBDBD),
            color: Colors.white,
            borderWidth: 2,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: isSingle,
            labelAlignment: ChartDataLabelAlignment.top,
            labelPosition: ChartDataLabelPosition.outside,
            margin: const EdgeInsets.only(bottom: 15),
            builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${point.y}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${data.label}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(
                          fontWeight: FontWeight.w400, 
                          fontSize: 9,
                          color: const Color(0xFF9E9E9E),
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: false),
    );
  }

  /// Calculate appropriate Y-axis interval based on the data range
  double _calculateYAxisInterval(double min, double max) {
    final range = max - min;
    
    // For small ranges (like weight 2-9 kg), use interval of 1
    if (range <= 10) {
      return 1;
    }
    // For medium ranges (like height 0-50 cm), use interval of 5
    else if (range <= 50) {
      return 5;
    }
    // For larger ranges, use interval of 10
    else {
      return 10;
    }
  }
}