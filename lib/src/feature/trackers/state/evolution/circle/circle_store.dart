import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'circle_store.g.dart';

class CircleStore extends _CircleStore with _$CircleStore {
  CircleStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.childId,
    required super.onLoad,
    required super.onSet,
  });
}

abstract class _CircleStore extends LearnMoreStore<EntityHistoryCircle>
    with Store {
  _CircleStore({
    required super.apiClient,
    required this.restClient,
    required super.faker,
    required this.childId,
    required super.onLoad,
    required super.onSet,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryCircle();
          },
          basePath: '',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = GrowthResponseHistoryCircle.fromJson(raw);
            return {
              'main': data.list ?? <EntityHistoryCircle>[],
            };
          },
        );

  final String childId;
  final RestClient restClient;

  @observable
  GrowthGetCircleResponse? circleDetails;

  @computed
  Current get current {
    if (circleDetails?.list?.currentCircle != null) {
      final current = circleDetails?.list?.currentCircle;
      return Current(
        value: double.tryParse(current?.circle ?? '') ?? 0,
        label: current?.data ?? '',
        isNormal: current?.normal ?? '',
        days: current?.days ?? '',
      );
    } else {
      return Current(value: 0, label: '', isNormal: '', days: '');
    }
  }

  @computed
  Dynamic get dynamicValue {
    if (circleDetails?.list?.dynamicsCircle != null) {
      final dynamic = circleDetails?.list?.dynamicsCircle;
      return Dynamic(
        value: double.tryParse(dynamic?.circleGain ?? '') ?? 0,
        label: dynamic?.circleToDay ?? '',
        days: dynamic?.days ?? '',
        duration: dynamic?.timeDuration ?? '',
      );
    } else {
      return Dynamic(value: 0, label: '', days: '', duration: '');
    }
  }

  @computed
  double get minValue => circleUnit == CircleUnit.cm ? 30 : 300;

  @computed
  double get maxValue => circleUnit == CircleUnit.cm ? 50 : 500;

  @observable
  CircleUnit circleUnit = CircleUnit.cm;

  @action
  void switchCircleUnit(CircleUnit unit) {
    circleUnit = unit;
  }

  @computed
  List<ChartData> get chartData {
    if (circleDetails?.list?.table != null) {
      final table = circleDetails?.list?.table;
      table?.sort((a, b) {
        final partsA = a.time?.split('.');
        final partsB = b.time?.split('.');
        if (partsA == null ||
            partsB == null ||
            partsA.length != 2 ||
            partsB.length != 2) {
          return 0;
        }
        final monthA = int.tryParse(partsA[0]) ?? 0;
        final dayA = int.tryParse(partsA[1]) ?? 0;
        final monthB = int.tryParse(partsB[0]) ?? 0;
        final dayB = int.tryParse(partsB[1]) ?? 0;

        final dateA = DateTime(DateTime.now().year, monthA, dayA);
        final dateB = DateTime(DateTime.now().year, monthB, dayB);
        return dateA.compareTo(dateB);
      });

      return table!.map((e) {
        var value = double.tryParse(e.circle ?? '') ?? 0;
        value = circleUnit == CircleUnit.cm ? value : value * 10;
        final parts = e.time?.split('.');
        if (parts == null || parts.length != 2) {
          return ChartData(0, value, '', '');
        }
        final month = int.tryParse(parts[0]) ?? 0;
        final day = int.tryParse(parts[1]) ?? 0;

        final date = DateTime(DateTime.now().year, month, day);
        final xValue =
            date.difference(DateTime(date.year, 1, 1)).inDays.toDouble();

        return ChartData(
            xValue,
            value,
            '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}',
            t.home.monthsData.title[month - 1]);
      }).toList();
    }
    return [];
  }

  @observable
  bool isDetailsLoading = false;

  @action
  Future<void> fetchCircleDetails() async {
    isDetailsLoading = true;
    try {
      circleDetails = await restClient.growth.getGrowthCircle(childId: childId);
    } catch (e) {
      print(e);
    } finally {
      isDetailsLoading = false;
    }
  }
}
