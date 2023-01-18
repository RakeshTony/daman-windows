enum BeneficiaryType { SELF, OTHER }

extension BeneficiaryTypeExtension on BeneficiaryType {
  int get value {
    switch (this) {
      case BeneficiaryType.SELF:
        return 0;
      case BeneficiaryType.OTHER:
        return 1;
      default:
        return 0;
    }
  }
}
