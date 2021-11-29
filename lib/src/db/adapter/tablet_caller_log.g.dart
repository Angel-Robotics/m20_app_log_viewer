// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tablet_caller_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TabletCallerLogAdapter extends TypeAdapter<TabletCallerLog> {
  @override
  final int typeId = 16;

  @override
  TabletCallerLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TabletCallerLog()
      ..exception = fields[0] as String?
      ..timestamp = fields[1] as int?;
  }

  @override
  void write(BinaryWriter writer, TabletCallerLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.exception)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabletCallerLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
