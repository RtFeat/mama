// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'payment_get_status_payment_req.g.dart';

@JsonSerializable()
class PaymentGetStatusPaymentReq {
  const PaymentGetStatusPaymentReq({
    this.idPayment,
    this.period,
  });
  
  factory PaymentGetStatusPaymentReq.fromJson(Map<String, Object?> json) => _$PaymentGetStatusPaymentReqFromJson(json);
  
  @JsonKey(name: 'id_payment')
  final String? idPayment;
  final String? period;

  Map<String, Object?> toJson() => _$PaymentGetStatusPaymentReqToJson(this);
}
