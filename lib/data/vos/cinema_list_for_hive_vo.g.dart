// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_list_for_hive_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CinemaListForHiveVOAdapter extends TypeAdapter<CinemaListForHiveVO> {
  @override
  final int typeId = 15;

  @override
  CinemaListForHiveVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CinemaListForHiveVO(
      (fields[0] as List?)?.cast<CinemaVO>(),
    );
  }

  @override
  void write(BinaryWriter writer, CinemaListForHiveVO obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cinemaList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CinemaListForHiveVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
