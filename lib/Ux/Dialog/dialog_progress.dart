import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';

class DialogProgress extends StatelessWidget {
  final BuildContext context;
  final String title;

  DialogProgress(this.context, this.title);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kMainColor),
              ),
              SizedBox(width: 24),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dismiss() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}
