enum FundType {
  CREDIT_MONEY,
  ADD_MONEY,
  BANK_CARD,
}

extension FundTypeExtension on FundType {
  int get value {
    switch (this) {
      case FundType.CREDIT_MONEY:
        return 1;
      case FundType.ADD_MONEY:
        return 0;
      case FundType.BANK_CARD:
        return 2;
      default:
        return 0;
    }
  }
}
