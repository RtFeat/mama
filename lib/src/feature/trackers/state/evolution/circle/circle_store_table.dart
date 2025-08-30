import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'circle_store_table.g.dart';

class CircleTableStore extends _CircleTableStore with _$CircleTableStore {
  CircleTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.store,
  });
}

abstract class _CircleTableStore extends TableStore<EntityHistoryCircle>
    with Store {
  _CircleTableStore({
    required super.apiClient,
    required super.faker,
    required this.store,
    required this.restClient,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryCircle();
          },
          basePath: 'growth/circle/history',
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
  final RestClient restClient;
  final CircleStore store;

  @observable
  String sortOrder = 'new'; // 'new' or 'old'

  @observable
  CircleUnit circleUnit = CircleUnit.cm; // 'cm' or 'mm'

  @action
  void setSortOrder(int index) {
    sortOrder = index == 0 ? 'new' : 'old';
  }

  @action
  void setCircleUnit(CircleUnit unit) {
    circleUnit = unit;
  }

  @override
  TableData get tableData => TableData(
      headerTitle: '',
      columnHeaders: [
        'Дата',
        '',
        'Неделя',
        'Голова',
      ],
      columnWidths: {
        0: 3,
        1: 2,
        2: 1,
        3: 1,
      },
      rows: rows,
      cellDecoration: CellDecoration(
        headerStyle: AppTextStyles.f10w700.copyWith(
          color: AppColors.greyBrighterColor,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 17,
          fontFamily: 'SFProText',
        ),
      ));

  void showAddRecordDialog(int index, List<EntityHistoryCircle> sortedList) {
    showDialog(
      context: navKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          // final CircleStore store = context.read<CircleStore>();
          final currentEntity = sortedList[index];
          final nextEntity =
              sortedList.length > index + 1 ? sortedList[index + 1] : null;
          final prevEntity = index > 0 ? sortedList[index - 1] : null;

          final data = MeasurementDetails(
            title: 'Окружность головы',
            currentWeek: '${currentEntity.weeks} неделя',
            previousWeek: prevEntity?.data ?? '',
            selectedWeek: currentEntity.data ?? '',
            nextWeek: nextEntity?.data ?? '',
            weight: '${currentEntity.circle} см',
            weightStatus: currentEntity.normal ?? '',
            weightStatusColor: currentEntity.normal == 'Граница нормы'
                ? AppColors.greenLightTextColor
                : AppColors.orangeTextColor,
            medianWeight: '234',
            normWeightRange: '243-234',
            weightToGain: '234',
            note: currentEntity.notes,
            onEdit: () {
              Navigator.of(context).pop();
              router.pushNamed(AppViews.addHeadView, extra: {
                'entity': currentEntity,
              });
            },
            onNextWeekTap: () {
              setState(() {
                index++;
              });
            },
            onPreviousWeekTap: () {
              setState(() {
                index--;
              });
            },
            onDelete: () {
              restClient.growth
                  .deleteGrowthCircleDeleteStats(
                      dto: GrowthDeleteCircleDto(
                id: currentEntity.id,
              ))
                  .then((v) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  store.fetchCircleDetails();
                  refresh();
                }
              });
            },
            onClose: () {
              Navigator.of(context).pop();
            },
            onNoteDelete: () {
              restClient.growth
                  .deleteGrowthCircleDeleteNotes(
                      dto: GrowthDeleteCircleDto(id: currentEntity.id))
                  .then((v) {
                currentEntity.notes = null;
                setState(() {});
                refresh();
              });
            },
            onNoteEdit: () {
              Navigator.of(context).pop();
              router.pushNamed(AppViews.addNote, extra: {
                'initialValue': currentEntity.notes,
                'onSaved': (value) {
                  if (value != currentEntity.notes) {
                    restClient.growth.patchGrowthCircleNotes(
                        dto: GrowthChangeNotesCircleDto(
                      id: currentEntity.id,
                      notes: value,
                    ));
                    refresh();
                  }
                },
              });
            },
          );

          return MeasurementOverlay(details: data);
        });
      },
    );
  }

  @override
  @computed
  ObservableList<List<TableItem>> get rows {
    final List<List<TableItem>> result = [];

    final sortedList = List<EntityHistoryCircle>.from(listData);
    sortedList.sort((a, b) {
      final dateStringA = a.allData ?? a.data ?? '';
      final dateStringB = b.allData ?? b.data ?? '';

      if (sortOrder == 'new') {
        return dateStringB.compareTo(dateStringA);
      } else {
        return dateStringA.compareTo(dateStringB);
      }
    });

    for (var i = 0; i < sortedList.length; i++) {
      final entity = sortedList[i];
      // final temp = tempHistory[colIdx];
      final bool hasNote = entity.notes != null && entity.notes!.isNotEmpty;

      final bool isBad = entity.normal == 'Вне нормы';
      final bool isNormal = entity.normal == 'Граница нормы';

      final decoration = (isBad || isNormal)
          ? CellDecoration(
              color: isBad
                  ? AppColors.yellowBackgroundColor
                  : AppColors.greenLighterBackgroundColor,
              radius: 8,
            )
          : null;

      final circleValue = double.tryParse(entity.circle ?? '') ?? 0.0;
      final displayCircle = circleUnit == CircleUnit.m
          ? (circleValue * 10).toStringAsFixed(0)
          : entity.circle;

      result.add([
        TableItem(
          onTap: () => showAddRecordDialog(i, sortedList),
          title: entity.data.toString(),
          row: result.length + 1,
          column: 1,
          isHide: false,
          decoration: decoration,
          trailing: hasNote
              ? Row(
                  children: [
                    NoteIconWidget(
                      size: 20,
                    ),
                  ],
                )
              : null,
        ),
        TableItem(
          onTap: () => showAddRecordDialog(i, sortedList),
          title: entity.normal,
          row: result.length + 1,
          column: 2,
          trailing: const SizedBox(
            height: 20,
          ),
          decoration: decoration?.copyWith(
              textStyle: AppTextStyles.f10w700.copyWith(
            color: isBad
                ? AppColors.orangeTextColor
                : AppColors.greenLightTextColor,
          )),
        ),
        TableItem(
          onTap: () => showAddRecordDialog(i, sortedList),
          title: entity.weeks.toString(),
          row: result.length + 1,
          column: 2,
          decoration: decoration,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        TableItem(
          onTap: () => showAddRecordDialog(i, sortedList),
          title: displayCircle,
          row: result.length + 1,
          column: 3,
          decoration: decoration,
          mainAxisAlignment: MainAxisAlignment.center,
          // decoration: (temp.isBad ?? false)
          //     ? CellDecoration(
          //         color: AppColors.yellowBackgroundColor,
          //         radius: 8,
          //         textStyle: _cellTextStyle,
          //       )
          //     : null,
        ),
      ]);
    }
    return ObservableList.of(result);
  }
}
