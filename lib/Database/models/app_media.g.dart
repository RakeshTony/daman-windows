// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppMediaAdapter extends TypeAdapter<AppMedia> {
  @override
  final int typeId = 9;

  @override
  AppMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppMedia()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..description = fields[2] as String
      ..backgroundColor = fields[3] as String
      ..appAction = fields[4] as String
      ..imageFor = fields[5] as String
      ..rewardId = fields[6] as String
      ..operatorId = fields[7] as String
      ..serviceId = fields[8] as String
      ..rewardTitle = fields[9] as String
      ..operatorTitle = fields[10] as String
      ..serviceTitle = fields[11] as String
      ..image = fields[12] as String;
  }

  @override
  void write(BinaryWriter writer, AppMedia obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.backgroundColor)
      ..writeByte(4)
      ..write(obj.appAction)
      ..writeByte(5)
      ..write(obj.imageFor)
      ..writeByte(6)
      ..write(obj.rewardId)
      ..writeByte(7)
      ..write(obj.operatorId)
      ..writeByte(8)
      ..write(obj.serviceId)
      ..writeByte(9)
      ..write(obj.rewardTitle)
      ..writeByte(10)
      ..write(obj.operatorTitle)
      ..writeByte(11)
      ..write(obj.serviceTitle)
      ..writeByte(12)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
