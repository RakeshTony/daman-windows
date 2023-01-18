// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DenominationAdapter extends TypeAdapter<Denomination> {
  @override
  final int typeId = 6;

  @override
  Denomination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Denomination()
      ..id = fields[0] as String
      ..serviceId = fields[1] as String
      ..operatorId = fields[2] as String
      ..title = fields[3] as String
      ..type = fields[4] as bool
      ..denomination = fields[5] as double
      ..denominationSign = fields[6] as String
      ..sellingPrice = fields[7] as double
      ..logo = fields[8] as String
      ..printFormat = fields[9] as String
      ..categoryId = fields[10] as String
      ..categoryTitle = fields[11] as String
      ..categoryIcon = fields[12] as String
      ..currencyId = fields[13] as String
      ..currencySign = fields[14] as String
      ..conversionPrice = fields[15] as double;
  }

  @override
  void write(BinaryWriter writer, Denomination obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceId)
      ..writeByte(2)
      ..write(obj.operatorId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.denomination)
      ..writeByte(6)
      ..write(obj.denominationSign)
      ..writeByte(7)
      ..write(obj.sellingPrice)
      ..writeByte(8)
      ..write(obj.logo)
      ..writeByte(9)
      ..write(obj.printFormat)
      ..writeByte(10)
      ..write(obj.categoryId)
      ..writeByte(11)
      ..write(obj.categoryTitle)
      ..writeByte(12)
      ..write(obj.categoryIcon)
      ..writeByte(13)
      ..write(obj.currencyId)
      ..writeByte(14)
      ..write(obj.currencySign)
      ..writeByte(15)
      ..write(obj.conversionPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DenominationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
