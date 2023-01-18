import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/button_primary_widget.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';

class DialogSuccess extends StatelessWidget {
  final String title;
  final String message;
  final String? specialText;
  final String actionText;
  final Function()? onActionTap;
  final bool isCancelable;
  final bool isErrorIcon;

  DialogSuccess({
    required this.title,
    required this.message,
    required this.actionText,
    this.specialText,
    this.onActionTap,
    this.isCancelable = false,
    this.isErrorIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isCancelable,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(left: 30, top: 40, right: 30, bottom: 25),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isErrorIcon ? Icons.info : Icons.check_circle,
                size: 64,
                color: isErrorIcon ? kTextAmountDR : kTextAmountCR,
              ),
              TextWidget.normal(
                title,
                textAlign: TextAlign.center,
                fontFamily: RFontWeight.BOLD,
                color: kMainTextColor,
                margin: EdgeInsets.only(top: 16),
              ),
              TextWidget.small(
                message,
                textAlign: TextAlign.center,
                fontFamily: RFontWeight.BOLD,
                color: kMainTextColor,
                margin: EdgeInsets.only(top: 8),
              ),
              specialText != null
                  ? TextWidget.big(
                      specialText ?? "",
                      textAlign: TextAlign.center,
                      fontFamily: RFontWeight.BOLD,
                      color: kMainTextColor,
                      margin: EdgeInsets.only(top: 4),
                    )
                  : SizedBox(height: 13),
              ButtonPrimaryWidget(
                actionText,
                margin: EdgeInsets.only(top: 13),
                onTap: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                  if (onActionTap != null) onActionTap!();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
