// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'payment_get_status_payment_resp.g.dart';

@JsonSerializable()
class PaymentGetStatusPaymentResp {
  const PaymentGetStatusPaymentResp({
    this.status,
  });
  
  factory PaymentGetStatusPaymentResp.fromJson(Map<String, Object?> json) => _$PaymentGetStatusPaymentRespFromJson(json);
  
  final String? status;

  Map<String, Object?> toJson() => _$PaymentGetStatusPaymentRespToJson(this);
}
