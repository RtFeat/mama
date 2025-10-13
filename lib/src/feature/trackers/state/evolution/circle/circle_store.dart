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
          print('CircleStore reaction: childId changed to $newChildId');
          
          // Очищаем старые данные
          runInAction(() {
            circleDetails = null;
            listData.clear();
          });
          
          // Загружаем новые данные
          fetchCircleDetails();
          
          // ВАЖНО: Используем новый метод refreshForChild для полной перезагрузки
          if (tableStore != null) {
            tableStore!.refreshForChild(newChildId);
          }
        }
      },
    );
  }

  @computed
  Current get current {
    print('CircleStore current: circleDetails = ${circleDetails != null}');
    print('CircleStore current: currentCircle = ${circleDetails?.list?.currentCircle != null}');
    print('CircleStore current: childId = $childId');
    
    // Проверяем API данные и их валидность
    if (circleDetails?.list?.currentCircle != null) {
      final current = circleDetails?.list?.currentCircle;
      final apiCircle = double.tryParse(current?.circle ?? '') ?? 0;
      
      print('CircleStore current: apiCircle = $apiCircle');
      print('CircleStore current: current.circle = "${current?.circle}"');
      print('CircleStore current: current.data = "${current?.data}"');
      print('CircleStore current: current.days = "${current?.days}"');
      print('CircleStore current: current.normal = "${current?.normal}"');
      
      // Если API вернул валидную окружность головы (> 0), используем её
      if (apiCircle > 0) {
        final String rawDays = current?.days ?? '';
        
        // Извлекаем число дней из строки типа "20 дней назад" или "-207"
        String normalizedDays = '0';
        if (rawDays.isNotEmpty) {
          // Ищем число в строке (включая отрицательные)
          final RegExp numberRegex = RegExp(r'-?\d+');
          final Match? match = numberRegex.firstMatch(rawDays);
          if (match != null) {
            final int? parsedDays = int.tryParse(match.group(0)!);
            if (parsedDays != null) {
              // Убираем минус, если он есть
              normalizedDays = parsedDays.abs().toString();
            }
          }
        }
        
        // Проверяем, содержит ли data текст "дней назад" и извлекаем только дату
        String labelText = current?.data ?? '';
        if (labelText.contains('дней назад')) {
          // Если data содержит "дней назад", используем только дату без этого текста
          labelText = labelText.replaceAll(RegExp(r'\s*\d+\s*дней\s*назад\s*'), '').trim();
        }
        
        // Преобразуем статус нормы для API данных
        String apiNormStatus = current?.normal ?? '';
        if (apiNormStatus == 'Граница нормы') {
          apiNormStatus = 'Показатель в норме';
        } else if (apiNormStatus.isEmpty) {
          apiNormStatus = 'Показатель в норме'; // По умолчанию считаем в норме
        }
        
        print('CircleStore current: Final values - value: $apiCircle, label: "$labelText", isNormal: "$apiNormStatus", days: "$normalizedDays"');
        
        return Current(
          value: apiCircle,
          label: labelText,
          isNormal: apiNormStatus,
          days: normalizedDays,
        );
      } else {
        print('CircleStore current: apiCircle <= 0, using fallback');
      }
    } else {
      print('CircleStore current: currentCircle is null, using fallback');
    }
    
    // Fallback: используем данные из истории если основных данных нет (как в модуле роста)
    final historyData = tableStore?.listData ?? listData;
    print('CircleStore current fallback: historyData.length = ${historyData.length}');
    print('CircleStore current fallback: tableStore?.listData.length = ${tableStore?.listData.length}');
    print('CircleStore current fallback: listData.length = ${listData.length}');
    
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
      
      // Парсим дату
      String labelText = '';
      if (latestRecord.allData != null && latestRecord.allData!.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(latestRecord.allData!);
          labelText = '${dateTime.day} ${_getMonthName(dateTime.month)}';
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
        normStatus = 'Показатель в норме'; // По умолчанию считаем в норме
      }
      
      return Current(
        value: value,
        label: labelText,
        isNormal: normStatus,
        days: '0', // Для истории не показываем "дней назад"
      );
    }
    
    return Current(value: 0, label: '', isNormal: '', days: '0');
  }

  @computed
  Dynamic get dynamicValue {
    // Всегда вычисляем динамику из истории для точности (как в модуле роста)
    final historyData = tableStore?.listData ?? listData;
    print('CircleStore dynamicValue: historyData.length = ${historyData.length}');
    print('CircleStore dynamicValue: tableStore?.listData.length = ${tableStore?.listData.length}');
    print('CircleStore dynamicValue: listData.length = ${listData.length}');
    
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
    
    return Dynamic(value: 0, label: '', days: '', duration: '');
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
    // Если нет childId, возвращаем пустой список
    if (childId.isEmpty) {
      print('CircleStore chartData: childId is empty');
      return [];
    }
    
    print('CircleStore chartData: childId = $childId');
    print('CircleStore chartData: circleDetails?.list?.table = ${circleDetails?.list?.table}');
    print('CircleStore chartData: listData.length = ${listData.length}');
    
    // Сначала пытаемся получить данные из circleDetails (API графика)
    if (circleDetails?.list?.table != null && circleDetails!.list!.table!.isNotEmpty) {
      print('CircleStore chartData: Using data from circleDetails');
      return _processChartDataFromTable(circleDetails!.list!.table!);
    }
    
    // Если данных нет, используем данные из истории как fallback
    // Сначала пробуем данные из tableStore, потом из собственного listData
    final historyData = tableStore?.listData ?? listData;
    if (historyData.isNotEmpty) {
      print('CircleStore chartData: Using data from history (${historyData.length} items)');
      return _processChartDataFromHistory(historyData);
    }
    
    // Если и истории нет, пытаемся загрузить данные
    print('CircleStore chartData: No data found, attempting to load history');
    if (_isActive && childId.isNotEmpty) {
      // Асинхронно загружаем историю
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
    print('CircleStore _processChartDataFromHistory: Processing ${historyData.length} items');
    final now = DateTime.now();
    final List<_DateValue> dateValues = [];
    
    for (final item in historyData) {
      print('CircleStore _processChartDataFromHistory: Processing item - data: ${item.data}, allData: ${item.allData}, circle: ${item.circle}');
      
      int? month, day;
      
      // Сначала пытаемся парсить allData (ISO формат)
      if (item.allData != null && item.allData!.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(item.allData!);
          month = dateTime.month;
          day = dateTime.day;
          print('CircleStore _processChartDataFromHistory: Parsed from allData - month: $month, day: $day');
        } catch (e) {
          print('CircleStore _processChartDataFromHistory: Failed to parse allData: $e');
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
            print('CircleStore _processChartDataFromHistory: Parsed from data - month: $month, day: $day');
          }
        }
      }
      
      if (month == null || day == null || month > 12 || day > 31) {
        print('CircleStore _processChartDataFromHistory: Skipping item - invalid date (month: $month, day: $day)');
        continue;
      }
      
      // Парсим окружность головы
      final rawCircle = (item.circle ?? '').replaceAll(',', '.');
      var value = double.tryParse(rawCircle) ?? 0;
      value = circleUnit == CircleUnit.cm ? value : value * 10;
      
      dateValues.add(_DateValue(month: month, day: day, value: value));
    }
    
    if (dateValues.isEmpty) {
      print('CircleStore _processChartDataFromHistory: No valid date values found');
    return [];
    }
    print('CircleStore _processChartDataFromHistory: Found ${dateValues.length} valid date values');
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
      print('CircleStore fetchCircleDetails: Fetching data for childId: $childId');
      final response = await restClient.growth.getGrowthCircle(childId: childId);
      print('CircleStore fetchCircleDetails: API response received');
      print('CircleStore fetchCircleDetails: response.list = ${response.list != null}');
      print('CircleStore fetchCircleDetails: currentCircle = ${response.list?.currentCircle != null}');
      print('CircleStore fetchCircleDetails: table length = ${response.list?.table?.length}');
      
      if (_isActive) {
        runInAction(() => circleDetails = response);
        print('CircleStore fetchCircleDetails: circleDetails set');
      }
      
      if (_isActive && childId.isNotEmpty && 
          (circleDetails?.list?.table == null || circleDetails!.list!.table!.isEmpty)) {
        await _loadHistoryData();
      }
    } catch (e) {
      print('CircleStore fetchCircleDetails error: $e');
      if (_isActive && childId.isNotEmpty) {
        await _loadHistoryData();
      }
    } finally {
      if (_isActive) {
        runInAction(() => isDetailsLoading = false);
      }
    }
  }

  @action
  Future<void> _loadHistoryData() async {
    if (!_isActive || childId.isEmpty) {
      print('CircleStore _loadHistoryData: Skipping - not active or childId empty');
      return;
    }
    
    print('CircleStore _loadHistoryData: Loading history for childId: $childId');
    
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
      print('CircleStore _loadHistoryData: Successfully loaded ${listData.length} items');
    } catch (e) {
      print('CircleStore _loadHistoryData error: $e');
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
    // Загружаем данные при активации только если есть childId
    if (childId.isNotEmpty) {
      print('CircleStore activate: Loading data for childId: $childId');
      fetchCircleDetails();
    }
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
