// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceAdapter extends TypeAdapter<Balance> {
  @override
  final int typeId = 3;

  @override
  Balance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Balance()
      ..total = fields[0] as double
      ..lockFund = fields[1] as double
      ..balance = fields[2] as double
      ..balanceStock = fields[3] as double
      ..totalSales = fields[4] as double
      ..totalProfit = fields[5] as double
      ..dueCredits = fields[6] as double
      ..currencyCode = fields[7] as String
      ..currencySign = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, Balance obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.total)
      ..writeByte(1)
      ..write(obj.lockFund)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.balanceStock)
      ..writeByte(4)
      ..write(obj.totalSales)
      ..writeByte(5)
      ..write(obj.totalProfit)
      ..writeByte(6)
      ..write(obj.dueCredits)
      ..writeByte(7)
      ..write(obj.currencyCode)
      ..writeByte(8)
      ..write(obj.currencySign);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
