import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/bloc/home_state.dart';
import 'package:longalottoretail/home/models/homeDataListBean.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/splash/widgets/widgets/version_alert.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../login/models/response/GetLoginDataResponse.dart';
import '../utility/shared_pref.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart' as homeEvent;
import 'models/response/UserMenuApiResponse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  bool _mIsDrawerVisible = false;
  bool _mAppBarBalanceChipVisible = false;
  List<List<ModuleBeanLst>?> homeModuleList = [];
  List<HomeDataListBean> homeDataModuleList   = [];
  List<List<ModuleBeanLst>?> drawerModuleList = [];
  List<MenuBeanList>? scratchMenuBeanList;
  bool internetDialogVisible = false;
  bool apkDownloadStart = false;

  static const Channel = MethodChannel('com.skilrock.longalottoretail/loader_inner_bg');
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //checkSessionWasExpired(context);
    });
    WidgetsBinding.instance.addObserver(this);
    initPlatform();
    BlocProvider.of<LoginBloc>(context).add(VersionControlApi(context: context));
    // BlocProvider.of<HomeBloc>(context).add(GetConfigData(context: context));
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
        print("222222222");
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
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
              BlocProvider.of<HomeBloc>(context).add(homeEvent.GetConfigData(context: context));
            }

          }
          else if (state is VersionControlError) {
            // myVariable.value = true;
            /*setState(() {
                isLoading = false;
              });*/



            if(!internetDialogVisible) {
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
        },
        child: LongaScaffold(
          showAppBar: true,
          showDrawerIcon: _mIsDrawerVisible,
          mAppBarBalanceChipVisible: _mAppBarBalanceChipVisible,
          extendBodyBehindAppBar: true,
          drawerEnableOpenDragGesture: _mIsDrawerVisible,
          drawer: LongaLottoPosDrawer(drawerModuleList: drawerModuleList),
          body: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              color: LongaLottoPosColor.app_blue,
              displacement: 60,
              edgeOffset: 1,
              strokeWidth: 2,
              onRefresh: () {
                setState(() {
                  apkDownloadStart = false;
                  _mIsDrawerVisible = false;
                  homeDataModuleList.clear();
                  homeModuleList.clear();
                  drawerModuleList.clear();
                });
                return Future.delayed(
                  const Duration(seconds: 1),
                      () {
                        BlocProvider.of<LoginBloc>(context).add(VersionControlApi(context: context));
                    BlocProvider.of<HomeBloc>(context)
                        .add(homeEvent.GetUserMenuListApiData(context: context));
                  },
                );
              },
              child: ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return BlocListener<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state is UserMenuListLoading) {
                          setState(() {
                            homeDataModuleList.clear();
                            _mIsDrawerVisible = false;
                          });
                        }
                        else if (state is UserMenuListSuccess) {
                          setState(() {
                            homeDataModuleList.clear();
                            // homeDataModuleList.add(HomeDataListBean(image: "assets/icons/DRAW_GAME.png", title: context.l10n.lottery_title, description: "${gamesCode.length} ${context.l10n.games_title}"));
                            // homeDataModuleList.add(HomeDataListBean(image: "assets/icons/qr_code_scan.png", title: context.l10n.scanNPlay_title, description: context.l10n.scanNPlay_subtitle));

                            for (var moduleCodeVar in homeModuleCodesList) {
                              if (state.response.responseData?.moduleBeanLst?.where(
                                      (element) =>
                                  (element.moduleCode == moduleCodeVar)) !=
                                  null) {
                                if (state.response.responseData?.moduleBeanLst
                                    ?.where((element) =>
                                (element.moduleCode == moduleCodeVar))
                                    .toList()
                                    .isNotEmpty ==
                                    true) {
                                  if(moduleCodeVar == lotteryModuleCode) {
                                    homeDataModuleList.add(HomeDataListBean(image: "assets/icons/DRAW_GAME.png", title: context.l10n.lottery_title, description: "${gamesCode.length} ${context.l10n.games_title}"));
                                  } else if (moduleCodeVar == scratchModuleCode){
                                    scratchMenuBeanList = state.response.responseData?.moduleBeanLst
                                        ?.where((element) =>
                                    (element.moduleCode == moduleCodeVar))
                                        .toList()[0].menuBeanList;
                                    homeDataModuleList.add(HomeDataListBean(image: "assets/icons/SCRATCH.png", title: context.l10n.scratch, description: ""));
                                  }

                                }
                              }
                            }

                            GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
                            if (loginResponse.responseData?.data?.isScanNPlay == "YES") {
                              homeDataModuleList.add(HomeDataListBean(image: "assets/icons/qr_code_scan.png", title: context.l10n.scanNPlay_title, description: context.l10n.scanNPlay_subtitle));

                            }


                            // ModuleBeanLst? drawGameBeanList = (state
                            //     .response.responseData?.moduleBeanLst
                            //     ?.where((element) =>
                            // (element.moduleCode == lotteryModuleCode))
                            //     .toList( ))?[0];
                            // UserInfo.setDrawGameBeanListData(
                            //     jsonEncode(drawGameBeanList));
                            for (var moduleCodeVar in drawerModuleCodesList) {
                              if (state.response.responseData?.moduleBeanLst?.where(
                                      (element) =>
                                  (element.moduleCode == moduleCodeVar)) !=
                                  null) {
                                drawerModuleList.add(state
                                    .response.responseData?.moduleBeanLst
                                    ?.where((element) =>
                                (element.moduleCode == moduleCodeVar)==true)
                                    .toList());
                              }
                            }

                          List<ModuleBeanLst> list=[];
                          List<MenuBeanList> list1=[];
                          list1.add(MenuBeanList(menuCode: "M_CHANGE_NETWORk",menuId: 111,caption: context.l10n.change_network));
                          list.add(ModuleBeanLst(moduleId:1,moduleCode:"M_CHANGE_NETWORk",sequence:1,displayName: "Network",menuBeanList: list1));
                          drawerModuleList.add(list);
                          //To remove empty list [] from drawerModuleList
                          drawerModuleList = drawerModuleList.where((sublist) => sublist?.isNotEmpty ?? false).toList();

                          if (drawerModuleList.isNotEmpty) {
                            _mIsDrawerVisible = true;
                          } else {
                            _mIsDrawerVisible = false;
                          }
                        });
                      }
                      else if (state is UserMenuListError) {
                        setState(() {
                          _mIsDrawerVisible = false;
                        });
                        ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
                      }
                      else if (state is UserConfigSuccess) {
                        if (state.response.responseData?.data?[0].cURRENCYLIST !=
                            null) {
                          SharedPrefUtils.setCurrencyListConfig =
                              state.response.responseData?.data?[0].cURRENCYLIST! ?? "";

                          }
                          SharedPrefUtils.setCreditLimitConfig = state.response.responseData?.data?[0].cREDITLIMITDISPLAYONAPP ?? "";
                          SharedPrefUtils.setAliasName =
                              state.response.responseData?.data?[0].SCAN_N_PLAY_ALIAS_NAME ?? "";
                          BlocProvider.of<AuthBloc>(context).add(AppStarted());
                          setState(() {
                            _mAppBarBalanceChipVisible = true;
                          });
                          if(state.response.responseData?.statusCode == 0) {
                            BlocProvider.of<HomeBloc>(context).add(homeEvent.GetUserMenuListApiData(context: context));
                          }
                        }
                        else if (state is UserConfigError) {
                          ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);

                        }
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset("assets/images/bg_banner.png"),
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _mIsDrawerVisible ? homeDataModuleList.length : 2,
                                itemBuilder: (BuildContext context, int index) {
                                  return _mIsDrawerVisible
                                      ? Ink(
                                    decoration: const BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: LongaLottoPosColor.warm_grey_six,
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (homeDataModuleList[index].title == context.l10n.scanNPlay_title) {

                                          Navigator.pushNamed(context, LongaLottoPosScreen.scanAndPlayScreen);
                                        } else if(homeDataModuleList[index].title == context.l10n.scratch){
                                          Navigator.pushNamed(context, LongaLottoPosScreen.scratchScreen, arguments: scratchMenuBeanList);
                                        } else if(homeDataModuleList[index].title == context.l10n.lottery_title) {
                                          Navigator.pushNamed(context,
                                              LongaLottoPosScreen.lotteryScreen);

                                        }
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Ink(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.4,
                                                  height: 90,
                                                  homeDataModuleList[index].image ?? "assets/images/splash_logo.webp"),
                                            ),
                                            Container(
                                              width: 2,
                                              color: LongaLottoPosColor.black,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    homeDataModuleList[index].title ?? "NA",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: LongaLottoPosColor
                                                            .black,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                                Text(homeDataModuleList[index].description ?? "",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontStyle: FontStyle.italic)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).p(6)
                                      : Shimmer.fromColors(
                                    baseColor: Colors.grey[400]!,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: LongaLottoPosColor.warm_grey,
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        child: Row(children: [
                                          Container(
                                            width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[400]!,
                                                borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(10),
                                                )),
                                          ).pOnly(top: 10, bottom: 10, left: 10),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400]!,
                                                ),
                                              ).p(10),
                                              Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400]!,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])).p(6),
                                  );
                                }).p(10)
                          ],
                        ),
                      ),
                    );
                  })
          ),
        ),
      ),
    );
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


  Future<void> initPlatform() async {
    packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo: ${packageInfo?.version}");

  }
