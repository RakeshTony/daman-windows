// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_pages.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPagesAdapter extends TypeAdapter<AppPages> {
  @override
  final int typeId = 11;

  @override
  AppPages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPages()
      ..content = fields[0] as String
      ..excerpt = fields[1] as String
      ..slug = fields[2] as String
      ..title = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, AppPages obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.excerpt)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
