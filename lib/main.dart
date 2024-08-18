import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/routes/app_routes.dart';
import 'package:longalottoretail/splash/bloc/splash_bloc.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/shared_pref.dart';
import 'package:longalottoretail/utility/utils.dart';

import 'l10n/l10n.dart';
import 'login/bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  //debugPaintSizeEnabled = true;
  //debugProfileBuildsEnabledUserWidgets = true;
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(),
      ),
      BlocProvider(
        create: (context) => LoginBloc(),
      ),
      BlocProvider(
        create: (context) => SplashBloc(),
      ),
    ],
    child: const LongaLottoRetailApp(),
  ));
}

class LongaLottoRetailApp extends StatefulWidget {
  const LongaLottoRetailApp({Key? key}) : super(key: key);

  static LongaLottoRetailAppState of(BuildContext context) =>
      context.findAncestorStateOfType<LongaLottoRetailAppState>()!;

  @override
  State<LongaLottoRetailApp> createState() => LongaLottoRetailAppState();
}

class LongaLottoRetailAppState extends State<LongaLottoRetailApp> {
  final AppRoute mWlsPosRoute = AppRoute();


  Locale _locale =  Locale(SharedPrefUtils.getLocaleConfig!="" ? SharedPrefUtils.getLocaleConfig :"fr");

  Locale get locale => _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = Locale(SharedPrefUtils.getLocaleConfig);
    });
  }

  Locale getLocale() {
    return _locale;
  }

  @override
  void initState() {
    super.initState();
    initPlatform(); //to initialize device info
  var data =   loadLocalizedData("BONUS_${"12423" ?? ""}", SharedPrefUtils.getLocaleConfig) ?? "errorResponse.errorMessage" ?? "";

  print("asdhbasdashbdhja"+data);
    BlocProvider.of<AuthBloc>(context).add(AppStarted());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        //showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (setting) => mWlsPosRoute.router(setting),
        navigatorKey: navigatorKey);
  }
}
