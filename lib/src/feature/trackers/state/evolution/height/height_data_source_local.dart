import 'package:shared_preferences/shared_preferences.dart';

class HeightDataSourceLocal {
  final SharedPreferences sharedPreferences;

  HeightDataSourceLocal({required this.sharedPreferences});

  static const String _isShowKey = 'isShowHeightInfo';

  Future<bool> getIsShow() async {
    return sharedPreferences.getBool(_isShowKey) ?? true;
  }

  Future<void> setShow(bool value) async {
    await sharedPreferences.setBool(_isShowKey, value);
  }
}
