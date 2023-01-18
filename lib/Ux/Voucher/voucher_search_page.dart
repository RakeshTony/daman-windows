import 'package:cached_network_image/cached_network_image.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/denomination.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utils/app_decorations.dart';

class VoucherSearchPage extends StatelessWidget {
  final Operator operator;

  VoucherSearchPage(this.operator);

  @override
  Widget build(BuildContext context) {
    return VoucherSearchBody(operator);
  }
}

class VoucherSearchBody extends StatefulWidget {
  final Operator operator;

  VoucherSearchBody(this.operator);

  @override
  State<StatefulWidget> createState() => _VoucherSearchBodyState();
}

class _VoucherSearchBodyState
    extends BasePageState<VoucherSearchBody, ViewModelCommon> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchNode = FocusNode();
  var mDenominations = HiveBoxes.getDenomination();
  var _wallet = HiveBoxes.getBalanceWallet();
  List<Denomination> filterData = [];

  _doSearchListener() {
    var key = _searchController.text;
    if (filterData.isNotEmpty) filterData.clear();
    if (key.isNotEmpty) {
      filterData.addAll(mDenominations.values
          .where((element) =>
              element.title.startsWithIgnoreCase(key) &&
              element.operatorId == widget.operator.id)
          .toList());
    } else {
      filterData.addAll(mDenominations.values
          .where((element) => element.operatorId == widget.operator.id)
          .toList());
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_doSearchListener);
    if (filterData.isEmpty)
      //filterData.addAll(mDenominations.values.toList(growable: true));
      filterData.addAll(mDenominations.values
          .where((element) => element.operatorId == widget.operator.id)
          .toList());
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: decorationBackground,
      child: Scaffold(
        appBar: AppBarCommonWidget(),
        // appBar: AppBar(),
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchNode,
                  textInputAction: TextInputAction.search,
                  cursorColor: kWhiteColor,
                  style: TextStyle(
                    fontSize: 16,
                    color: kWhiteColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.REGULAR,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.search!,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: kWhiteColor,
                        size: 24,
                      ),
                      prefixIconConstraints:
                          BoxConstraints(maxHeight: 24, maxWidth: 24)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: filterData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16),
                    itemBuilder: (context, index) =>
                        _itemVouchers(filterData[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemVouchers(Denomination voucher) {
    return Container(
      color: kScreenBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: kWhiteColor,
            padding: EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 110.0,
                  height: 110.0,
                  child: AspectRatio(
                    aspectRatio: 5 / 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: /*FadeInImage(
                      image: NetworkImage(voucher.logo),
                      fit: BoxFit.fill,
                      placeholder: AssetImage(DUMMY_BANNER),
                      imageErrorBuilder: ((context, error, stackTrace) {
                        return Image.asset(
                          DUMMY_BANNER,
                          fit: BoxFit.cover,
                        );
                      }),
                    )*/
                          CachedNetworkImage(
                        imageUrl: voucher.logo,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(DUMMY_BANNER),
                        ),
                        errorWidget: (context, url, error) => AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(DUMMY_BANNER),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    voucher.title,
                    style: TextStyle(
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.SEMI_BOLD,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourPrice!,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                    Text(
                      "${_wallet?.currencySign}${voucher.denomination}",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourPrice!,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                    Text(
                      "${_wallet?.currencySign}${voucher.sellingPrice}",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  child: CustomButton(
                    text: AppLocalizations.of(context)!.buyNow!,
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    padding: 0,
                    style: Theme.of(context).textTheme.button!.copyWith(
                        fontWeight: RFontWeight.REGULAR, fontSize: 10),
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        PageRoutes.voucherProcess,
                        arguments: {
                          'denomination': voucher,
                          'operator': widget.operator
                        },
                      );

                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
