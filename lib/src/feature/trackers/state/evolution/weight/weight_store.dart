import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'weight_store.g.dart';

class WeightStore extends _WeightStore with _$WeightStore {
  WeightStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.childId,
    required super.onLoad,
    required super.onSet,
  });
}

abstract class _WeightStore extends LearnMoreStore<EntityHistoryWeight>
    with Store {
  _WeightStore({
    required super.apiClient,
    required this.restClient,
    required super.faker,
    required this.childId,
    required super.onLoad,
    required super.onSet,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryWeight();
          },
          basePath: '',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = GrowthResponseHistoryWeight.fromJson(raw);
            return {
              'main': data.list ?? <EntityHistoryWeight>[],
            };
          },
        );

  final String childId;
  final RestClient restClient;

  @observable
  GrowthGetWeightResponse? weightDetails;

  @computed
  Current get current {
    if (weightDetails?.list?.currentWeight != null) {
      final current = weightDetails?.list?.currentWeight;
      return Current(
        value: double.tryParse(current?.weight ?? '') ?? 0,
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
    if (weightDetails?.list?.dynamicsWeight != null) {
      final dynamic = weightDetails?.list?.dynamicsWeight;
      return Dynamic(
        value: double.tryParse(dynamic?.weightGain ?? '') ?? 0,
        label: dynamic?.weightToDay ?? '',
        days: dynamic?.days ?? '',
        duration: dynamic?.timeDuration ?? '',
      );
    } else {
      return Dynamic(value: 0, label: '', days: '', duration: '');
    }
  }

  @computed
  double get minValue => weightUnit == WeightUnit.kg ? 2 : 2000;

  @computed
  double get maxValue => weightUnit == WeightUnit.kg ? 9 : 9000;

  @observable
  WeightUnit weightUnit = WeightUnit.kg;

  @action
  void switchWeightUnit(WeightUnit unit) {
    weightUnit = unit;
  }

  @computed
  List<ChartData> get chartData {
    if (weightDetails?.list?.table != null) {
      final table = weightDetails?.list?.table;
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
        var value = double.tryParse(e.weight ?? '') ?? 0;
        value = weightUnit == WeightUnit.kg ? value : value * 1000;
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
  Future<void> fetchWeightDetails() async {
    isDetailsLoading = true;
    try {
      weightDetails = await restClient.growth.getGrowthWeight(childId: childId);
    } catch (e) {
      print(e);
    } finally {
      isDetailsLoading = false;
    }
  }
}
