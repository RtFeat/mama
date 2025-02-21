import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightData {
  final String month;
  final double weight;
  final String label;

  WeightData(this.month, this.weight, this.label);
}

class FlProgressChart extends StatelessWidget {
  const FlProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WeightData> chartData = [
      WeightData('Январь', 2.35, '17.07'),
      WeightData('Февраль', 3.25, '31.08'),
      WeightData('Март', 5.25, '31.08'),
      WeightData('Апрель', 4.25, '31.08'),
      WeightData('Май', 6.25, '31.08'),
      WeightData('Июнь', 6.25, '31.08'),
      WeightData('Июль', 3.7, '13.05'),
      WeightData('Август', 4.9, '03.07'),
      WeightData('Сентябрь', 5.35, '17.07'),
      WeightData('Октябрь', 6.25, '31.08'),
      WeightData('Ноябрь', 3.7, '13.05'),
      WeightData('Декабрь', 4.9, '03.07'),
    ];

    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.transparent,
      enableAxisAnimation: true,
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
      ),
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.onTicks,
        axisLine: const AxisLine(color: Colors.transparent),
        initialVisibleMaximum: 5,
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(
          color: Colors.transparent,
        ),
        minimum: 2,
        maximum: 9,
        interval: 1,
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w400),
      ),
      series: [
        SplineAreaSeries<WeightData, String>(
          dataSource: chartData,
          color: Colors.white,
          xValueMapper: (WeightData data, _) => data.month,
          yValueMapper: (WeightData data, _) => data.weight,
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
        LineSeries<WeightData, String>(
          dataSource: chartData,
          xValueMapper: (WeightData data, _) => data.month,
          yValueMapper: (WeightData data, _) => data.weight,
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
