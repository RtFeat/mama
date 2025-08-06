import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class DoctorVisitsDataSourceLocal extends PreferencesDao
    implements LearnMoreDataSource<bool> {
  DoctorVisitsDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _doctorVisits => boolEntry('doctor_visits');

  @override
  Future<bool> getIsShow() async {
    return _doctorVisits.read() ?? true;
  }

  @override
  Future<void> setShow(value) async {
    _doctorVisits.setIfNullRemove(value);
  }
}
