import 'package:hive/hive.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';

part 'denomination.g.dart';

@HiveType(typeId: 6)
class Denomination {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String serviceId;
  @HiveField(2)
  late String operatorId;
  @HiveField(3)
  late String title;
  @HiveField(4)
  late bool type;
  @HiveField(5)
  late double denomination;
  @HiveField(6)
  late String denominationSign;
  @HiveField(7)
  late double sellingPrice;
  @HiveField(8)
  late String logo;
  @HiveField(9)
  late String printFormat;
  @HiveField(10)
  late String categoryId;
  @HiveField(11)
  late String categoryTitle;
  @HiveField(12)
  late String categoryIcon;
  @HiveField(13)
  late String currencyId;
  @HiveField(14)
  late String currencySign;
  @HiveField(15)
  late double conversionPrice;
}

extension DenominationExtension on Denomination {
  DenominationData get toDenomination => DenominationData()
    ..serviceId = this.serviceId
    ..operatorId = this.operatorId
    ..id = this.id
    ..title = this.title
    ..type = this.type
    ..denomination = this.denomination
    ..denominationSign = this.denominationSign
    ..sellingPrice = this.sellingPrice
    ..logo = this.logo
    ..printFormat = this.printFormat
    ..categoryId = this.categoryId
    ..categoryTitle = this.categoryTitle
    ..categoryIcon = this.categoryIcon
    ..currencyId = this.currencyId
    ..currencySign = this.currencySign
    ..conversionPrice = this.conversionPrice;
}
