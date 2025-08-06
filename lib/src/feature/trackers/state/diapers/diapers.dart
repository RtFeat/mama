import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'diapers.g.dart';

class DiapersStore extends _DiapersStore with _$DiapersStore {
  DiapersStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
  });
}

abstract class _DiapersStore extends LearnMoreStore<EntityDiapersMain>
    with Store {
  _DiapersStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            final format = DateFormat('dd MMMM',
                LocaleSettings.currentLocale.flutterLocale.toLanguageTag());

            //

            return EntityDiapersMain(
                data: '',
                diapersSub: ObservableList.of(
                    List.generate(faker.datatype.number(min: 5, max: 20), (_) {
                  return EntityDiapersSubMain(
                    howMuch: 'Много',
                    notes: faker.lorem.sentence(),
                    time: format.format(DateTime.now()),
                    typeOfDiapers: TypeOfDiapers.mixed.name,
                  );
                })));
          },
          basePath: Endpoint.diaperList,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = DiapersResponseListDiapers.fromJson(raw);

            // return data;

            return {
              'main': data.list ?? [],
            };
          },
        );

  @observable
  DateTime selectedDate = DateTime.now();

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @computed
  DateTime get startOfWeek => selectedDate.startOfWeek();

  @computed
  DateTime get endOfWeek => selectedDate.add(const Duration(days: 6));

  @computed
  int get averageOfDiapers {
    if (listData.isEmpty) return 0;

    final totalDiapers = listData.map((e) {
      if (e == null) return 0;
      return e.diapersSub.length;
    }).reduce((a, b) {
      if (a == null || b == null) return 0;
      return a + b;
    });

    return totalDiapers ~/ listData.length;
  }
}
