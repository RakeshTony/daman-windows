import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/button_primary_widget.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';

class DialogError extends StatelessWidget {
  final String title;
  final String actionText;
  final Function()? onActionTap;

  DialogError({
    required this.title,
    required this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(left: 14, top: 18, right: 14, bottom: 18),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: kHintColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: kWhiteColor,
                    size: 20,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: 4),
            Icon(
              Icons.error,
              size: 64,
              color: kMainColor,
            ),
            TextWidget.medium(
              title,
              fontFamily: RFontWeight.BOLD,
              textAlign: TextAlign.center,
              color: kMainTextColor,
              margin: EdgeInsets.only(top: 20),
            ),
            ButtonPrimaryWidget(
              actionText,
              margin: EdgeInsets.only(left: 26, top: 40, right: 26, bottom: 7),
              onTap: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
                if (onActionTap != null) onActionTap!();
              },
            )
          ],
        ),
      ),
    );
  }
}
