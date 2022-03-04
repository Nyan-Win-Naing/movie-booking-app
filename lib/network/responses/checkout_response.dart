import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';

part 'checkout_response.g.dart';

@JsonSerializable()
class CheckoutResponse {
  @JsonKey(name: "code")
 int? code;

  @JsonKey(name: "message")
 String? message;

  @JsonKey(name: "data")
 VoucherVO? voucherVo;

  CheckoutResponse(this.code, this.message, this.voucherVo);

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutResponseToJson(this);
}