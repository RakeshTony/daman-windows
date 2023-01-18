// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PushNotificationAdapter extends TypeAdapter<PushNotification> {
  @override
  final int typeId = 12;

  @override
  PushNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PushNotification()
      ..title = fields[0] as String
      ..body = fields[1] as String
      ..time = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PushNotification obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
