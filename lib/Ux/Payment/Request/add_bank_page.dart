import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/DefaultBankDataModel.dart';
import 'package:daman/DataBeans/DefaultBranchDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_style_text.dart';
import '../../../Utils/app_decorations.dart';
import 'ViewModel/view_model_add_banks.dart';

class AddBankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddBankBody();
  }
}

class AddBankBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBankBodyState();
}

class _AddBankBodyState extends BasePageState<AddBankBody, ViewModelAddBanks> {
  DefaultBank defaultBank = DefaultBank(bankName: "Select Bank");
  DefaultBranch defaultBranch = DefaultBranch(branchCode: "Select Branch");

  TextEditingController _nameController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  TextEditingController _numberController = TextEditingController();
  FocusNode _numberNode = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel.requestBankList();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.defaultBankStream.listen((map) {
      if (spinnerItemsBanks.isNotEmpty) spinnerItemsBanks.clear();
      spinnerItemsBanks.add(defaultBank);
      spinnerItemsBanks.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.branchStream.listen((map) {
      if (spinnerItemsBranch.isNotEmpty) spinnerItemsBranch.clear();
      spinnerItemsBranch.add(defaultBranch);
      spinnerItemsBranch.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) {}, cancelOnError: false);
  }

  DefaultBranch? dropdownValueBranch;
  DefaultBank? dropdownValueBank;

  List<DefaultBranch> spinnerItemsBranch = [];
  List<DefaultBank> spinnerItemsBanks = [];

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    if (dropdownValueBank == null) dropdownValueBank = defaultBank;
    if (dropdownValueBranch == null) dropdownValueBranch = defaultBranch;
    if (spinnerItemsBanks.isEmpty) spinnerItemsBanks.add(defaultBank);
    if (spinnerItemsBranch.isEmpty) spinnerItemsBranch.add(defaultBranch);
    return Container(
      decoration: decorationBackground,
      child: Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextWidget.big(
                  "Link Bank Account",
                  fontFamily: RFontWeight.REGULAR,
                  textAlign: TextAlign.center,
                  color: kWhiteColor,
                  fontSize: 18,
                ),
              ),
              InputFieldWidget.text(
                "Account Holder Name",
                margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                textEditingController: _nameController,
                focusNode: _nameNode,
              ),
              InputFieldWidget.number(
                "Account No.",
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                textEditingController: _numberController,
                focusNode: _numberNode,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: kTextInputInactive),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DefaultBank>(
                    value: dropdownValueBank,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    isDense: true,
                    style: AppStyleText.inputFiledPrimaryText,
                    onChanged: (data) {
                      setState(() {
                        dropdownValueBank = data!;
                        spinnerItemsBranch.clear();
                        dropdownValueBranch = defaultBranch;
                        spinnerItemsBranch.add(defaultBranch);
                        var bankId = dropdownValueBank?.id ?? "";
                        if (dropdownValueBank?.id != "") {
                          viewModel.requestBranchList(bankId);
                        }
                        setState(() {});
                      });
                    },
                    items: spinnerItemsBanks.map<DropdownMenuItem<DefaultBank>>(
                        (DefaultBank value) {
                      return DropdownMenuItem<DefaultBank>(
                        value: value,
                        child: Text(value.bankName),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 12),
                margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: kTextInputInactive),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DefaultBranch>(
                    value: dropdownValueBranch,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    isDense: true,
                    style: AppStyleText.inputFiledPrimaryText,
                    onChanged: (data) {
                      setState(() {
                        dropdownValueBranch = data!;
                      });
                    },
                    items: spinnerItemsBranch
                        .map<DropdownMenuItem<DefaultBranch>>(
                            (DefaultBranch value) {
                      return DropdownMenuItem<DefaultBranch>(
                        value: value,
                        child: Text(value.branchCode),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: mediaQuery.size.width,
                child: CustomButton(
                  text: "Submit",
                  radius: BorderRadius.all(Radius.circular(34.0)),
                  margin: EdgeInsets.all(16),
                  onPressed: () {
                    viewModel.requestAddBanks(
                        _nameController,
                        _numberController,
                        dropdownValueBank,
                        dropdownValueBranch);
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}
