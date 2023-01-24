import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/windows/dialog_my_transaction.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_commission.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_prefunds.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_sales.dart';
import 'package:flutter/material.dart';

import '../../../Routes/routes.dart';
import '../../../Utils/Widgets/custom_button.dart';
import '../../../Utils/Widgets/input_field_widget.dart';
import '../../../Utils/app_action.dart';
import '../../../Utils/app_decorations.dart';
import '../../Payment/Send/ViewModel/view_model_send_money.dart';

class DialogFundRequest extends StatefulWidget {
  @override
  State<DialogFundRequest> createState() => _DialogFundRequestState();
}

class _DialogFundRequestState
    extends BasePageState<DialogFundRequest, ViewModelSendMoney> {
  TextEditingController _numberController = TextEditingController();
  FocusNode _numberNode = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) {
      if (mounted) {
        Navigator.pushNamed(context, PageRoutes.payNow,
            arguments: map.userData);
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
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
              color: kColor_1,
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
                    "${locale.sendMoney}",
                    style: title(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 0),
                    child: InkWell(
                      child: Icon(Icons.close, color: kWhiteColor, size: 16),
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
              InputFieldWidget.number(
                locale.mobileNumber ?? "",
                padding:
                    EdgeInsets.only(top: 16, right: 48, left: 0, bottom: 16),
                textEditingController: _numberController,
                focusNode: _numberNode,
              ),
              CustomButton(
                text: "Checkout",
                margin: EdgeInsets.only(top: 48, left: 16, bottom: 16),
                padding: 10,
                radius: BorderRadius.all(Radius.circular(34.0)),
                onPressed: () {
                  viewModel.requestUserWallet(_numberController);
                },
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
            Image.asset(image, height: 60),
            SizedBox(
              height: 5,
            ),
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
