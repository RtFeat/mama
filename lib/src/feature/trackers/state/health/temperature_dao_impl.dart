import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class TemperatureDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  TemperatureDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _temperature => boolEntry('temperature');

  @override
  Future<bool> getIsShow() async {
    return _temperature.read() ?? false;
  }

  @override
  Future<void> setShow(value) async {
    _temperature.setIfNullRemove(value);
  }
}
