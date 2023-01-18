// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryAdapter extends TypeAdapter<Country> {
  @override
  final int typeId = 0;

  @override
  Country read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Country()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..iso = fields[2] as String
      ..phoneCode = fields[3] as String
      ..flag = fields[4] as String
      ..mobileNumberLength = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Country obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.iso)
      ..writeByte(3)
      ..write(obj.phoneCode)
      ..writeByte(4)
      ..write(obj.flag)
      ..writeByte(5)
      ..write(obj.mobileNumberLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
