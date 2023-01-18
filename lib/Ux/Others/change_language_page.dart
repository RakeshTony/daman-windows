import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daman/Locale/language_cubit.dart';
import 'package:daman/Locale/locales.dart';

class ChangeLanguagePage extends StatefulWidget {
  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late LanguageCubit _languageCubit;
  int? _selectedLanguage = -1;

  @override
  void initState() {
    super.initState();
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    final List<String> _languages = [
      'English',
      'عربى',
    ];

    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        _selectedLanguage = getCurrentLanguage(locale);
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: mediaQuery.size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '\n' +
                                AppLocalizations.of(context)!.changeLanguage!,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                          child: Container(
                            height: mediaQuery.size.height * 0.77,
                            decoration: BoxDecoration(
                              color: theme.backgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35.0),
                                topRight: Radius.circular(35.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: ListView.builder(
                              itemCount: _languages.length,
                              itemBuilder: (context, index) => RadioListTile(
                                activeColor: theme.primaryColor,
                                groupValue: _selectedLanguage,
                                value: index,
                                title: Text(_languages[index]),
                                onChanged: (dynamic value) async {
                                  setState(() {
                                    _selectedLanguage = value;
                                    /*Navigator.pushNamed(
                                        context, PageRoutes.signInNavigator);*/
                                  });
                                  if (_selectedLanguage == 0) {
                                    _languageCubit.selectEngLanguage();
                                  } else if (_selectedLanguage == 1) {
                                    _languageCubit.selectArabicLanguage();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int getCurrentLanguage(Locale locale) {
    if (locale == Locale('en'))
      return 0;
    else if (locale == Locale('ar'))
      return 1;
    else
      return -1;
  }
}
