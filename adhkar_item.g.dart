// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adhkar_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdhkarItemAdapter extends TypeAdapter<AdhkarItem> {
  @override
  final int typeId = 3;

  @override
  AdhkarItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdhkarItem(
      contentAr: fields[0] as String,
      contentEn: fields[1] as String,
      descriptionAr: fields[2] as String?,
      descriptionEn: fields[3] as String?,
      count: fields[4] as int,
      type: fields[5] as String,
      audioPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdhkarItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.contentAr)
      ..writeByte(1)
      ..write(obj.contentEn)
      ..writeByte(2)
      ..write(obj.descriptionAr)
      ..writeByte(3)
      ..write(obj.descriptionEn)
      ..writeByte(4)
      ..write(obj.count)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.audioPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdhkarItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