/*void checkSessionWasExpired(BuildContext context) {
    print("UserInfo.getSelectedPanelData: ${UserInfo.getSelectedPanelData}");
    if (UserInfo.getSelectedPanelData.isNotEmpty && UserInfo.getSelectedGameObject.isNotEmpty) {
      SavedPanelDataConfirmationDialog().show(context: context, title: "Your picked data are waiting !", subTitle: "You may not purchase those picked data, It's time to purchase it", buttonText: "Preview", isCloseButton: true, buttonClick: (bool isPreviewSelected) {
        if (isPreviewSelected) {
          var jsonPanelData = jsonDecode(UserInfo.getSelectedPanelData) as Map<String, dynamic>;
          print("jsonPanelData: $jsonPanelData");
          List<PanelBean> panelData = createPanelData(jsonPanelData["panelData"]);
          GameRespVOs gameRespObject = GameRespVOs.fromJson(jsonDecode(UserInfo.getSelectedGameObject));
          Navigator.push(context,
              MaterialPageRoute(
                builder: (_) =>  MultiBlocProvider(
                    providers: [
                      BlocProvider<LotteryBloc>(
                        create: (BuildContext context) => LotteryBloc(),
                      )
                    ],
                    child: PreviewGameScreen(gameSelectedDetails: panelData, gameObjectsList: gameRespObject, onComingToPreviousScreen: (String onComingToPreviousScreen) {
                      switch(onComingToPreviousScreen) {
                        case "isAllPreviewDataDeleted" : {
                          break;
                        }

                        case "isBuyPerformed" : {
                          SharedPrefUtils.removeValue(PrefType.appPref.value);
                          break;
                        }
                      }
                    }, selectedGamesData: (List<PanelBean> selectedAllGameData) {

                    })),
                //child: LotteryScreen()),
              )
          );
        } else {
          SharedPrefUtils.removeValue(PrefType.appPref.value);
        }
      });
    }

  }*/

