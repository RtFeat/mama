import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'date_time_selector.g.dart';

class DateTimeSelectorStore extends _DateTimeSelectorStore
    with _$DateTimeSelectorStore {
  DateTimeSelectorStore();
}

abstract class _DateTimeSelectorStore with Store {
  @observable
  DateTime? dateTime;

  @action
  void setDateTime(DateTime? dateTime) {
    this.dateTime = dateTime;
  }

  @computed
  bool get isSelectedOtherDateTime => dateTime != null;

  @computed
  String get time => dateTime?.formattedTime ?? DateTime.now().formattedTime;

  @computed
  String get date => DateFormat(
        'dd MMMM',
        LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
      ).format(dateTime ?? DateTime.now());
}
