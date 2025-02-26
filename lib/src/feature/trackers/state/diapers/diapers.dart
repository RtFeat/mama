import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'diapers.g.dart';

class DiapersStore extends _DiapersStore with _$DiapersStore {
  DiapersStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
  });
}

abstract class _DiapersStore extends LearnMoreStore<DiapersMain> with Store {
  _DiapersStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
  }) : super(
          basePath: Endpoint.diaperList,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => DiapersMain.fromJson(e))
                .toList();

            return data;
          },
        );

  // TODO найти начало недели и конец, отображать данные для этого периода
}
