import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';

class ButtonPrimaryWidget extends StatefulWidget {
  final String title;
  final bool isDisabled;
  final EdgeInsets? margin;
  final GestureTapCallback? onTap;
  final double height;
  final double radius;
  final double textSize;

  ButtonPrimaryWidget(this.title,
      {this.isDisabled = false,
      this.margin,
      this.onTap,
      this.height = 56,
      this.radius = 8,
      this.textSize = 14});

  @override
  State<StatefulWidget> createState() => _ButtonPrimaryWidgetState();
}

class _ButtonPrimaryWidgetState extends State<ButtonPrimaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: InkWell(
        child: Container(
          height: widget.height,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color:
                  widget.isDisabled ? kMainColor.withOpacity(.5) : kMainColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius))),
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.isDisabled
                  ? kWhiteColor.withOpacity(.5)
                  : kWhiteColor,
              fontWeight: FontWeight.w500,
              fontSize: widget.textSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
