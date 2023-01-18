// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DefaultConfigAdapter extends TypeAdapter<DefaultConfig> {
  @override
  final int typeId = 10;

  @override
  DefaultConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DefaultConfig()
      ..balance = fields[0] as String
      ..complaint = fields[1] as String
      ..contactNo = fields[2] as String
      ..faq = fields[3] as String
      ..fundTransfer = fields[4] as String
      ..fUrl = fields[5] as String
      ..last5 = fields[6] as String
      ..logoUrl = fields[7] as String
      ..longCode = fields[8] as String
      ..recharge = fields[9] as String
      ..register = fields[10] as String
      ..support = fields[11] as String
      ..tcUrl = fields[12] as String
      ..timeOut = fields[13] as String
      ..twitterUrl = fields[14] as String
      ..warehouse = fields[15] as String
      ..whatsAppNo = fields[16] as String
      ..facebookUrl = fields[17] as String
      ..website = fields[18] as String
      ..email = fields[19] as String;
  }

  @override
  void write(BinaryWriter writer, DefaultConfig obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.balance)
      ..writeByte(1)
      ..write(obj.complaint)
      ..writeByte(2)
      ..write(obj.contactNo)
      ..writeByte(3)
      ..write(obj.faq)
      ..writeByte(4)
      ..write(obj.fundTransfer)
      ..writeByte(5)
      ..write(obj.fUrl)
      ..writeByte(6)
      ..write(obj.last5)
      ..writeByte(7)
      ..write(obj.logoUrl)
      ..writeByte(8)
      ..write(obj.longCode)
      ..writeByte(9)
      ..write(obj.recharge)
      ..writeByte(10)
      ..write(obj.register)
      ..writeByte(11)
      ..write(obj.support)
      ..writeByte(12)
      ..write(obj.tcUrl)
      ..writeByte(13)
      ..write(obj.timeOut)
      ..writeByte(14)
      ..write(obj.twitterUrl)
      ..writeByte(15)
      ..write(obj.warehouse)
      ..writeByte(16)
      ..write(obj.whatsAppNo)
      ..writeByte(17)
      ..write(obj.facebookUrl)
      ..writeByte(18)
      ..write(obj.website)
      ..writeByte(19)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
