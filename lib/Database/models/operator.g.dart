// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperatorAdapter extends TypeAdapter<Operator> {
  @override
  final int typeId = 5;

  @override
  Operator read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Operator(
      id: fields[1] as String,
      serviceId: fields[0] as String,
      name: fields[2] as String,
      code: fields[3] as String,
      logo: fields[4] as String,
      banner: fields[5] as String,
      bmp: fields[6] as String,
      minRechargeAmount: fields[7] as double,
      maxRechargeAmount: fields[8] as double,
      minLength: fields[9] as int,
      maxLength: fields[10] as int,
      isDenomination: fields[11] as bool,
      topUpFormat: fields[12] as String,
      rType: fields[13] as String,
      opType: fields[14] as String,
      topUp: fields[15] as String,
      pin: fields[16] as String,
      inst: fields[17] as String,
      dmCount: fields[18] as int,
      isFav: fields[19] as int,
      countryId: fields[20] as String,
      currencyId: fields[21] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Operator obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.serviceId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.logo)
      ..writeByte(5)
      ..write(obj.banner)
      ..writeByte(6)
      ..write(obj.bmp)
      ..writeByte(7)
      ..write(obj.minRechargeAmount)
      ..writeByte(8)
      ..write(obj.maxRechargeAmount)
      ..writeByte(9)
      ..write(obj.minLength)
      ..writeByte(10)
      ..write(obj.maxLength)
      ..writeByte(11)
      ..write(obj.isDenomination)
      ..writeByte(12)
      ..write(obj.topUpFormat)
      ..writeByte(13)
      ..write(obj.rType)
      ..writeByte(14)
      ..write(obj.opType)
      ..writeByte(15)
      ..write(obj.topUp)
      ..writeByte(16)
      ..write(obj.pin)
      ..writeByte(17)
      ..write(obj.inst)
      ..writeByte(18)
      ..write(obj.dmCount)
      ..writeByte(19)
      ..write(obj.isFav)
      ..writeByte(20)
      ..write(obj.countryId)
      ..writeByte(21)
      ..write(obj.currencyId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperatorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
