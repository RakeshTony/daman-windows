import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:daman/Database/hive_database.dart';
import 'package:daman/Locale/language_cubit.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/style.dart';
import 'package:daman/Utils/preferences_handler.dart';
import 'package:desktop_window/desktop_window.dart';

ValueNotifier<PreferencesHandler> mPreference =
    ValueNotifier(PreferencesHandler());

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  mPreference.value = await PreferencesHandler.init();
  await HiveDatabase.init();
  if (Platform.isWindows) {
/*
    await DesktopWindow.setMinWindowSize(Size(512, 384));
    await DesktopWindow.setMaxWindowSize(Size(1024, 768));
*/
  }
  runApp(
    Phoenix(
      child: BlocProvider<LanguageCubit>(
        create: (context) => LanguageCubit(mPreference.value.selectedLanguage),
        child: MyApp(), // todo try this MaterialApp(home: MyApp()),
      ),
    ),
  );
  EasyLoading.init();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //AppLog.e("MainSelectedLanguage:- ", mPreference.value.selectedLanguage);
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizationsDelegate.delegate,
        ],
        supportedLocales: [
          const Locale("en"),
          const Locale("ar"),
        ],
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        locale: locale,
        initialRoute: PageRoutes.splash,
        onGenerateRoute: PageRoutes.generateRoute,
        // routes: PageRoutes().routes(),
      ),
    );
  }
}
