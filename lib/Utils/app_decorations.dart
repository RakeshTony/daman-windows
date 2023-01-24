import 'package:daman/Utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';

var decorationBackground = BoxDecoration(
  color: kMainColor,
  image: DecorationImage(
    image: AssetImage(SPLASH),
    fit: BoxFit.fill,
  ),
);
var decorationCardBackground = BoxDecoration(
  color: kColor_1,
  image: DecorationImage(
    image: AssetImage(IC_CARD_BACKGROUND),
    fit: BoxFit.fill,
  ),
);

const BUTTON_GRADIENT = LinearGradient(
  colors: [
    kGradientButtonStart,
    kGradientButtonCenter,
    kGradientButtonEnd,
  ],
);
const CARD_GRADIENT = LinearGradient(
  colors: [
    kGradientButtonStart,
    kGradientButtonEnd,
  ],
);
