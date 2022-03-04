// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentMethodVOAdapter extends TypeAdapter<PaymentMethodVO> {
  @override
  final int typeId = 16;

  @override
  PaymentMethodVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentMethodVO(
      fields[0] as int?,
      fields[1] as String?,
      fields[2] as String?,
    )..isSelected = fields[3] as bool?;
  }

  @override
  void write(BinaryWriter writer, PaymentMethodVO obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodVO _$PaymentMethodVOFromJson(Map<String, dynamic> json) =>
    PaymentMethodVO(
      json['id'] as int?,
      json['name'] as String?,
      json['description'] as String?,
    )..isSelected = json['isSelected'] as bool?;

Map<String, dynamic> _$PaymentMethodVOToJson(PaymentMethodVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isSelected': instance.isSelected,
    };
