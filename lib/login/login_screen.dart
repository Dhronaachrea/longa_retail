import 'dart:async';
import 'dart:io';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/splash/widgets/widgets/version_alert.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:longalottoretail/utility/shared_pref.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_text_field_underline.dart';
import 'package:longalottoretail/utility/widgets/shake_animation.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  ShakeController userShakeController = ShakeController();
  ShakeController passShakeController = ShakeController();
  bool obscurePass = true;
  bool isGenerateOtpButtonPressed = false;
  bool isLoggingIn = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  late final abc;

  double mAnimatedButtonSize = 280.0;
  double mAnimatedButtonHeight = 50.0;
  double bannerHeight = 0.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  late FlipCardController _controller;
  bool isEnLang = true;
  FocusNode usernameFocusNode               = FocusNode();
  FocusNode passwordFocusNode               = FocusNode();
  String languageConfig            = "";
  static const Channel = MethodChannel('com.skilrock.longalottoretail/loader_inner_bg');
  PackageInfo? packageInfo;
  bool apkDownloadStart = false;
  bool internetDialogVisible = false;

  BuildContext? loginBlocContext;

  @override
  void initState() {

    _controller               = FlipCardController();
    if (SharedPrefUtils.getLanguageConfig.isNotEmpty) {
      languageConfig = SharedPrefUtils.getLanguageConfig;
    }
    WidgetsBinding.instance.addObserver(this);
    initPlatform();
    BlocProvider.of<LoginBloc>(context).add(VersionControlApi(context: context));
    print("languageConfig.split(""): ${SharedPrefUtils.getLanguageConfig}");
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        print("1111111111111");
        setState(() {
          if (!apkDownloadStart) {
            apkDownloadStart = false;
            Future.delayed(const Duration(milliseconds: 700), () {
              BlocProvider.of<LoginBloc>(context).add(VersionControlApi(context: context));
            });
          }
        });

        print("Resumed");
        break;
      case AppLifecycleState.detached:
        print("Suspending");
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (languageConfig.split(",").length > 1) {
      isEnLang =  LongaLottoRetailApp.of(context).locale.languageCode == 'en' ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          setState(() {
            loginBlocContext = context;
          });
          if (state is LoginTokenLoading) {
            setState(() {
              isLoggingIn = true;
            });
          }
          if (state is LoginTokenSuccess) {
            BlocProvider.of<LoginBloc>(context)
                .add(GetLoginDataApi(context: context));
          }
          else if (state is LoginTokenError) {
            resetLoader();
            setState(() {
              isLoggingIn = false;
            });
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          }
          else if (state is GetLoginDataError) {
            resetLoader();
            setState(() {
              isLoggingIn = false;
            });
            UserInfo.setPlayerToken("");
            UserInfo.setPlayerId("");
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          }
          else if (state is GetLoginDataSuccess) {
           /* LocationData? locationData = await getLocation(context);
            log("locationData: $locationData");
            if(locationData == null){
              resetLoader();
              setState(() {
                isLoggingIn = false;
              });
              UserInfo.setPlayerToken("");
              UserInfo.setPlayerId("");
            } else if (context.mounted){
              log("lattitude : ${locationData.latitude}");
              log("lonngitude : ${locationData.longitude}");
              BlocProvider.of<LoginBloc>(context).add(VerifyPosApi(context: context, latitude: locationData.latitude.toString(),longitude: locationData.longitude.toString() ));

            }*/

          /*  Position? position = await getPosition(context);
            log("position: $position");
            if(position == null){
              resetLoader();
              setState(() {
                isLoggingIn = false;
              });
              UserInfo.setPlayerToken("");
              UserInfo.setPlayerId("");
            } else if (context.mounted ){
              log("lattitude : ${position.latitude}");
              log("lonngitude : ${position.longitude}");
              BlocProvider.of<LoginBloc>(context).add(VerifyPosApi(context: context, latitude: position.latitude.toString(),longitude: position.latitude.toString() ));
            }*/
            Navigator.of(context).pushNamedAndRemoveUntil(
                  LongaLottoPosScreen.homeScreen,
                  (Route<dynamic> route) => false);
          }

          if (state is VersionControlLoading) {
            // myVariable.value = true;
          }
          else if (state is VersionControlSuccess) {
            // myVariable.value = true;
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
                    BlocProvider.of<LoginBloc>(context).add(GetConfigData(context: context));
                  },
                  onUpdate: () async {
                    if (Platform.isAndroid) {
                      setState(() {
                        apkDownloadStart = true;
                        _downloadUpdatedAPK(state.response?.responseData?.data?.downloadUrl ?? "", context);
                      });
                    } else {
                      // download for ios
                    }
                  },
                );
              }

            } else {
              BlocProvider.of<LoginBloc>(context).add(GetConfigData(context: context));
            }

          }
          else if (state is VersionControlError) {
            // myVariable.value = true;
            /*setState(() {
                isLoading = false;
              });*/
            if (!internetDialogVisible) {
              setState(() {
                internetDialogVisible = true;
              });
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
                                                BlocProvider.of<LoginBloc>(context).add(VersionControlApi(context: context));

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
              ).then((value) {
                setState(() {
                  internetDialogVisible = false;
                });
              });
            }
            else {
              Navigator.of(context).pop();
            }

            /*UserInfo.isLoggedIn()
                ? Navigator.pushReplacementNamed(context, LongaLottoPosScreen.homeScreen)
                : Navigator.pushReplacementNamed(context, LongaLottoPosScreen.loginScreen);*/

          }
          else if (state is DefaultConfigLoading) {
            // myVariable.value = true;
            /*setState(() {
                isLoading = true;
              });*/
          }
          else if (state is DefaultConfigSuccess) {
            // myVariable.value = true;
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
                  /*UserInfo.isLoggedIn()
                      ? Navigator.pushReplacementNamed(context, LongaLottoPosScreen.homeScreen)
                      : Navigator.pushReplacementNamed(context, LongaLottoPosScreen.loginScreen);*/

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
            // myVariable.value = true;
            /*setState(() {
                isLoading = false;
              });*/
            //ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
          }

          /*else if (state is VerifyPosSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                LongaLottoPosScreen.homeScreen,
                    (Route<dynamic> route) => false);
          }
          else if (state is VerifyPosError) {
            resetLoader();
            setState(() {
              isLoggingIn = false;
            });
            UserInfo.setPlayerToken("");
            UserInfo.setPlayerId("");
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
          } */
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: const BoxDecoration(
                color: LongaLottoPosColor.white,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/pattern_bg.png"))),
            child: Form(
              key: _loginForm,
              autovalidateMode: autoValidate,
              child: Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: CurveClipper(),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/splash_bg.webp"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: Center(
                                  child: Image.asset(
                                    width: 250,
                                    height: 200,
                                    "assets/images/splash_logo.webp",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Text(
                                  context.l10n.login_title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          _userTextField(),
                          _passTextField(),
                          _submitButton(),
                          _checkNetwork()
                        ],
                      ).pOnly(top: 30, left: 35, right: 35, bottom: 50)
                    ],
                  ),
                ),
                Visibility(
                  visible: languageConfig.isNotEmpty,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FlipCard(
                      controller: _controller,
                      flipOnTouch: false,
                      direction: FlipDirection.VERTICAL,
                      fill: Fill.fillFront,
                      side: CardSide.FRONT,
                      front: InkWell(
                          onTap: () {
                            _controller.toggleCard();
                            /*showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  // <-- SEE HERE
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) {
                                  return LanguageBottomSheet(
                                      lang: lang,
                                      mCallBack: (String selectedLanguage) {
                                        setState(() {
                                          lang = selectedLanguage;
                                        });
                                      });
                                });*/
                          },
                          child: Container(
                            width: 130,
                            height: 27,
                            decoration: BoxDecoration(
                                color: LongaLottoPosColor.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.l10n.select_language,
                                  style: const TextStyle(
                                    color: LongaLottoPosColor.black,
                                    fontSize: 10,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_outlined, size: 16)
                              ],
                            ),
                          ).pOnly(left: 10, right: 10),

                      ),
                      back: InkWell(
                        onTap: () {
                          _controller.toggleCard();
                          /*showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  // <-- SEE HERE
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) {
                                  return LanguageBottomSheet(
                                      lang: lang,
                                      mCallBack: (String selectedLanguage) {
                                        setState(() {
                                          lang = selectedLanguage;
                                        });
                                      });
                                });*/
                        },
                        child: Container(
                          width: 130,
                          height: 27,
                          decoration: BoxDecoration(
                              color: LongaLottoPosColor.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            children: [
                              languageConfig.split(",").isNotEmpty
                                  ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEnLang = true;
                                    });
                                    SharedPrefUtils.setLocaleConfig= languageConfig.split(",")[0];

                                    LongaLottoRetailApp.of(context).setLocale(Locale(languageConfig.split(",")[0], 'IN'));
                                    if(_controller.state?.isFront == false) {
                                      _controller.toggleCard();
                                    }
                                  },
                                  child: Container(
                                    height: 27,
                                    decoration: BoxDecoration(
                                        color: isEnLang ? LongaLottoPosColor.shamrock_green : LongaLottoPosColor.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: languageConfig.split(",").length > 1 ? Radius.circular(0) : Radius.circular(20), topRight: languageConfig.split(",").length > 1 ? Radius.circular(0) : Radius.circular(20))
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageConfig.split(",")[0],
                                        style: TextStyle(
                                            color: isEnLang ? LongaLottoPosColor.white : LongaLottoPosColor.game_color_grey,
                                            fontSize: isEnLang ? 12 : 10,
                                            fontWeight: isEnLang ? FontWeight.bold : null
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),

                              languageConfig.split(",").length > 1
                                  ? Container(
                                width: 0.5,
                                color: LongaLottoPosColor.light_grey,
                              )
                                  : Container(),

                              languageConfig.split(",").length > 1
                                  ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEnLang = false;
                                    });
                                    SharedPrefUtils.setLocaleConfig= languageConfig.split(",")[1];

                                    LongaLottoRetailApp.of(context).setLocale(Locale(languageConfig.split(",")[1]));

                                    if(_controller.state?.isFront == false) {
                                      _controller.toggleCard();
                                    }
                                  },
                                  child: Container(
                                    height: 27,
                                    decoration: BoxDecoration(
                                        color: isEnLang ? LongaLottoPosColor.white : LongaLottoPosColor.shamrock_green,
                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageConfig.split(",")[1],
                                        style: TextStyle(
                                            color: isEnLang ? LongaLottoPosColor.game_color_grey : LongaLottoPosColor.white,
                                            fontSize: isEnLang ? 10 : 12,
                                            fontWeight: isEnLang ? null :FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  : Container()
                            ],
                          ),
                        ).pOnly(left: 10, right: 10),

                      ),
                    ).pOnly(top:50, right:10),
                  ),
                )
              ]),
            ),
          ),
        ));
  }

  Future<void> initPlatform() async {
    packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo: ${packageInfo?.version}");

  }

  _userTextField() {
    return ShakeWidget(
      controller: userShakeController,
      child: LongaLottoPosTextFieldUnderline(
        maxLength: 20,
        inputType: TextInputType.text,
        focusNode: usernameFocusNode,
        hintText: context.l10n.username,
        controller: userController,
        onEditingComplete: () {
          if(userController.text.isNotEmpty && passController.text.isEmpty) {
            passwordFocusNode.requestFocus();
          } else {
            proceedToLogin();
          }
        },
        validator: (value) {
          if (validateInput(TotalTextFields.userName).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              userShakeController.shake();
            }
            return validateInput(TotalTextFields.userName);
          } else {
            return null;
          }
        },
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _passTextField() {
    return ShakeWidget(
      controller: passShakeController,
      child: LongaLottoPosTextFieldUnderline(
        hintText: context.l10n.password,
        controller: passController,
        maxLength: 16,
        focusNode: passwordFocusNode,
        inputType: TextInputType.text,
        obscureText: obscurePass,
        onEditingComplete: () {
          proceedToLogin();
        },
        validator: (value) {
          if (validateInput(TotalTextFields.password).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              passShakeController.shake();
            }
            return validateInput(TotalTextFields.password);
          } else {
            return null;
          }
        },
        suffixIcon: IconButton(
          icon: Icon(
            obscurePass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaLottoPosColor.black_four,
          ),
          onPressed: () {
            setState(() {
              obscurePass = !obscurePass;
            });
          },
        ),
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _submitButton() {
    return AbsorbPointer(
      absorbing: isLoggingIn,
      child: InkWell(
        onTap: () {
          proceedToLogin();
        },
        child: Container(
            decoration: BoxDecoration(
                color: LongaLottoPosColor.app_bg,
                borderRadius: BorderRadius.circular(60)),
            child: AnimatedContainer(
              width: mAnimatedButtonSize,
              height: 50,
              onEnd: () {
                setState(() {
                  if (mButtonShrinkStatus != ButtonShrinkStatus.over) {
                    mButtonShrinkStatus = ButtonShrinkStatus.started;
                  } else {
                    mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                  }
                });
              },
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                  width: mAnimatedButtonSize,
                  height: mAnimatedButtonHeight,
                  child: mButtonShrinkStatus == ButtonShrinkStatus.started
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        color: LongaLottoPosColor.white),
                  )
                      : Center(
                      child: Visibility(
                        visible: mButtonTextVisibility,
                        child: Text(
                          context.l10n.submit_btn,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: LongaLottoPosColor.white,
                          ),
                        ),
                      ))),
            )).pOnly(top: 30),
      ),
    );
  }

  _checkNetwork() {
    return InkWell(
      onTap: () {
        /*final MethodChannel _methodChannel = MethodChannel('com.skilrock.longalottoretail/notification_panel_swipe');
        try {
          _methodChannel.invokeMethod('disableNotificationSwipe');
        } on PlatformException catch (e) {
          // Handle any platform exceptions
          print('Failed to disable notification panel swipe: ${e.message}');
        }*/
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(60)),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Center(
                    child: Text(
                  context.l10n.change_network,
                  style: const TextStyle(
                    fontSize: 14,
                    color: LongaLottoPosColor.black,
                  ),
                )))).pOnly(top: 30),
      ),
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = userController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_your_username;
        }
        break;

      case TotalTextFields.password:
        var passText = passController.text.trim();
        if (passText.isEmpty) {
          return context.l10n.please_enter_your_password;
        } else if (passText.length <= 7) {
          return context.l10n.password_should_be_in_range_min_8;
        }
        break;
    }
    return "";
  }

  resetLoader() {
    mAnimatedButtonSize = 280.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus = ButtonShrinkStatus.over;
  }

  void proceedToLogin() {
    FocusScope.of(context).unfocus();
    setState(() {
      isGenerateOtpButtonPressed = true;
    });
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isGenerateOtpButtonPressed = false;
      });
    });
    if (_loginForm.currentState!.validate()) {
      var userName = userController.text.trim();
      var password = passController.text.trim();

      setState(() {
        mAnimatedButtonSize = 50.0;
        mButtonTextVisibility = false;
        mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
      });
      BlocProvider.of<LoginBloc>(context).add(LoginTokenApi(
          context: context, userName: userName, password: password));
    }
    else {
      setState(() {
        autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
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

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 70;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
