import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class WeightDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  WeightDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _weight => boolEntry('weight');

  @override
  Future<bool> getIsShow() async {
    return _weight.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _weight.setIfNullRemove(value);
  }
}
