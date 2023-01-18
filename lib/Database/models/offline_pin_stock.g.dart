// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_pin_stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflinePinStockAdapter extends TypeAdapter<OfflinePinStock> {
  @override
  final int typeId = 13;

  @override
  OfflinePinStock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflinePinStock()
      ..recordId = fields[0] as String
      ..operatorId = fields[1] as String
      ..operatorTitle = fields[2] as String
      ..denominationId = fields[3] as String
      ..denominationTitle = fields[4] as String
      ..batchNumber = fields[5] as String
      ..pinNumber = fields[6] as String
      ..serialNumber = fields[7] as String
      ..decimalValue = fields[8] as String
      ..sellingPrice = fields[9] as String
      ..faceValue = fields[10] as String
      ..voucherValidityInDays = fields[11] as String
      ..expiryDate = fields[12] as String
      ..assignedDate = fields[13] as String
      ..orderNumber = fields[14] as String
      ..usedDate = fields[15] as String
      ..denominationCurrency = fields[16] as String
      ..denominationCurrencySign = fields[17] as String
      ..decimalValueConversionPrice = fields[18] as String
      ..sellingPriceConversionPrice = fields[19] as String
      ..receiptData = fields[20] as String
      ..isSold = fields[21] as bool
      ..syncServer = fields[22] as bool
      ..time = fields[23] as DateTime
      ..status = fields[24] as int;
  }

  @override
  void write(BinaryWriter writer, OfflinePinStock obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.recordId)
      ..writeByte(1)
      ..write(obj.operatorId)
      ..writeByte(2)
      ..write(obj.operatorTitle)
      ..writeByte(3)
      ..write(obj.denominationId)
      ..writeByte(4)
      ..write(obj.denominationTitle)
      ..writeByte(5)
      ..write(obj.batchNumber)
      ..writeByte(6)
      ..write(obj.pinNumber)
      ..writeByte(7)
      ..write(obj.serialNumber)
      ..writeByte(8)
      ..write(obj.decimalValue)
      ..writeByte(9)
      ..write(obj.sellingPrice)
      ..writeByte(10)
      ..write(obj.faceValue)
      ..writeByte(11)
      ..write(obj.voucherValidityInDays)
      ..writeByte(12)
      ..write(obj.expiryDate)
      ..writeByte(13)
      ..write(obj.assignedDate)
      ..writeByte(14)
      ..write(obj.orderNumber)
      ..writeByte(15)
      ..write(obj.usedDate)
      ..writeByte(16)
      ..write(obj.denominationCurrency)
      ..writeByte(17)
      ..write(obj.denominationCurrencySign)
      ..writeByte(18)
      ..write(obj.decimalValueConversionPrice)
      ..writeByte(19)
      ..write(obj.sellingPriceConversionPrice)
      ..writeByte(20)
      ..write(obj.receiptData)
      ..writeByte(21)
      ..write(obj.isSold)
      ..writeByte(22)
      ..write(obj.syncServer)
      ..writeByte(23)
      ..write(obj.time)
      ..writeByte(24)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflinePinStockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
