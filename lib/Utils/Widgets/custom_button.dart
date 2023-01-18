import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final Color? borderColor;
  final Color? color;
  final TextStyle? style;
  final BorderRadius? radius;
  final EdgeInsets? margin;
  final double? padding;

  CustomButton({
    this.text,
    this.onPressed,
    this.borderColor,
    this.color,
    this.style,
    this.radius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: padding ?? 18),
        onPressed: onPressed as void Function()?,
        disabledColor: theme.disabledColor,
        color: color ?? kMainButtonColor,
        shape: OutlineInputBorder(
          borderRadius: radius ?? BorderRadius.zero,
          borderSide: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        child: Text(
          text ?? "",
          style: style ?? Theme.of(context).textTheme.button!.copyWith(fontWeight: RFontWeight.REGULAR,fontSize: 16,fontFamily: RFontFamily.POPPINS),
        ),
      ),
    );
  }
}
