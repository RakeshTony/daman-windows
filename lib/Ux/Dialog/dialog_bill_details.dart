import 'package:flutter/material.dart';
import 'package:daman/DataBeans/OperatorValidateDataModel.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';


class DialogBillDetails extends StatelessWidget {
  OperatorValidateData data;
  final bool isCancelable;

  DialogBillDetails(
    this.data, {
    this.isCancelable = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isCancelable,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Name :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.customerName,
                      style: description(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Address :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.customerAddress,
                      style: description(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "District :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.customerDistrict,
                      style: description(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Phone :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.phoneNumber,
                      style: description(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Discom :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.disco,
                      style: description(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Min Payable :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.minimumPayable.toString(),
                      style: description(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Due Amount :",
                    style: title(),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      data.outstandingAmount.toString(),
                      style: description(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle title() {
    return TextStyle(
        color: kMainTextColor,
        fontSize: 14,
        fontWeight: RFontWeight.BOLD,
        fontFamily: RFontFamily.POPPINS);
  }

  TextStyle description() {
    return TextStyle(
        color: kMainTextColor,
        fontSize: 12,
        fontWeight: RFontWeight.REGULAR,
        fontFamily: RFontFamily.POPPINS);
  }
}
