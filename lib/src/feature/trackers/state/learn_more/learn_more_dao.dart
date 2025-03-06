abstract class LearnMoreDataSource<T> {
  /// Set theme
  Future<void> setShow(T value);

  /// Get current theme from cache
  Future<T?> getIsShow();
}
