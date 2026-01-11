// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyChallengeAdapter extends TypeAdapter<MonthlyChallenge> {
  @override
  final int typeId = 3;

  @override
  MonthlyChallenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyChallenge(
      id: fields[0] as int,
      monthIndex: fields[1] as int,
      title: fields[2] as String,
      description: fields[3] as String,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyChallenge obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.monthIndex)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
