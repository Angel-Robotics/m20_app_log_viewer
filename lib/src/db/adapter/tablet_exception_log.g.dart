// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tablet_exception_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TabletExceptionLogAdapter extends TypeAdapter<TabletExceptionLog> {
  @override
  final int typeId = 13;

  @override
  TabletExceptionLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TabletExceptionLog()
      ..exception = fields[0] as String?
      ..timestamp = fields[1] as int?;
  }

  @override
  void write(BinaryWriter writer, TabletExceptionLog obj) {
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
      other is TabletExceptionLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
