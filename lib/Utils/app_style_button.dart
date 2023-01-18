import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/app_style_text.dart';

class AppStyleButton {
  AppStyleButton._();

  static var buttonPrimary = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(kMainColor),
    textStyle: MaterialStateProperty.all(AppStyleText.buttonPrimary),
    foregroundColor: MaterialStateProperty.all(kWhiteColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(34.0)),
    ),
  );

  static var buttonFlat = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(kDisabledColor),
    textStyle: MaterialStateProperty.all(AppStyleText.buttonFlat),
  );

  static var buttonFlatPrimary = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(kWhiteColor),
    textStyle: MaterialStateProperty.all(AppStyleText.buttonFlatPrimary),
  );

/*  static var buttonPrimaryIcon = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(AppColors.buttonPrimaryIconBackground),
    elevation: MaterialStateProperty.all(0.0),
    shadowColor: MaterialStateProperty.all(AppColors.buttonFlatText),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    ),
    textStyle: MaterialStateProperty.all(AppStyleText.buttonPrimaryIcon),
    alignment: Alignment.centerLeft,
    foregroundColor: MaterialStateProperty.all(AppColors.buttonPrimaryIconText),
  );


  static var buttonMenu = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColors.buttonMenuText),
    textStyle: MaterialStateProperty.all(AppStyleText.buttonMenu),
  );
  static var buttonMenuActive = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColors.buttonMenuActiveText),
    textStyle: MaterialStateProperty.all(AppStyleText.buttonMenuActive),
  );*/
}
