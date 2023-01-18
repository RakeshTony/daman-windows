import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';

class TextWidget {
  TextWidget._();

  static Widget big(String text,
          {double fontSize = 20,
          FontWeight? fontFamily,
          Color? color,
          EdgeInsets? padding,
          EdgeInsets? margin,
          Alignment? alignment,
          TextAlign? textAlign,
          TextDecoration? decoration,
          int? maxLine}) =>
      _BuildTextWidget(text, fontSize, fontFamily, color, padding, margin,
          alignment, textAlign, decoration, maxLine);

  static Widget medium(String text,
          {double fontSize = 18,
          FontWeight? fontFamily,
          Color? color,
          EdgeInsets? padding,
          EdgeInsets? margin,
          Alignment? alignment,
          TextAlign? textAlign,
          TextDecoration? decoration,
          int? maxLine}) =>
      _BuildTextWidget(text, fontSize, fontFamily, color, padding, margin,
          alignment, textAlign, decoration, maxLine);

  static Widget normal(String text,
          {double fontSize = 16,
          FontWeight? fontFamily,
          Color? color,
          EdgeInsets? padding,
          EdgeInsets? margin,
          Alignment? alignment,
          TextAlign? textAlign,
          TextDecoration? decoration,
          int? maxLine}) =>
      _BuildTextWidget(text, fontSize, fontFamily, color, padding, margin,
          alignment, textAlign, decoration, maxLine);

  static Widget small(String text,
          {double fontSize = 14,
          FontWeight? fontFamily,
          Color? color,
          EdgeInsets? padding,
          EdgeInsets? margin,
          Alignment? alignment,
          TextAlign? textAlign,
          TextDecoration? decoration,
          int? maxLine}) =>
      _BuildTextWidget(text, fontSize, fontFamily, color, padding, margin,
          alignment, textAlign, decoration, maxLine);

  static Widget tiny(String text,
          {double fontSize = 12,
          FontWeight? fontFamily,
          Color? color,
          EdgeInsets? padding,
          EdgeInsets? margin,
          Alignment? alignment,
          TextAlign? textAlign,
          TextDecoration? decoration,
          int? maxLine}) =>
      _BuildTextWidget(text, fontSize, fontFamily, color, padding, margin,
          alignment, textAlign, decoration, maxLine);
}

class _BuildTextWidget extends StatefulWidget {
  final Color? color;
  final String text;
  final FontWeight? fontWeight;
  final double fontSize;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;

  _BuildTextWidget(
      this.text,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.padding,
      this.margin,
      this.alignment,
      this.textAlign,
      this.decoration,
      this.maxLines);

  @override
  State<StatefulWidget> createState() => _BuildTextWidgetState();
}

class _BuildTextWidgetState extends State<_BuildTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      alignment: widget.alignment,
      child: Text(
        widget.text,
        style: TextStyle(
          fontWeight: widget.fontWeight ?? RFontWeight.REGULAR,
          fontSize: widget.fontSize,
          color: widget.color ?? kMainTextColor,
          decoration: widget.decoration,
        ),
        maxLines: widget.maxLines,
        textAlign: widget.textAlign,
        overflow: widget.maxLines == null
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
      ),
    );
  }
}
