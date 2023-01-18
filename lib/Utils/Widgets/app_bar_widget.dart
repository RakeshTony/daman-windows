import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final Function() onBackTap;
  AppBarWidget(this.title, this.onBackTap);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMainColor,
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: kWhiteColor,
              size: 20,
            ),
            onPressed: onBackTap,
          ),
          Expanded(
            child: TextWidget.normal(
              title,
              color: kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}