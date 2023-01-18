import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_style_text.dart';

class DialogCountryPicker extends StatefulWidget {
  List<CountryData> data;
  Function(CountryData)? onTap;

  DialogCountryPicker({required this.data, this.onTap});

  @override
  State createState() {
    return _DialogCountryPickerState();
  }
}

class _DialogCountryPickerState
    extends BasePageState<DialogCountryPicker, ViewModelCommon> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  List<CountryData> filterData = [];

  void doSearchListener() {
    var key = _searchController.text;
    if (filterData.isNotEmpty) filterData.clear();
    if (key.isNotEmpty) {
      filterData.addAll(widget.data
          .where((element) => element.title.startsWithIgnoreCase(key))
          .toList());
    } else {
      filterData.addAll(widget.data);
    }
    setState(() {});
  }

  @override
  void initState() {
    _searchController.addListener(doSearchListener);
    if (filterData.isEmpty) filterData.addAll(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Dialog(
          backgroundColor: kTransparentColor,
          insetPadding: EdgeInsets.all(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: AppStyleText.inputFiledPrimaryText
                      .copyWith(color: kWhiteColor),
                  decoration: InputDecoration(
                    hintText: "Search Country",
                    hintStyle: AppStyleText.inputFiledPrimaryHint
                        .copyWith(color: kWhiteColor),
                    isDense: true,
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: kMainColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset(
                        IC_SEARCH,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: filterData.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        if (widget.onTap != null) {
                          widget.onTap!(filterData[index]);
                          Navigator.pop(context);
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 52,
                        height: 52,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26.0),
                          child: CachedNetworkImage(
                            imageUrl: filterData[index].flag,
                            height: 52,
                            width: 52,
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset(DEFAULT_FLAG),
                            ),
                            errorWidget: (context, url, error) => AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset(DEFAULT_FLAG),
                            ),
                          ) /*FadeInImage(
                            image: NetworkImage(filterData[index].flag),
                            width: 52,
                            height: 52,
                            placeholder: AssetImage(DEFAULT_FLAG),
                            imageErrorBuilder: ((context, error, stackTrace) {
                              return Image.asset(DEFAULT_FLAG);
                            }),
                          )*/
                          ,
                        ),
                      ),
                      title: Text(
                        filterData[index].title,
                        style: TextStyle(
                            color: kMainTextColor,
                            fontWeight: RFontWeight.LIGHT,
                            fontSize: 18),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => true);
  }
}
