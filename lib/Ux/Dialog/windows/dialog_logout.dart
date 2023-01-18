import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:flutter/material.dart';

import '../../../Utils/app_decorations.dart';

class DialogLogout extends StatefulWidget {
  final Function() onTap;

  DialogLogout(this.onTap);

  @override
  State<DialogLogout> createState() => _DialogLogoutState();
}

class _DialogLogoutState extends BasePageState<DialogLogout, ViewModelCommon> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 320,
            minWidth: 320,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Logging out",
                    style: title(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      child: Icon(Icons.close, color: kWhiteColor),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Are you sure?",
                style: title(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: BUTTON_GRADIENT,
                          borderRadius: BorderRadius.all(Radius.circular(34.0)),
                        ),
                        child: Text(
                          "No",
                          style: Theme.of(context).textTheme.button!.copyWith(
                              fontWeight: RFontWeight.REGULAR, fontSize: 14),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onTap,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: BUTTON_GRADIENT,
                          borderRadius: BorderRadius.all(Radius.circular(34.0)),
                        ),
                        child: Text(
                          "Yes",
                          style: Theme.of(context).textTheme.button!.copyWith(
                              fontWeight: RFontWeight.REGULAR, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration = BoxDecoration(
    gradient: BUTTON_GRADIENT,
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  Widget _buildButtonWidget(String image, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 133,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: decoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: 100),
            Text("$label", style: title()),
          ],
        ),
      ),
    );
  }

  TextStyle title() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 13,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }
}
