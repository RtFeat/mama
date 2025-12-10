import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'circle_store.g.dart';

class CircleStore extends _CircleStore with _$CircleStore {
  CircleStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.userStore,
    required super.onLoad,
    required super.onSet,
    this.tableStore,
  });
  
  @override
  CircleTableStore? tableStore;
}

abstract class _CircleStore extends LearnMoreStore<EntityHistoryCircle>
    with Store {
  _CircleStore({
    required super.apiClient,
    required this.restClient,
    required super.faker,
    required this.userStore,
    required super.onLoad,
    required super.onSet,
  }        ) : super(
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
        ) {
    _setupChildIdReaction();
  }

  final UserStore userStore;
  final RestClient restClient;
  ReactionDisposer? _childIdReaction;

  CircleTableStore? get tableStore => (this as CircleStore).tableStore;

  @computed
  String get childId => userStore.selectedChild?.id ?? '';

  @observable
  GrowthGetCircleResponse? circleDetails;

  @observable
  bool _isActive = true;

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          // Очищаем старые данные
          runInAction(() {
            circleDetails = null;
            listData.clear();
          });
          
          // Загружаем новые данные
          fetchCircleDetails();
          
          if (tableStore != null) {
            tableStore!.refreshForChild(newChildId);
          }
        }
      },
    );
  }

  @computed
  Current get current {
    // Fallback: используем данные из истории если основных данных нет
    final historyData = tableStore?.listData ?? listData;
    
    if (historyData.isNotEmpty) {
      // Сортируем по дате, чтобы получить самую позднюю запись
      final sortedData = List<EntityHistoryCircle>.from(historyData);
      sortedData.sort((a, b) {
        DateTime? dateA, dateB;
        
        // Парсим дату из allData (ISO формат)
        if (a.allData != null && a.allData!.isNotEmpty) {
          try {
            dateA = DateTime.parse(a.allData!);
          } catch (e) {
            // Игнорируем ошибки парсинга
          }
        }
        
        if (b.allData != null && b.allData!.isNotEmpty) {
          try {
            dateB = DateTime.parse(b.allData!);
          } catch (e) {
            // Игнорируем ошибки парсинга
          }
        }
        
        // Если allData не сработал, пытаемся парсить data (формат DD.MM)
        if (dateA == null && a.data != null && a.data!.isNotEmpty) {
          final parts = a.data!.split('.');
          if (parts.length == 2) {
            final month = int.tryParse(parts[0]);
            final day = int.tryParse(parts[1]);
            if (month != null && day != null && month <= 12 && day <= 31) {
              dateA = DateTime(DateTime.now().year, month, day);
            }
          }
        }
        
        if (dateB == null && b.data != null && b.data!.isNotEmpty) {
          final parts = b.data!.split('.');
          if (parts.length == 2) {
            final month = int.tryParse(parts[0]);
            final day = int.tryParse(parts[1]);
            if (month != null && day != null && month <= 12 && day <= 31) {
              dateB = DateTime(DateTime.now().year, month, day);
            }
          }
        }
        
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });
      
      final latestRecord = sortedData.last; // Берем самую позднюю запись
      
      // Парсим окружность головы
      final rawCircle = (latestRecord.circle ?? '').replaceAll(',', '.');
      final value = double.tryParse(rawCircle) ?? 0;
      
      // Парсим дату и рассчитываем дни назад
      String labelText = '';
      DateTime? recordDate;
      
      if (latestRecord.allData != null && latestRecord.allData!.isNotEmpty) {
        try {
          recordDate = DateTime.parse(latestRecord.allData!);
          labelText = '${recordDate.day} ${_getMonthName(recordDate.month)}';
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      if (labelText.isEmpty && latestRecord.data != null && latestRecord.data!.isNotEmpty) {
        // Если data в формате DD.MM, конвертируем в DD месяц
        final parts = latestRecord.data!.split('.');
        if (parts.length == 2) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          if (day != null && month != null && month >= 1 && month <= 12) {
            recordDate = DateTime(DateTime.now().year, month, day);
            labelText = '$day ${_getMonthName(month)}';
          } else {
            labelText = latestRecord.data!;
          }
        } else {
          labelText = latestRecord.data!;
        }
      }
      
      // Преобразуем статус нормы
      String normStatus = latestRecord.normal ?? '';
      if (normStatus == 'Граница нормы') {
        normStatus = 'Показатель в норме';
      } else if (normStatus.isEmpty) {
        // Если статус не пришел с сервера, проверяем по нормам ВОЗ
        // Для окружности головы нормальный диапазон примерно 30-45 см (зависит от возраста)
        // Если значение выходит за пределы зеленой зоны на графике, считаем вне нормы
        if (value < 30 || value > 45) {
          normStatus = 'Вне нормы';
        } else {
          normStatus = 'Показатель в норме';
        }
      }
      
      // Рассчитываем количество дней назад
      String daysAgo = '0';
      if (recordDate != null) {
        final now = DateTime.now();
        final daysDifference = now.difference(recordDate).inDays.abs();
        daysAgo = daysDifference.toString();
      }
      
      return Current(
        value: value,
        label: labelText,
        isNormal: normStatus,
        days: daysAgo,
      );
    }
    
    return Current(value: 0, label: '', isNormal: '', days: '0');
  }

  @computed
  Dynamic get dynamicValue {
    // Всегда вычисляем динамику из истории для точности
    final historyData = tableStore?.listData ?? listData;
    
    if (historyData.length >= 2) {
      // Сортируем по дате для правильного расчета
      final sortedData = List<EntityHistoryCircle>.from(historyData);
      sortedData.sort((a, b) {
        DateTime? dateA, dateB;
        
        // Парсим дату из allData (ISO формат)
        if (a.allData != null && a.allData!.isNotEmpty) {
          try {
            dateA = DateTime.parse(a.allData!);
          } catch (e) {
            // Игнорируем ошибки парсинга
          }
        }
        
        if (b.allData != null && b.allData!.isNotEmpty) {
          try {
            dateB = DateTime.parse(b.allData!);
          } catch (e) {
            // Игнорируем ошибки парсинга
          }
        }
        
        // Если allData не сработал, пытаемся парсить data (формат MM.DD)
        if (dateA == null && a.data != null && a.data!.isNotEmpty) {
          final parts = a.data!.split('.');
          if (parts.length == 2) {
            final month = int.tryParse(parts[0]);
            final day = int.tryParse(parts[1]);
            if (month != null && day != null && month <= 12 && day <= 31) {
              dateA = DateTime(DateTime.now().year, month, day);
            }
          }
        }
        
        if (dateB == null && b.data != null && b.data!.isNotEmpty) {
          final parts = b.data!.split('.');
          if (parts.length == 2) {
            final month = int.tryParse(parts[0]);
            final day = int.tryParse(parts[1]);
            if (month != null && day != null && month <= 12 && day <= 31) {
              dateB = DateTime(DateTime.now().year, month, day);
            }
          }
        }
        
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });
      
      // Берем первую и последнюю записи
      final first = sortedData.first;
      final last = sortedData.last;
      
      // Парсим окружность головы
      final firstCircle = double.tryParse((first.circle ?? '').replaceAll(',', '.')) ?? 0;
      final lastCircle = double.tryParse((last.circle ?? '').replaceAll(',', '.')) ?? 0;
      
      // Вычисляем разность в сантиметрах
      final circleDiff = lastCircle - firstCircle;
      
      // Вычисляем количество дней
      DateTime? firstDate, lastDate;
      
      if (first.allData != null && first.allData!.isNotEmpty) {
        try {
          firstDate = DateTime.parse(first.allData!);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      if (last.allData != null && last.allData!.isNotEmpty) {
        try {
          lastDate = DateTime.parse(last.allData!);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      // Если allData не сработал, пытаемся парсить data
      if (firstDate == null && first.data != null && first.data!.isNotEmpty) {
        final parts = first.data!.split('.');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          if (month != null && day != null && month <= 12 && day <= 31) {
            firstDate = DateTime(DateTime.now().year, month, day);
          }
        }
      }
      
      if (lastDate == null && last.data != null && last.data!.isNotEmpty) {
        final parts = last.data!.split('.');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          if (month != null && day != null && month <= 12 && day <= 31) {
            lastDate = DateTime(DateTime.now().year, month, day);
          }
        }
      }
      
      int daysDiff = 0;
      if (firstDate != null && lastDate != null) {
        daysDiff = lastDate.difference(firstDate).inDays;
      }
      
      // Вычисляем динамику в сантиметрах в сутки
      double dailyChange = 0;
      if (daysDiff > 0) {
        dailyChange = circleDiff / daysDiff;
      }
      
      // Формируем диапазон дат
      final dateRange = _calculateDateRange();
      
      return Dynamic(
        value: dailyChange,
        label: circleDiff.toInt().toString(), // Общая разность в сантиметрах
        days: daysDiff.toString(),
        duration: dateRange,
      );
    }
    
    return Dynamic(value: 0, label: '0', days: '0', duration: '');
  }

  @computed
  double get minValue {
    // Получаем все значения из графика
    final values = chartData.map((e) => e.value).toList();
    if (values.isEmpty) {
      // По умолчанию показываем 30-50 см (или 300-500 мм)
      return circleUnit == CircleUnit.cm ? 30.0 : 300.0;
    }
    
    final minDataValue = values.reduce((a, b) => a < b ? a : b);
    final maxDataValue = values.reduce((a, b) => a > b ? a : b);
    
    // Диапазон данных
    final dataRange = maxDataValue - minDataValue;
    
    // Желаемый диапазон отображения (20 см или 200 мм)
    final displayRange = circleUnit == CircleUnit.cm ? 20.0 : 200.0;
    
    // Если данные помещаются в диапазон 20, центрируем их
    if (dataRange <= displayRange) {
      final center = (minDataValue + maxDataValue) / 2;
      final calculatedMin = center - displayRange / 2;
      // Не опускаемся ниже 0
      return (calculatedMin).clamp(0, double.infinity);
    }
    
    // Если данные больше 20, показываем их с небольшим отступом
    final offset = circleUnit == CircleUnit.cm ? 2.0 : 20.0;
    return (minDataValue - offset).clamp(0, double.infinity);
  }

  @computed
  double get maxValue {
    // Получаем все значения из графика
    final values = chartData.map((e) => e.value).toList();
    if (values.isEmpty) {
      // По умолчанию показываем 30-50 см (или 300-500 мм)
      return circleUnit == CircleUnit.cm ? 50.0 : 500.0;
    }
    
    final minDataValue = values.reduce((a, b) => a < b ? a : b);
    final maxDataValue = values.reduce((a, b) => a > b ? a : b);
    
    // Диапазон данных
    final dataRange = maxDataValue - minDataValue;
    
    // Желаемый диапазон отображения (20 см или 200 мм)
    final displayRange = circleUnit == CircleUnit.cm ? 20.0 : 200.0;
    
    // Если данные помещаются в диапазон 20, центрируем их
    if (dataRange <= displayRange) {
      final center = (minDataValue + maxDataValue) / 2;
      final calculatedMax = center + displayRange / 2;
      return calculatedMax;
    }
    
    // Если данные больше 20, показываем их с небольшим отступом
    final offset = circleUnit == CircleUnit.cm ? 2.0 : 20.0;
    return maxDataValue + offset;
  }

  @observable
  CircleUnit circleUnit = CircleUnit.cm;

  @action
  void switchCircleUnit(CircleUnit unit) {
    circleUnit = unit;
  }

  @computed
  List<ChartData> get chartData {
    if (childId.isEmpty) {
      return [];
    }
    
    // Используем данные из истории
    final historyData = tableStore?.listData ?? listData;
    if (historyData.isNotEmpty) {
      return _processChartDataFromHistory(historyData);
    }
    
    // Если данных нет, пытаемся загрузить
    if (_isActive && childId.isNotEmpty) {
      Future.microtask(() => _loadHistoryData());
    }
    
    return [];
  }

  List<ChartData> _processChartDataFromTable(List<dynamic> table) {
    final now = DateTime.now();
    final List<_DateValue> dateValues = [];
    for (final e in table) {
      final parts = e.time?.split('.');
      if (parts == null || parts.length != 2) continue;
      final month = int.tryParse(parts[0]);
      final day = int.tryParse(parts[1]);
      if (month == null || day == null) continue;
        var value = double.tryParse(e.circle ?? '') ?? 0;
        value = circleUnit == CircleUnit.cm ? value : value * 10;
      dateValues.add(_DateValue(month: month, day: day, value: value));
    }
    if (dateValues.isEmpty) return [];
    return _convertDateValuesToChartData(dateValues, now);
  }

  List<ChartData> _processChartDataFromHistory(List<EntityHistoryCircle> historyData) {
    final now = DateTime.now();
    final List<_DateValue> dateValues = [];
    
    for (final item in historyData) {
      int? month, day;
      
      // Сначала пытаемся парсить allData (ISO формат)
      if (item.allData != null && item.allData!.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(item.allData!);
          month = dateTime.month;
          day = dateTime.day;
        } catch (e) {
          // Игнорируем ошибки
        }
      }
      
      // Если allData не сработал, пытаемся парсить data (формат DD.MM)
      if (month == null || day == null) {
        final dateStr = item.data ?? '';
        if (dateStr.isNotEmpty) {
          final parts = dateStr.split('.');
          if (parts.length == 2) {
            month = int.tryParse(parts[0]);
            day = int.tryParse(parts[1]);
            
            // Если не получилось, пробуем наоборот
            if (month == null || day == null || month > 12) {
              month = int.tryParse(parts[1]);
              day = int.tryParse(parts[0]);
            }
          }
        }
      }
      
      if (month == null || day == null || month > 12 || day > 31) {
        continue;
      }
      
      // Парсим окружность головы
      final rawCircle = (item.circle ?? '').replaceAll(',', '.');
      var value = double.tryParse(rawCircle) ?? 0;
      value = circleUnit == CircleUnit.cm ? value : value * 10;
      
      dateValues.add(_DateValue(month: month, day: day, value: value));
    }
    
    if (dateValues.isEmpty) {
      return [];
    }
    return _convertDateValuesToChartData(dateValues, now);
  }

  @observable
  bool isDetailsLoading = false;

  @action
  Future<void> fetchCircleDetails() async {
    if (!_isActive || childId.isEmpty) return;
    
    runInAction(() {
      isDetailsLoading = true;
      circleDetails = null;
    });
    
    try {
      // Загружаем только историю, так как основной endpoint не работает
      await _loadHistoryData();
    } catch (e) {
      // Игнорируем ошибки
    } finally {
      if (_isActive) {
        runInAction(() => isDetailsLoading = false);
      }
    }
  }

  @action
  Future<void> _loadHistoryData() async {
    if (!_isActive || childId.isEmpty) return;
    
    runInAction(() {
      listData.clear();
    });
    
    try {
      await loadPage(newFilters: [
        SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: childId,
        ),
      ]);
    } catch (e) {
      // Игнорируем ошибки
    }
  }

  @action
  void deactivate() {
    _isActive = false;
    _childIdReaction?.call();
    _childIdReaction = null;
  }

  @action
  void activate() {
    _isActive = true;
    if (_childIdReaction == null) {
      _setupChildIdReaction();
    }
    // Загружаем данные при активации только если есть childId и данные еще не загружены
    if (childId.isNotEmpty && listData.isEmpty) {
      fetchCircleDetails();
    }
  }

  /// Принудительно обновляет данные для конкретного ребенка
  @action
  Future<void> refreshForChild(String childId) async {
    if (!_isActive) return;
    
    // Очищаем старые данные
    runInAction(() {
      circleDetails = null;
      listData.clear();
    });
    
    // Загружаем данные один раз
    await _loadHistoryData();
  }

  String _calculateDateRange() {
    // Получаем данные из истории
    final historyData = tableStore?.listData ?? listData;
    if (historyData.length < 2) return '';
    
    // Сортируем по дате
    final sortedData = List<EntityHistoryCircle>.from(historyData);
    sortedData.sort((a, b) {
      DateTime? dateA, dateB;
      
      // Парсим дату из allData (ISO формат)
      if (a.allData != null && a.allData!.isNotEmpty) {
        try {
          dateA = DateTime.parse(a.allData!);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      if (b.allData != null && b.allData!.isNotEmpty) {
        try {
          dateB = DateTime.parse(b.allData!);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      // Если allData не сработал, пытаемся парсить data (формат MM.DD)
      if (dateA == null && a.data != null && a.data!.isNotEmpty) {
        final parts = a.data!.split('.');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          if (month != null && day != null && month <= 12 && day <= 31) {
            dateA = DateTime(DateTime.now().year, month, day);
          }
        }
      }
      
      if (dateB == null && b.data != null && b.data!.isNotEmpty) {
        final parts = b.data!.split('.');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          if (month != null && day != null && month <= 12 && day <= 31) {
            dateB = DateTime(DateTime.now().year, month, day);
          }
        }
      }
      
      if (dateA == null || dateB == null) return 0;
      return dateA.compareTo(dateB);
    });
    
    if (sortedData.isEmpty) return '';
    
    // Берем первую и последнюю даты
    final first = sortedData.first;
    final last = sortedData.last;
    
    DateTime? firstDate, lastDate;
    
    // Парсим первую дату
    if (first.allData != null && first.allData!.isNotEmpty) {
      try {
        firstDate = DateTime.parse(first.allData!);
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }
    
    if (firstDate == null && first.data != null && first.data!.isNotEmpty) {
      final parts = first.data!.split('.');
      if (parts.length == 2) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        if (month != null && day != null && month <= 12 && day <= 31) {
          firstDate = DateTime(DateTime.now().year, month, day);
        }
      }
    }
    
    // Парсим последнюю дату
    if (last.allData != null && last.allData!.isNotEmpty) {
      try {
        lastDate = DateTime.parse(last.allData!);
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }
    
    if (lastDate == null && last.data != null && last.data!.isNotEmpty) {
      final parts = last.data!.split('.');
      if (parts.length == 2) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        if (month != null && day != null && month <= 12 && day <= 31) {
          lastDate = DateTime(DateTime.now().year, month, day);
        }
      }
    }
    
    if (firstDate == null || lastDate == null) return '';
    
    // Форматируем даты в формат "день месяц"
    final firstFormatted = '${firstDate.day} ${_getMonthName(firstDate.month)}';
    final lastFormatted = '${lastDate.day} ${_getMonthName(lastDate.month)}';
    
    return '$firstFormatted - $lastFormatted';
  }

  int _calculateDaysDifference() {
    // Получаем данные из истории
    final historyData = tableStore?.listData ?? listData;
    if (historyData.length < 2) return 0;
    
    // Сортируем по дате
    final sortedData = List<EntityHistoryCircle>.from(historyData);
    sortedData.sort((a, b) {
      DateTime? dateA, dateB;
      
      // Парсим дату из allData (ISO формат)
      if (a.allData != null && a.allData!.isNotEmpty) {
        try {
          dateA = DateTime.parse(a.allData!);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      if (b.allData != null && b.allData!.isNotEmpty) {
        try {
          dateB = DateTime.parse(b.allData!);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
      
      // Если allData не сработал, пытаемся парсить data (формат MM.DD)
      if (dateA == null && a.data != null && a.data!.isNotEmpty) {
        final parts = a.data!.split('.');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          if (month != null && day != null && month <= 12 && day <= 31) {
            dateA = DateTime(DateTime.now().year, month, day);
          }
        }
      }
      
      if (dateB == null && b.data != null && b.data!.isNotEmpty) {
        final parts = b.data!.split('.');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          if (month != null && day != null && month <= 12 && day <= 31) {
            dateB = DateTime(DateTime.now().year, month, day);
          }
        }
      }
      
      if (dateA == null || dateB == null) return 0;
      return dateA.compareTo(dateB);
    });
    
    if (sortedData.isEmpty) return 0;
    
    // Берем первую и последнюю даты
    final first = sortedData.first;
    final last = sortedData.last;
    
    DateTime? firstDate, lastDate;
    
    // Парсим первую дату
    if (first.allData != null && first.allData!.isNotEmpty) {
      try {
        firstDate = DateTime.parse(first.allData!);
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }
    
    if (firstDate == null && first.data != null && first.data!.isNotEmpty) {
      final parts = first.data!.split('.');
      if (parts.length == 2) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        if (month != null && day != null && month <= 12 && day <= 31) {
          firstDate = DateTime(DateTime.now().year, month, day);
        }
      }
    }
    
    // Парсим последнюю дату
    if (last.allData != null && last.allData!.isNotEmpty) {
      try {
        lastDate = DateTime.parse(last.allData!);
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }
    
    if (lastDate == null && last.data != null && last.data!.isNotEmpty) {
      final parts = last.data!.split('.');
      if (parts.length == 2) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        if (month != null && day != null && month <= 12 && day <= 31) {
          lastDate = DateTime(DateTime.now().year, month, day);
        }
      }
    }
    
    if (firstDate == null || lastDate == null) return 0;
    
    // Вычисляем разность в днях
    final difference = lastDate.difference(firstDate).inDays;
    return difference;
  }

  String _getMonthName(int month) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month - 1];
  }

  List<ChartData> _convertDateValuesToChartData(List<_DateValue> dateValues, DateTime now) {
    final List<_DateWithYear> datesWithYears = [];
    final reversedValues = dateValues.reversed.toList();
    DateTime? prevDate;
    for (final dv in reversedValues) {
      final candidates = [
        DateTime(now.year - 1, dv.month, dv.day),
        DateTime(now.year, dv.month, dv.day),
        DateTime(now.year + 1, dv.month, dv.day),
      ];
      DateTime chosen = candidates[1];
      if (prevDate == null) {
        int bestScore = 1 << 30;
        for (final candidate in candidates) {
          final diff = candidate.difference(now).inDays;
          final penalty = (diff > 60) ? 10000 : 0;
          final score = diff.abs() + penalty;
          if (score < bestScore) {
            bestScore = score;
            chosen = candidate;
          }
        }
      } else {
        DateTime? bestOnOrAfter;
        int? bestOnOrAfterDiff;
        for (final candidate in candidates) {
          final diffFromPrev = candidate.difference(prevDate).inDays;
          if (diffFromPrev >= 0) {
            if (bestOnOrAfter == null || diffFromPrev < bestOnOrAfterDiff!) {
              bestOnOrAfter = candidate;
              bestOnOrAfterDiff = diffFromPrev;
            }
          }
        }
        if (bestOnOrAfter != null) {
          chosen = bestOnOrAfter;
        }
      }
      datesWithYears.add(_DateWithYear(
        date: chosen,
        value: dv.value,
        month: dv.month,
        day: dv.day,
      ));
      prevDate = chosen;
    }
    datesWithYears.sort((a, b) => a.date.compareTo(b.date));
    final List<ChartData> result = [];
    int? baseEpochDays;
    for (final dwh in datesWithYears) {
      final epochDays = dwh.date.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
      baseEpochDays ??= epochDays;
      final xValue = (epochDays - baseEpochDays).toDouble();
      result.add(ChartData(
        xValue,
        dwh.value,
        '${dwh.day.toString().padLeft(2, '0')}.${dwh.month.toString().padLeft(2, '0')}',
        t.home.monthsData.title[dwh.month - 1],
        epochDays,
      ));
    }
    if (result.length == 1) {
      final only = result.first;
      return [ChartData(0, only.value, only.label, only.xLabel, only.epochDays)];
    }
    return result;
  }
}

class _DateValue {
  final int month;
  final int day;
  final double value;

  _DateValue({required this.month, required this.day, required this.value});
}

class _DateWithYear {
  final DateTime date;
  final double value;
  final int month;
  final int day;

  _DateWithYear({
    required this.date,
    required this.value,
    required this.month,
    required this.day,
  });
}
