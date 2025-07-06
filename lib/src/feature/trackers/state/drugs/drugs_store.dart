import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'drugs_store.g.dart';

class DrugsStore extends _DrugsStore with _$DrugsStore {
  DrugsStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
  });
}

abstract class _DrugsStore extends LearnMoreStore<EntityMainDrug> with Store {
  _DrugsStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            // final format = DateFormat('dd MMMM',
            //     LocaleSettings.currentLocale.flutterLocale.toLanguageTag());

            //

            return EntityMainDrug();
          },
          basePath: Endpoint.diaperList,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = HealthResponseListDrug.fromJson(raw);

            // return data;

            return {
              'main': data.list ?? [],
            };
          },
        );
}
