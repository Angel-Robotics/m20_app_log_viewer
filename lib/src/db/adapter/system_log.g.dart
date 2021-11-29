// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemLogAdapter extends TypeAdapter<SystemLog> {
  @override
  final int typeId = 0;

  @override
  SystemLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemLog()
      ..datetime = fields[0] as String?
      ..log = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, SystemLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.datetime)
      ..writeByte(1)
      ..write(obj.log);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
