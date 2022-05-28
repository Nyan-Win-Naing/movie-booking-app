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
      id: fields[0] as int?,
      cardHolder: fields[1] as String?,
      cardNumber: fields[2] as String?,
      expirationDate: fields[3] as String?,
      cardType: fields[4] as String?,
      isSelected: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CardVO obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardHolder)
      ..writeByte(2)
      ..write(obj.cardNumber)
      ..writeByte(3)
      ..write(obj.expirationDate)
      ..writeByte(4)
      ..write(obj.cardType)
      ..writeByte(5)
      ..write(obj.isSelected);
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
      id: json['id'] as int?,
      cardHolder: json['card_holder'] as String?,
      cardNumber: json['card_number'] as String?,
      expirationDate: json['expiration_date'] as String?,
      cardType: json['card_type'] as String?,
      isSelected: json['isSelected'] as bool?,
    );

Map<String, dynamic> _$CardVOToJson(CardVO instance) => <String, dynamic>{
      'id': instance.id,
      'card_holder': instance.cardHolder,
      'card_number': instance.cardNumber,
      'expiration_date': instance.expirationDate,
      'card_type': instance.cardType,
      'isSelected': instance.isSelected,
    };
