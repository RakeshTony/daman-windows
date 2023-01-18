import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/MyBankAccountDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import '../../Dialog/dialog_success.dart';
import 'ViewModel/view_model_my_my_bank_account.dart';

class MyBankAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyBankAccountBody();
  }
}

class MyBankAccountBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyBankAccountBodyState();
}

class _MyBankAccountBodyState
    extends BasePageState<MyBankAccountBody, ViewModelMyBankAccount>
    with SingleTickerProviderStateMixin {
  List<MyBankAccount> data = [];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    this.tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    this.tabController.addListener(() {
      if (this.tabController.indexIsChanging) {
        apiCall();
      }
    });
    viewModel.banksStream.listen((map) {
      if (data.isNotEmpty) data.clear();
      data.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);

    viewModel.responseRemoveAccStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              viewModel.requestMyBankAccount(this.tabController.index);
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
    apiCall();
  }

  void apiCall() {
    viewModel.requestMyBankAccount(this.tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kScreenBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Bank Account",
                    style: TextStyle(
                      fontSize: 14,
                      color: kWhiteColor,
                      fontWeight: RFontWeight.LIGHT,
                      fontFamily: RFontFamily.POPPINS,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: kTextInputInactive, //.withOpacity(0.73)
              child: TabBar(
                controller: tabController,
                tabs: [
                  Tab(
                    text: "SELF",
                  ),
                  Tab(
                    text: "OTHER",
                  ),
                ],
                isScrollable: false,
                indicatorColor: kMainButtonColor,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    _itemMyBankAccount(data[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: "Add Beneficiary Account",
        radius: BorderRadius.all(Radius.circular(0.0)),
        onPressed: () async {
          _addBeneficiary(null);
        },
      ),
    );
  }

  _addBeneficiary(MyBankAccount? account) async {
    var status = await Navigator.pushNamed(context, PageRoutes.addBeneficiary,
        arguments: {"account": account, "type": tabController.index});
    if (status == "RELOAD") {
      apiCall();
    }
  }

  _itemMyBankAccount(MyBankAccount account) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: ListTile(
        onTap: () {
          if (tabController.index == 1) {
            Navigator.pushNamed(context, PageRoutes.transferMoney,
                arguments: account);
          }
        },
        contentPadding: EdgeInsets.only(left: 16),
        leading: AppImage(
          account.bankLogo,
          50,
          borderColor: kMainColor,
          defaultImage: DEFAULT_PERSON,
        ),
        title: Text(
          account.firstName + " " + account.lastName,
          //textAlign: TextAlign.justify,
          style: TextStyle(
              color: kMainTextColor,
              fontFamily: RFontFamily.POPPINS,
              fontWeight: RFontWeight.REGULAR,
              fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(account.number,
            style: TextStyle(
              color: kMainTextColor,
              fontFamily: RFontFamily.POPPINS,
              fontWeight: RFontWeight.LIGHT,
              fontSize: 14,
            )),
        trailing: PopupMenuButton(
          color: kWhiteColor,
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.edit_outlined,
                          color: kMainColor,
                        ),
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                          color: kMainColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                        ),
                      )
                    ],
                  )),
              PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.delete_outline,
                          color: kMainColor,
                        ),
                      ),
                      Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 16,
                          color: kMainColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                        ),
                      )
                    ],
                  ))
            ];
          },
          onSelected: (String value) {
            if (value == "edit") {
              _addBeneficiary(account);
            } else if (value == "remove") {
              viewModel.requestDeleteBeneficiary(account.recordId);
            }
          },
        ),
      ),
    );
  }
}
