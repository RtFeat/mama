// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/payment_get_status_payment_req.dart';
import '../models/payment_get_status_payment_resp.dart';

part 'payment_client.g.dart';

@RestApi()
abstract class PaymentClient {
  factory PaymentClient(Dio dio, {String? baseUrl}) = _PaymentClient;

  /// Активировать промокод.
  ///
  /// [promocode] - PromoCode.
  @POST('/payment/promocode')
  Future<void> postPaymentPromocode({
    @Query('promocode') required String promocode,
  });

  /// Статус платежа.
  ///
  /// [payment] - Payment.
  @POST('/payment/status')
  Future<PaymentGetStatusPaymentResp> postPaymentStatus({
    @Body() required PaymentGetStatusPaymentReq payment,
  });
}
