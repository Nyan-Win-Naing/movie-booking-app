// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardVOAdapter extends TypeAdapter<CardVO> {
  @override
  final int typeId = 2;

  @override
  CardVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardVO(
      fields[0] as int?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CardVO obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardHolder)
      ..writeByte(2)
      ..write(obj.cardNumber)
      ..writeByte(3)
      ..write(obj.expirationDate)
      ..writeByte(4)
      ..write(obj.cardType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardVO _$CardVOFromJson(Map<String, dynamic> json) => CardVO(
      json['id'] as int?,
      json['card_holder'] as String?,
      json['card_number'] as String?,
      json['expiration_date'] as String?,
      json['card_type'] as String?,
    );

Map<String, dynamic> _$CardVOToJson(CardVO instance) => <String, dynamic>{
      'id': instance.id,
      'card_holder': instance.cardHolder,
      'card_number': instance.cardNumber,
      'expiration_date': instance.expirationDate,
      'card_type': instance.cardType,
    };
