import 'package:dio/dio.dart';

class TrailingSlashInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.path.endsWith('/')) {
      options.path = '${options.path}/';
    }
    super.onRequest(options, handler);
  }
}
