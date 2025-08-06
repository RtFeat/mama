import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class DiapersDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  DiapersDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _diapers => boolEntry('diapers');

  @override
  Future<bool> getIsShow() async {
    return _diapers.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _diapers.setIfNullRemove(value);
  }
}
