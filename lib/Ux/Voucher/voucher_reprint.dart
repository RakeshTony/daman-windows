import 'package:daman/Utils/app_action.dart';
import 'package:daman/Ux/Dialog/windows/dialog_voucher_receipt.dart';
import 'package:daman/Ux/Dialog/windows/dialog_voucher_receipt_reprint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../BaseClasses/base_state.dart';
import '../../DataBeans/VoucherReprintResponseDataModel.dart';
import '../../Locale/locales.dart';
import '../../Routes/routes.dart';
import '../../Theme/colors.dart';
import '../../Utils/Enum/enum_r_font_family.dart';
import '../../Utils/Enum/enum_r_font_weight.dart';
import '../../Utils/Enum/enum_voucher_reprint_type.dart';
import '../../Utils/Widgets/app_bar_common_widget.dart';
import '../../Utils/Widgets/custom_button.dart';
import '../../Utils/app_decorations.dart';
import '../Dialog/dialog_success.dart';
import 'ViewModel/view_model_voucher_reprint.dart';

class VoucherReprintPage extends StatelessWidget {
  final String orderNumber;

  VoucherReprintPage({required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return VoucherReprintBody(
      orderNumber: orderNumber,
    );
  }
}

class VoucherReprintBody extends StatefulWidget {
  final String orderNumber;

  VoucherReprintBody({required this.orderNumber});

  @override
  State<StatefulWidget> createState() => _VoucherReprintBodyState();
}

class _VoucherReprintBodyState
    extends BasePageState<VoucherReprintBody, ViewModelVoucherReprint> {
  List<VoucherReprintData> pinsNotRequested = [];
  List<VoucherReprintData> pinsRequested = [];
  List<VoucherReprintData> pinsApproved = [];

  @override
  void initState() {
    super.initState();
    viewModel.responseStream.listen((event) {
      if (event.pinsNotRequested.isEmpty &&
          event.pinsApproved.isEmpty &&
          event.pinsRequested.isEmpty) {
        if (mounted) {
          var dialog = DialogSuccess(
              title: "Success",
              message: event.getMessage,
              actionText: "Ok",
              isCancelable: false,
              onActionTap: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(PageRoutes.bottomNavigation),
                );
              });
          showDialog(context: context, builder: (context) => dialog);
        }
      } else {
        pinsNotRequested = event.pinsNotRequested;
        pinsRequested = event.pinsRequested;
        pinsApproved = event.pinsApproved;
        setState(() {});
        /* Navigator.pushNamedAndRemoveUntil(context, PageRoutes.voucherCheckOut,
            ModalRoute.withName(PageRoutes.bottomNavigation), arguments: {
              "operator": widget.operator,
              'voucher': event.vouchers
            });*/
      }
    });
    viewModel.requestOrderPinsData(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                constraints: BoxConstraints(
                  minHeight: 480,
                  maxHeight: 480,
                  maxWidth: 720,
                  minWidth: 720,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: kColor_1,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kTitleBackground, width: 2)),
                child: Container(
                    child: Scaffold(
                      backgroundColor: kColor_1,
                      body: SafeArea(
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: kMainButtonColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16,bottom: 16),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Voucher Reprint",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: kWhiteColor,
                                          fontWeight: RFontWeight.LIGHT,
                                          fontFamily: RFontFamily.POPPINS),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: InkWell(
                                        child: Icon(Icons.close, color: kWhiteColor),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),],),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width, //.withOpacity(0.73)
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      text: "ALL",
                                    ),
                                    Tab(
                                      text: "REQUESTED",
                                    ),
                                    Tab(
                                      text: "APPROVED",
                                    ),
                                  ],
                                  isScrollable: false,
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: kMainButtonColor,
                                  indicatorSize: TabBarIndicatorSize.label,
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    VoucherReprint(pinsNotRequested,
                                        VoucherReprintType.NOT_REQUESTED,
                                        callback: (String ids) {
                                      viewModel.requestVoucherReprintRequest(
                                          ids, widget.orderNumber);
                                    }),
                                    VoucherReprint(pinsRequested,
                                        VoucherReprintType.REQUESTED),
                                    VoucherReprint(pinsApproved,
                                        VoucherReprintType.APPROVED),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ) /*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Voucher Reprint",
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vouchersReprintData.length,
                itemBuilder: (context, index) =>
                    _itemTransaction(vouchersReprintData[index]),
              ),
            ),
          ],
        )*/
                        ,
                      ),
                    )))));
  }
}

class VoucherReprint extends StatefulWidget {
  final List<VoucherReprintData> vouchers;
  final VoucherReprintType type;
  final Function(String)? callback;

  VoucherReprint(this.vouchers, this.type, {this.callback});

  @override
  State<VoucherReprint> createState() => _VoucherReprintState();
}

class _VoucherReprintState extends State<VoucherReprint> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.vouchers.length,
            itemBuilder: (context, index) =>
                _itemTransaction(widget.vouchers[index]),
          ),
        ),
        Visibility(
          visible: widget.type == VoucherReprintType.NOT_REQUESTED &&
              widget.vouchers.isNotEmpty,
          child: Container(
            width: mediaQuery.size.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              text: "Make Reprint Request",
              radius: BorderRadius.all(Radius.circular(0.0)),
              onPressed: () async {
                //var result = await Navigator.pushNamed(context, PageRoutes.downLine);
                /*if (result == 'RELOAD') {
                // viewModel.requestDownlineUsers();
              }*/
                if (mSelectedPins.isNotEmpty) {
                  if (widget.callback != null)
                    widget.callback!(mSelectedPins.join(","));
                } else {
                  AppAction.showGeneralErrorMessage(
                      context, "Please Choose atleast on Voucher Reprint Pin");
                }
              },
            ),
          ),
        )
      ],
    );
  }

  List<String> mSelectedPins = List<String>.empty(growable: true);

  _itemTransaction(VoucherReprintData data) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: kInputBack,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.operatorTitle,
                        //textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: kWhiteColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.REGULAR,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Center(
                        child: Text(
                          data.decimalValue,
                          style: TextStyle(
                              color: kWhiteColor,
                              fontFamily: RFontFamily.POPPINS,
                              fontWeight: RFontWeight.MEDIUM,
                              fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Serial Number",
                        style: TextStyle(
                            color: kWhiteColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.MEDIUM,
                            fontSize: 14),
                      ),
                      Text(
                        data.serialNumber,
                        style: TextStyle(
                            color: kWhiteColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.MEDIUM,
                            fontSize: 14),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Used Date : " + data.assignedDate,
                        style: TextStyle(
                            color: kWhiteColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.REGULAR,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.type == VoucherReprintType.NOT_REQUESTED,
          child: IconButton(
              onPressed: () {
                if (mSelectedPins.contains(data.recordId)) {
                  mSelectedPins.remove(data.recordId);
                } else {
                  mSelectedPins.add(data.recordId);
                }
                setState(() {});
              },
              icon: Icon(
                mSelectedPins.contains(data.recordId)
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: kWhiteColor,
              )),
        ),
        Visibility(
          visible: widget.type == VoucherReprintType.APPROVED,
          child: IconButton(
              onPressed: () {
                var dialog = DialogVoucherReceiptRePrint([data]);
                showDialog(
                  context: context,
                  builder: (context) => dialog,
                );

                /*Navigator.pushNamed(context, PageRoutes.voucherReprintShare,
                    arguments: {
                      'voucher': [data]
                    });
*/
              },
              icon: Icon(
                Icons.share,
                color: kWhiteColor,
              )),
        ),
      ],
    );
  }
}
