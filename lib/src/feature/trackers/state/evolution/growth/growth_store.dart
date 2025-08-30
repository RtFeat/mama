import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'growth_store.g.dart';

class GrowthStore extends _GrowthStore with _$GrowthStore {
  GrowthStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.childId,
    required super.onLoad,
    required super.onSet,
  });
}

abstract class _GrowthStore extends LearnMoreStore<EntityHistoryHeight>
    with Store {
  _GrowthStore({
    required super.apiClient,
    required this.restClient,
    required super.faker,
    required this.childId,
    required super.onLoad,
    required super.onSet,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryHeight();
          },
          basePath: '',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = GrowthResponseHistoryHeight.fromJson(raw);
            return {
              'main': data.list ?? <EntityHistoryHeight>[],
            };
          },
        );

  final String childId;
  final RestClient restClient;

  @observable
  GrowthGetHeightResponse? growthDetails;

  @computed
  Current get current {
    if (growthDetails?.list?.currentHeight != null) {
      final current = growthDetails?.list?.currentHeight;
      return Current(
        value: double.tryParse(current?.height ?? '') ?? 0,
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
    if (growthDetails?.list?.dynamicsHeight != null) {
      final dynamic = growthDetails?.list?.dynamicsHeight;
      return Dynamic(
        value: double.tryParse(dynamic?.heightGain ?? '') ?? 0,
        label: dynamic?.heightToDay ?? '',
        days: dynamic?.days ?? '',
        duration: dynamic?.timeDuration ?? '',
      );
    } else {
      return Dynamic(value: 0, label: '', days: '', duration: '');
    }
  }

  @computed
  double get minValue => growthUnit == GrowthUnit.m ? 0.5 : 50;

  @computed
  double get maxValue => growthUnit == GrowthUnit.m ? 1.5 : 150;

  @observable
  GrowthUnit growthUnit = GrowthUnit.cm;

  @action
  void switchGrowthUnit(GrowthUnit unit) {
    growthUnit = unit;
  }

  @computed
  List<ChartData> get chartData {
    if (growthDetails?.list?.table != null) {
      final table = growthDetails?.list?.table;
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
        var value = double.tryParse(e.height ?? '') ?? 0;
        value = growthUnit == GrowthUnit.cm ? value : value / 100;
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
  Future<void> fetchGrowthDetails() async {
    isDetailsLoading = true;
    try {
      growthDetails = await restClient.growth.getGrowthHeight(childId: childId);
    } catch (e) {
      print(e);
    } finally {
      isDetailsLoading = false;
    }
  }
}
