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
    
    // Calculate dynamic Y-axis range based on actual data FIRST
    // Limit to ~30 units range for better visualization
    double dynamicMin = min;
    double dynamicMax = max;
    
    if (data.isNotEmpty) {
      final double dataMin = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
      final double dataMax = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
      
      // Calculate center and create 30-unit range
      final double dataCenter = (dataMin + dataMax) / 2;
      final double dataRange = dataMax - dataMin;
      
      // If data range is small, use 30 units centered on data
      // If data range is large, add some padding
      if (dataRange < 25) {
        dynamicMin = ((dataCenter - 15) / 5).floorToDouble() * 5;
        dynamicMax = ((dataCenter + 15) / 5).ceilToDouble() * 5;
      } else {
        // For larger ranges, add 20% padding
        final padding = dataRange * 0.2;
        dynamicMin = ((dataMin - padding) / 5).floorToDouble() * 5;
        dynamicMax = ((dataMax + padding) / 5).ceilToDouble() * 5;
      }
      
      // Ensure minimum is never negative
      if (dynamicMin < 0) {
        dynamicMin = 0;
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
        interval: 5,
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
          SplineSeries<NormData, double>(
            dataSource: effectiveNormData,
            xValueMapper: (NormData data, _) => data.x,
            yValueMapper: (NormData data, _) => data.median,
            color: const Color(0xFF32CD32),
            width: 2,
          ),
        ],
        if (!isSingle) ...[
          // Old SplineAreaSeries removed - using norm zones instead
          SplineSeries<ChartData, double>(
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
                return Transform.translate(
                  offset: const Offset(14, 5), // Move down significantly
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vertical black line from marker upward
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
              return Transform.translate(
                offset: const Offset(0, 50), // Move down significantly
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vertical black line from marker upward
                    Container(
                      width: 2,
                      height: 50,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: false),
    );
  }
}