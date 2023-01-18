
import 'package:daman/Utils/app_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Locale/language_cubit.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Enum/enum_r_font_weight.dart';
import '../../Utils/Widgets/text_widget.dart';
import '../../Utils/app_icons.dart';
import '../../main.dart';

class DialogChangeLanguage extends StatefulWidget {
  final Function(String)? onTap;
  final String? language;

  DialogChangeLanguage({
    this.language,
    this.onTap,
  });

  @override
  State<DialogChangeLanguage> createState() => _DialogChangeLanguageState();
}

class _DialogChangeLanguageState extends State<DialogChangeLanguage> {
  late LanguageCubit _languageCubit;
  int? _selectedLanguage = -1;

  @override
  void initState() {
    super.initState();
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
  }

  final List<String> _languages = [
    'English',
    'عربى',
  ];
//'کوردی',todo
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(builder: (context, locale) {
      _selectedLanguage = getCurrentLanguage(locale);
      return WillPopScope(
        onWillPop: () async => true,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.normal(AppLocalizations.of(context)!.changeLanguage!,
                    textAlign: TextAlign.start,
                    fontFamily: RFontWeight.REGULAR,
                    color: kMainTextColor,
                    fontSize: 20),
                SizedBox(
                  height: 20,
                ),
                _itemLanguage(context, 0, "en", _languages[0]),
                SizedBox(
                  height: 12,
                ),
                _itemLanguage(context, 1, "ar", _languages[1]),
                //todo
                /*SizedBox(
                  height: 12,
                ),
                _itemLanguage(context, 2, "ku", _languages[2]),*/
              ],
            ),
          ),
        ),
      );
    });
  }

  _itemLanguage(BuildContext context, int code, String lang, String title) {
    return InkWell(
      onTap: () {
        _selectedLanguage = code;
        mPreference.value.selectedLanguage = lang;
        AppLog.e("SelectedLanguage", lang);
        setState(() {});
        Navigator.pop(context);
        if (_selectedLanguage == 0) {
          _languageCubit.selectEngLanguage();
        } else if (_selectedLanguage == 1) {
          _languageCubit.selectArabicLanguage();
        }/*else if (_selectedLanguage == 2) {
          _languageCubit.selectKurdishLanguage();
        }*/
      },
      child: Container(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kMainColor,
              ),
              child: Center(
                child: Text(
                  "$lang".toUpperCase(),
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "$title",
                style: TextStyle(
                  color: kMainTextColor,
                  fontWeight: RFontWeight.LIGHT,
                  fontSize: 18,
                ),
              ),
            ),
            Visibility(
              visible: _selectedLanguage == code,
              child: Image.asset(
                IC_CHECK,
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  int getCurrentLanguage(Locale locale) {
    if (locale == Locale('en'))
      return 0;
    else if (locale == Locale('ar'))
      return 1;
    else if (locale == Locale('ku'))
      return 2;
    else
      return -1;
  }
}
