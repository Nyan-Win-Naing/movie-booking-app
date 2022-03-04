import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  @JsonKey(name: "code")
  int? code;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  UserVO? data;

  @JsonKey(name: "token")
  String? token;

  AuthenticationResponse(
      this.code,
      this.message,
      this.data,
      this.token,
      );

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);

  @override
  String toString() {
    return 'AuthenticationResponse{code: $code, message: $message, data: $data, token: $token}';
  }
}