/*List<PanelBean> createPanelData(List<dynamic> panelSavedDataList) {
    List<PanelBean> savedPanelBeanList = [];
    for (int i=0; i< panelSavedDataList.length; i++) {
      PanelBean model = PanelBean();

      model.gameName                          = panelSavedDataList[i]["gameName"];
      model.amount                            = panelSavedDataList[i]["amount"];
      model.winMode                           = panelSavedDataList[i]["winMode"];
      model.betName                           = panelSavedDataList[i]["betName"];
      model.pickName                          = panelSavedDataList[i]["pickName"];
      model.betCode                           = panelSavedDataList[i]["betCode"];
      model.pickCode                          = panelSavedDataList[i]["pickCode"];
      model.pickConfig                        = panelSavedDataList[i]["PickConfig"];
      model.isPowerBallPlus                   = panelSavedDataList[i]["isPowerBallPlus"];
      model.selectBetAmount                   = panelSavedDataList[i]["selectBetAmount"];
      model.unitPrice                         = panelSavedDataList[i]["unitPrice"];
      model.numberOfDraws                     = panelSavedDataList[i]["numberOfDraws"];
      model.numberOfLines                     = panelSavedDataList[i]["numberOfLines"];
      model.isMainBet                         = panelSavedDataList[i]["isMainBet"];
      model.betAmountMultiple                 = panelSavedDataList[i]["betAmountMultiple"];
      model.isQuickPick                       = panelSavedDataList[i]["isQuickPick"];
      model.isQpPreGenerated                  = panelSavedDataList[i]["isQpPreGenerated"];

      List<Map<String, List<String>>> listOfSelectedNumber = [];
      if (panelSavedDataList[i]["listSelectedNumber"] != null) {
        Map<String, dynamic> mapOfSelectedNumbers = panelSavedDataList[i]["listSelectedNumber"][0]; // For Eg. {0: [40, 29, 26, 03, 31], 1: [03]}
        Map<String, List<String>> selectedNumbers = {};
        for(var i=0;i<mapOfSelectedNumbers.length; i++) {
          List<String> numberList = List<String>.from(mapOfSelectedNumbers.values.toList()[i] as List);
          selectedNumbers[mapOfSelectedNumbers.keys.toList()[i]] = numberList;
        }

        listOfSelectedNumber.add(selectedNumbers);
        print("listOfSelectedNumber --> $listOfSelectedNumber");
      }

      List<Map<String, List<BankerBean>>> listSelectedNumberUpperLowerLine = [];
      if (panelSavedDataList[i]["listSelectedNumberUpperLowerLine"] != null) {
        Map<String, dynamic> mapOfBankerSelectedNumbers = panelSavedDataList[i]["listSelectedNumberUpperLowerLine"][0]; // For Eg. {0: [40, 29, 26, 03, 31], 1: [03]}
        Map<String, List<BankerBean>> bankersSelectedNumber = {};
        for(var i=0;i<mapOfBankerSelectedNumbers.length; i++) {
          List<BankerBean> bankerBeanList = [];
          for (var bankerDetails in mapOfBankerSelectedNumbers.values.toList()[i]) {
            bankerBeanList.add(BankerBean(number: bankerDetails["number"], color: bankerDetails["number"], index: int.parse(bankerDetails["number"]), isSelectedInUpperLine: bankerDetails["isSelected"]));
          }
          bankersSelectedNumber[mapOfBankerSelectedNumbers.keys.toList()[i]] = bankerBeanList;
        }

        listSelectedNumberUpperLowerLine.add(bankersSelectedNumber);
        print("listSelectedNumberUpperLowerLine |>--> $listSelectedNumberUpperLowerLine");
      }

      model.listSelectedNumber                = listOfSelectedNumber.isEmpty ? null : listOfSelectedNumber;
      model.listSelectedNumberUpperLowerLine  = listSelectedNumberUpperLowerLine.isEmpty ? null : listSelectedNumberUpperLowerLine;
      model.pickedValue                       = panelSavedDataList[i]["pickedValue"];
      model.colorCode                         = panelSavedDataList[i]["colorCode"];
      model.totalNumber                       = panelSavedDataList[i]["totalNumber"];
      model.sideBetHeader                     = panelSavedDataList[i]["sideBetHeader"];

      savedPanelBeanList.add(model);
    }
    print("---------> all panelSavedData: $savedPanelBeanList");
    print("---------> all panelSavedData: json --> ${jsonEncode(savedPanelBeanList)}");

    return savedPanelBeanList;
  }*/

}
