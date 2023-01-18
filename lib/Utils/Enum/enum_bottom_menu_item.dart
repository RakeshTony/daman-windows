import 'package:intl/intl.dart';

enum BottomMenuItem { HOME, REPORTS, SCAN, HISTORY, LOGOUT }

extension BottomMenuItemExtension on int {
  BottomMenuItem get page {
    switch (this) {
      case 0:
        return BottomMenuItem.HOME;
      case 1:
        return BottomMenuItem.REPORTS;
      case 2:
        return BottomMenuItem.SCAN;
      case 3:
        return BottomMenuItem.HISTORY;
      case 4:
        return BottomMenuItem.LOGOUT;
      default:
        return BottomMenuItem.HOME;
    }
  }
}

extension IntExtension on int {
  bool isBetween(int from, int to) {
    return from < this && this < to;
  }

  bool isRange(int from, int to) {
    return from <= this && this <= to;
  }
  String toSeparatorFormat() {
    return NumberFormat('#,##,000').format(this);
  }

}

extension DoubleExtension on double {
  bool isBetween(double from, double to) {
    return from < this && this < to;
  }

  bool isRange(double from, double to) {
    return from <= this && this <= to;
  }

  String toSeparatorFormat() {
    return NumberFormat.decimalPattern().format(this);
  }
}
