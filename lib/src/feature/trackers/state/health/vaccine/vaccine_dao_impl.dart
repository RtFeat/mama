import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class VaccineDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  VaccineDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _vaccine => boolEntry('vaccine');

  @override
  Future<bool> getIsShow() async {
    return _vaccine.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _vaccine.setIfNullRemove(value);
  }
}
