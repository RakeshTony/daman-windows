// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_child.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceChildAdapter extends TypeAdapter<ServiceChild> {
  @override
  final int typeId = 1;

  @override
  ServiceChild read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceChild()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..parentId = fields[2] as String
      ..slug = fields[3] as String
      ..body = fields[4] as String
      ..type = fields[5] as String
      ..status = fields[6] as bool
      ..comingSoon = fields[7] as bool
      ..displayOrder = fields[8] as String
      ..modified = fields[9] as String
      ..created = fields[10] as String
      ..icon = fields[11] as String;
  }

  @override
  void write(BinaryWriter writer, ServiceChild obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.parentId)
      ..writeByte(3)
      ..write(obj.slug)
      ..writeByte(4)
      ..write(obj.body)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.comingSoon)
      ..writeByte(8)
      ..write(obj.displayOrder)
      ..writeByte(9)
      ..write(obj.modified)
      ..writeByte(10)
      ..write(obj.created)
      ..writeByte(11)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
