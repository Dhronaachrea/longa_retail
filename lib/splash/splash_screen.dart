import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/home/bloc/home_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/splash/bloc/splash_bloc.dart';
import 'package:longalottoretail/splash/bloc/splash_state.dart';
import 'package:longalottoretail/splash/widgets/widgets/version_alert.dart';
import 'package:longalottoretail/utility/FadeRoute.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_scaffold.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/shared_pref.dart';
import '../utility/user_info.dart';
import 'bloc/splash_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin {
  static const Channel = MethodChannel('com.skilrock.longalottoretail/loader_inner_bg');
  PackageInfo? packageInfo;
  late final AnimationController  _blinker1AnimationController;
  late final Animation<double>    _blinker1Animation;

  late final AnimationController  _blinker2AnimationController;
  late final Animation<double>    _blinker2Animation;

  late final AnimationController  _blinker3AnimationController;
  late final Animation<double>    _blinker3Animation;

  late final AnimationController  _blinker4AnimationController;
  late final Animation<double>    _blinker4Animation;

  late final AnimationController  _blinker5AnimationController;
  late final Animation<double>    _blinker5Animation;

  ValueNotifier<bool> myVariable = ValueNotifier<bool>(false);

  bool isLoading = false;
  BuildContext? splashBlocContext;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _blinker1AnimationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _blinker1Animation = Tween<double>(begin: 1, end: 0)
        .animate(_blinker1AnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _blinker1AnimationController.reset();
          // print("AnimationStatus.completed");
        } else if (status == AnimationStatus.dismissed) {
          _blinker2AnimationController.forward();
          // print("AnimationStatus.dismissed BLINKER 1");
        }
      });

    _blinker2AnimationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _blinker2Animation = Tween<double>(begin: 1, end: 0)
        .animate(_blinker2AnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _blinker2AnimationController.reset();
          // print("AnimationStatus.completed");
        } else if (status == AnimationStatus.dismissed) {
          _blinker3AnimationController.forward();
          // print("AnimationStatus.dismissed  BLINKER 2");
        }
      });

    _blinker3AnimationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _blinker3Animation = Tween<double>(begin: 1, end: 0)
        .animate(_blinker3AnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _blinker3AnimationController.reset();
          // print("AnimationStatus.completed");
        } else if (status == AnimationStatus.dismissed) {
          _blinker4AnimationController.forward();
          // print("AnimationStatus.dismissed  BLINKER 3");
        }
      });

    _blinker4AnimationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _blinker4Animation = Tween<double>(begin: 1, end: 0)
        .animate(_blinker4AnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _blinker4AnimationController.reset();
          // print("AnimationStatus.completed");
        } else if (status == AnimationStatus.dismissed) {
          _blinker5AnimationController.forward();
          // print("AnimationStatus.dismissed  BLINKER 4");
        }
      });

    _blinker5AnimationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _blinker5Animation = Tween<double>(begin: 1, end: 0)
        .animate(_blinker5AnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _blinker5AnimationController.reset();
          // print("AnimationStatus.completed");
        } else if (status == AnimationStatus.dismissed) {
          _blinker1AnimationController.forward();
          // print("AnimationStatus.dismissed  BLINKER 5");
        }
      });


    Future.delayed(const Duration(seconds: 1), () {
      _blinker1AnimationController.forward();
    });

    // BlocProvider.of<SplashBloc>(context).add(VersionControlApi(context: context));
      BlocProvider.of<SplashBloc>(context).add(GetConfigData(context: context));

  }


  Future<void> initPlatform() async {
    packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo: ${packageInfo?.version}");

  }

  @override
  Widget build(BuildContext context) {

    return LongaLottoPosScaffold(
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            setState(() {
              splashBlocContext = context;
            });
            if (state is VersionControlLoading) {
              myVariable.value = true;
            }
            else if (state is VersionControlSuccess) {
              myVariable.value = true;
              /*setState(() {
                isLoading = false;
              });*/
              final upcomingVersion = int.parse(state.response?.responseData?.data?.version?.replaceAll(".", "") ?? "0");
              final currentVersion = int.parse(packageInfo?.version.replaceAll(".", "") ?? "0");
              if (upcomingVersion > currentVersion) {
                String message = "Version ${state.response?.responseData?.data?.version} is available.";
                if (state.response?.responseData?.data?.downloadUrl?.isNotEmpty == true) {
                  VersionAlert.show(
                    context: context,
                    type: state.response?.responseData?.data?.isMandatory == "YES" ? VersionAlertType.mandatory : VersionAlertType.optional,
                    message: message,
                    onCancel: () {
                      BlocProvider.of<SplashBloc>(context).add(GetConfigData(context: context));
                    },
                    onUpdate: () async {
                      if (Platform.isAndroid) {
                        _downloadUpdatedAPK(state.response?.responseData?.data?.downloadUrl ?? "", context);
                      } else {
                        // download for ios
                      }
                    },
                  );
                }

              } else {
                BlocProvider.of<SplashBloc>(context).add(GetConfigData(context: context));
              }

            }
            else if (state is VersionControlError) {
              myVariable.value = true;
              /*setState(() {
                isLoading = false;
              });*/
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: StatefulBuilder(
                      builder: (context, StateSetter setInnerState) {
                        return Dialog(
                            insetPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 18.0),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: LongaLottoPosColor.white,
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const HeightBox(10),
                                          Image.asset("assets/images/logo.webp", width: 150, height: 100),
                                          const HeightBox(4),
                                          Text(
                                            state.errorMsg,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: LongaLottoPosColor.black,
                                            ),
                                          ),
                                          const HeightBox(30),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              BlocProvider.of<SplashBloc>(splashBlocContext!).add(VersionControlApi(context: splashBlocContext!));
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: LongaLottoPosColor.game_color_orange,
                                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                              ),
                                              height: 45,
                                              child: Center(child: Text(context.l10n.retry, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 14))),
                                            ),
                                          ),
                                          const HeightBox(20),

                                        ],
                                      ).pSymmetric(v: 10, h: 30),
                                    ).p(4)
                                  ]
                              ),
                            )
                        );
                      },
                    ),
                  );
                },
              );
         /*     UserInfo.isLoggedIn()
                  ? Navigator.pushReplacementNamed(context, LongaLottoPosScreen.homeScreen)
                  : Navigator.pushReplacementNamed(context, LongaLottoPosScreen.loginScreen);
*/
            }
            else if (state is DefaultConfigLoading) {
              myVariable.value = true;
              /*setState(() {
                isLoading = true;
              });*/
            }
            else if (state is DefaultConfigSuccess) {
              myVariable.value = true;
              /*setState(() {
                isLoading = false;
              });*/
              if(state.response.responseData?.statusCode == 0) {

                if (state.response.responseData?.data != null) {

                  if(state.response.responseData?.data?.sYSTEMALLOWEDLANGUAGES?.isNotEmptyAndNotNull == true) {
                    SharedPrefUtils.setLanguageConfig = state.response.responseData?.data?.sYSTEMALLOWEDLANGUAGES ?? "";
                    int len = state.response.responseData?.data?.sYSTEMALLOWEDLANGUAGES?.split(",").length ?? 0;
                    if (len > 1) {
                      SharedPrefUtils.setLocaleConfig= SharedPrefUtils.getLocaleConfig!=""? SharedPrefUtils.getLocaleConfig :"fr";
                      LongaLottoRetailApp.of(context).setLocale(const Locale('fr', 'FR'));
                    } else {
                      SharedPrefUtils.setLocaleConfig= SharedPrefUtils.getLocaleConfig!=""? SharedPrefUtils.getLocaleConfig :"en";
                      LongaLottoRetailApp.of(context).setLocale(const Locale('en', 'IN'));
                    }
                    UserInfo.isLoggedIn()
                        ? Navigator.pushReplacementNamed(context, LongaLottoPosScreen.homeScreen)
                        : Navigator.pushReplacementNamed(context, LongaLottoPosScreen.loginScreen);

                  } else {
                    ShowToast.showToast(context, "SYSTEM_ALLOWED_LANGUAGES tag might be null/empty : ${state.response.responseData?.data?.sYSTEMALLOWEDLANGUAGES}");
                  }

                } else {
                  ShowToast.showToast(context, "data might be null/empty : ${state.response.responseData?.data}");
                }

              } else {
                ShowToast.showToast(context, "Something went wrong with statusCode: ${state.response.responseData?.statusCode}");
              }
            }
            else if (state is DefaultConfigError) {
              myVariable.value = true;
              /*setState(() {
                isLoading = false;
              });*/
              //ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
            }
          },
          child:  FutureBuilder<void>(
            future: initPlatform(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: LongaLottoPosColor.neon_yellow,
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/splash_bg.webp"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Image.asset(
                                      "assets/images/splash.png",
                                    ),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: myVariable,
                                    builder: (context, value, child) {
                                      return Visibility(
                                        visible: value,
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                  children: [
                                                    Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(color: LongaLottoPosColor.lightMarigold, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                    ).p(8),
                                                    FadeTransition(
                                                      opacity: _blinker1Animation,
                                                      child: Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(color: LongaLottoPosColor.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)]),
                                                      ).p(8),
                                                    ),
                                                  ]
                                              ),
                                              Stack(
                                                  children: [
                                                    Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(color: LongaLottoPosColor.lightMarigold, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                    ).p(8),
                                                    FadeTransition(
                                                      opacity: _blinker2Animation,
                                                      child: Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(color: LongaLottoPosColor.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                      ).p(8),
                                                    ),
                                                  ]
                                              ),
                                              Stack(
                                                  children: [
                                                    Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(color: LongaLottoPosColor.lightMarigold, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                    ).p(8),
                                                    FadeTransition(
                                                      opacity: _blinker3Animation,
                                                      child: Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(color: LongaLottoPosColor.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                      ).p(8),
                                                    ),

                                                  ]
                                              ),
                                              Stack(
                                                  children: [
                                                    Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(color: LongaLottoPosColor.lightMarigold, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                    ).p(8),
                                                    FadeTransition(
                                                      opacity: _blinker4Animation,
                                                      child: Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(color: LongaLottoPosColor.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                      ).p(8),
                                                    ),
                                                  ]
                                              ),
                                              Stack(
                                                  children: [
                                                    Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(color: LongaLottoPosColor.lightMarigold, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                    ).p(8),
                                                    FadeTransition(
                                                      opacity: _blinker5Animation,
                                                      child: Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(color: LongaLottoPosColor.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.tangerine, width: 2), boxShadow: [BoxShadow(color: LongaLottoPosColor.yellow_orange_three, blurRadius: 10.0)])
                                                      ).p(8),
                                                    ),
                                                  ]
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    );
                  }
                case ConnectionState.none:
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: LongaLottoPosColor.neon_yellow,
                  );
                case ConnectionState.active:
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: LongaLottoPosColor.neon_yellow,
                  );
              }

              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/splash_bg.webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Center(
                      child: Image.asset(
                        "assets/images/splash.png"
                      ),
                    ),
                  )
              );
            },
          )
        )
    );
  }

  @override
  void dispose() {
    _blinker1AnimationController.dispose();
    _blinker2AnimationController.dispose();
    _blinker3AnimationController.dispose();
    _blinker4AnimationController.dispose();
    _blinker5AnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<void> _downloadUpdatedAPK(String url, BuildContext context) async{
    try {
      Map<String, String> arg = {
        "url"  : url,
      };

      final dynamic receivedResponse = await Channel.invokeMethod('_downloadUpdatedAPK', arg);
      print("receivedResponse --> $receivedResponse");
    } on PlatformException catch (e)  {
      //Navigator.of(context).pop();
      ShowToast.showToast(context, "${e.message}", type: ToastType.ERROR);
      print("-------- $e");
    }
  }
}
