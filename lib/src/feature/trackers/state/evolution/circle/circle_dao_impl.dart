import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class CircleDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  CircleDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _circle => boolEntry('circle');

  @override
  Future<bool> getIsShow() async {
    return _circle.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _circle.setIfNullRemove(value);
  }
}
