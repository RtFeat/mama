import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class GrowthDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  GrowthDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _growth => boolEntry('growth');

  @override
  Future<bool> getIsShow() async {
    return _growth.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _growth.setIfNullRemove(value);
  }
}
