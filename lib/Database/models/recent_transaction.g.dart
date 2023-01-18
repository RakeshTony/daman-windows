// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentTransactionAdapter extends TypeAdapter<RecentTransaction> {
  @override
  final int typeId = 7;

  @override
  RecentTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentTransaction()
      ..operator = fields[0] as String
      ..operatorLogo = fields[1] as String
      ..orderNumber = fields[2] as String
      ..orderQuantity = fields[3] as String
      ..user = fields[4] as String
      ..transaction = fields[5] as String
      ..type = fields[6] as String
      ..consider = fields[7] as String
      ..amount = fields[8] as double
      ..openBal = fields[9] as double
      ..closeBal = fields[10] as double
      ..created = fields[11] as String
      ..narration = fields[12] as String;
  }

  @override
  void write(BinaryWriter writer, RecentTransaction obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.operator)
      ..writeByte(1)
      ..write(obj.operatorLogo)
      ..writeByte(2)
      ..write(obj.orderNumber)
      ..writeByte(3)
      ..write(obj.orderQuantity)
      ..writeByte(4)
      ..write(obj.user)
      ..writeByte(5)
      ..write(obj.transaction)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.consider)
      ..writeByte(8)
      ..write(obj.amount)
      ..writeByte(9)
      ..write(obj.openBal)
      ..writeByte(10)
      ..write(obj.closeBal)
      ..writeByte(11)
      ..write(obj.created)
      ..writeByte(12)
      ..write(obj.narration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
