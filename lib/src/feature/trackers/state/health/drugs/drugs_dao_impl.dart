import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class DrugsDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  DrugsDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _drugs => boolEntry('drugs');

  @override
  Future<bool> getIsShow() async {
    return _drugs.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _drugs.setIfNullRemove(value);
  }
}
