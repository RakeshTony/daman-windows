import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';

class AppStyleText {
  AppStyleText._();

  /*--------------- BUTTON MENU ----------------*/
  static const buttonMenu = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  static const buttonMenuActive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  /*--------------- BUTTONS ----------------*/
  static const buttonPrimary = TextStyle(
    fontSize: 24,
    fontWeight: RFontWeight.REGULAR,
  );
  static const buttonPrimaryIcon = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  static const buttonFlat = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const buttonFlatPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /*-------------- INTRODUCTION ------------*/
  static const introHeading = TextStyle(
    fontSize: 18,
    color: kMainTextColor,
    fontWeight: FontWeight.bold,
  );
  static const introDescription = TextStyle(
    fontSize: 12,
    color: kMainTextColor,
    fontWeight: FontWeight.normal,
  );

  /*-------------- APP BAR ------------*/
  static const appBarTitle = TextStyle(
    fontSize: 12,
    color: kWhiteColor,
    fontWeight: FontWeight.w500,
  );

  /*------------ INPUT FILED ------------*/
  static const inputFiledPrimaryText = TextStyle(
    fontSize: 15,
    fontWeight: RFontWeight.LIGHT,
    color: kWhiteColor,
    height: 1.5,
  );
  static const inputFiledPrimaryText2 = TextStyle(
    fontSize: 15,
    fontWeight: RFontWeight.LIGHT,
    color: kMainTextColor,
    height: 1.5,
  );
  static const inputFiledPrimaryHint2 = TextStyle(
      fontSize: 15, fontWeight: RFontWeight.LIGHT, color: kMainTextColor);
  static const inputFiledPrimaryHint =
      TextStyle(fontSize: 15, fontWeight: RFontWeight.LIGHT, color: kHintColor);
}
