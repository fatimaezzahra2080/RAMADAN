// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worship_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorshipActionAdapter extends TypeAdapter<WorshipAction> {
  @override
  final int typeId = 1;

  @override
  WorshipAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorshipAction(
      id: fields[0] as int,
      type: fields[1] as WorshipType,
      contentAr: fields[2] as String,
      contentEn: fields[3] as String,
      audioPath: fields[4] as String?,
      dayOfYear: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorshipAction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.contentAr)
      ..writeByte(3)
      ..write(obj.contentEn)
      ..writeByte(4)
      ..write(obj.audioPath)
      ..writeByte(5)
      ..write(obj.dayOfYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorshipActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorshipTypeAdapter extends TypeAdapter<WorshipType> {
  @override
  final int typeId = 0;

  @override
  WorshipType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WorshipType.dhikr;
      case 1:
        return WorshipType.dua;
      case 2:
        return WorshipType.ayah;
      case 3:
        return WorshipType.deed;
      case 4:
        return WorshipType.fact;
      default:
        return WorshipType.dhikr;
    }
  }

  @override
  void write(BinaryWriter writer, WorshipType obj) {
    switch (obj) {
      case WorshipType.dhikr:
        writer.writeByte(0);
        break;
      case WorshipType.dua:
        writer.writeByte(1);
        break;
      case WorshipType.ayah:
        writer.writeByte(2);
        break;
      case WorshipType.deed:
        writer.writeByte(3);
        break;
      case WorshipType.fact:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorshipTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
