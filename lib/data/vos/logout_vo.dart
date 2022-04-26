import 'package:json_annotation/json_annotation.dart';

part 'logout_vo.g.dart';

@JsonSerializable()
class LogoutVO {
  @JsonKey(name: "code")
  int? code;

  @JsonKey(name: "message")
  String? message;

  LogoutVO(this.code, this.message);

  factory LogoutVO.fromJson(Map<String, dynamic> json) => _$LogoutVOFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutVOToJson(this);

  @override
  String toString() {
    return 'LogoutVO{code: $code, message: $message}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogoutVO &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message;

  @override
  int get hashCode => code.hashCode ^ message.hashCode;
}