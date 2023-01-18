import 'package:daman/Database/models/offline_pin_stock.dart';
import 'package:hive/hive.dart';
import 'package:daman/Database/hive_database.dart';
import 'package:daman/Database/models/app_media.dart';
import 'package:daman/Database/models/app_pages.dart';
import 'package:daman/Database/models/balance.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Database/models/currencies.dart';
import 'package:daman/Database/models/default_config.dart';
import 'package:daman/Database/models/denomination.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/push_notification.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Database/models/services_child.dart';

class HiveBoxes {
  HiveBoxes._();

  static Box<Country> getCountries() => Hive.box<Country>(Table.COUNTRIES);

  static Box<ServiceChild> getServicesChild() =>
      Hive.box<ServiceChild>(Table.SERVICE_CHILD);

  static Box<Currency> getCurrencies() => Hive.box<Currency>(Table.CURRENCIES);

  static Box<Balance> getBalance() => Hive.box<Balance>(Table.BALANCE);

  static Balance? getBalanceWallet() => getBalance().get("BAL");

  static Box<Service> getServices() => Hive.box<Service>(Table.SERVICE);

  static Box<Operator> getOperators() => Hive.box<Operator>(Table.OPERATOR);

  static Box<Denomination> getDenomination() =>
      Hive.box<Denomination>(Table.DENOMINATION);

  static Box<RecentTransaction> getRecentTransactions() =>
      Hive.box<RecentTransaction>(Table.RECENT_TRANSACTIONS);

  static Box<AppMedia> getAppMedia() => Hive.box<AppMedia>(Table.APP_MEDIA);

  static Box<DefaultConfig> getDefaultConfig() =>
      Hive.box<DefaultConfig>(Table.DEFAULT_CONFIG);

  static Box<AppPages> getAppPages() => Hive.box<AppPages>(Table.APP_PAGES);

  static Box<PushNotification> getPushNotification() =>
      Hive.box<PushNotification>(Table.PUSH_NOTIFICATION);

  static Box<OfflinePinStock> getOfflinePinStock() =>
      Hive.box<OfflinePinStock>(Table.OFFLINE_PIN_STOCK);

}
