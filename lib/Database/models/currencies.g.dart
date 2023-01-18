// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyAdapter extends TypeAdapter<Currency> {
  @override
  final int typeId = 2;

  @override
  Currency read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Currency()
      ..id = fields[0] as String
      ..code = fields[1] as String
      ..name = fields[2] as String
      ..sign = fields[3] as String
      ..position = fields[4] as String
      ..buyingRate = fields[5] as double
      ..sellingRate = fields[6] as double
      ..defaultStatus = fields[7] as bool
      ..status = fields[8] as bool
      ..created = fields[9] as String
      ..modified = fields[10] as String;
  }

  @override
  void write(BinaryWriter writer, Currency obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.sign)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.buyingRate)
      ..writeByte(6)
      ..write(obj.sellingRate)
      ..writeByte(7)
      ..write(obj.defaultStatus)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.created)
      ..writeByte(10)
      ..write(obj.modified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
