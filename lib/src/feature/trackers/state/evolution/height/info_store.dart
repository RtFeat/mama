import 'package:mobx/mobx.dart';

part 'info_store.g.dart';

class HeightInfoStore = _HeightInfoStore with _$HeightInfoStore;

abstract class _HeightInfoStore with Store {
  final Future<bool> Function() _onLoad;
  final Future<void> Function(bool) _onSet;

  _HeightInfoStore({
    required Future<bool> Function() onLoad,
    required Future<void> Function(bool) onSet,
  })  : _onLoad = onLoad,
        _onSet = onSet;

  @observable
  bool isShowInfo = true;

  @action
  Future<void> getIsShowInfo() async {
    isShowInfo = await _onLoad();
  }

  @action
  Future<void> setIsShowInfo(bool value) async {
    await _onSet(value);
    isShowInfo = value;
  }
}
