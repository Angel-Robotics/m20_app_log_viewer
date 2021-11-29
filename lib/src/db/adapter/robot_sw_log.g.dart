// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'robot_sw_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RobotSWLogAdapter extends TypeAdapter<RobotSWLog> {
  @override
  final int typeId = 14;

  @override
  RobotSWLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RobotSWLog()
      ..log = fields[0] as String?
      ..code = fields[1] as int?
      ..info0 = fields[2] as int?
      ..info1 = fields[3] as int?
      ..timestamp = fields[4] as int?
      ..level = fields[5] as String?
      ..source = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, RobotSWLog obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.log)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.info0)
      ..writeByte(3)
      ..write(obj.info1)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RobotSWLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
