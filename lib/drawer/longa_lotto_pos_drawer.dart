import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:longalottoretail/utility/shared_pref.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';

class LongaLottoPosDrawer extends StatefulWidget {
  List<List<ModuleBeanLst>?> drawerModuleList;

  LongaLottoPosDrawer({Key? key, required this.drawerModuleList})
      : super(key: key);

  @override
  State<LongaLottoPosDrawer> createState() => _LongaLottoPosDrawerState();
}

class _LongaLottoPosDrawerState extends State<LongaLottoPosDrawer> with TickerProviderStateMixin {
  late final AnimationController  _refreshBtnAnimationController;
  late final AnimationController  _refreshTextAnimationController;
  late final Animation<double>    refreshBtnAnimation;
  late final Animation<double>    refreshTextAnimation;
  BuildContext? dialogContext;
  bool isBalanceRefreshing = false;
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    _refreshBtnAnimationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    refreshBtnAnimation = Tween<double>(begin: 2, end: 1)
        .animate(_refreshBtnAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _refreshBtnAnimationController.reset();
        } else if (status == AnimationStatus.dismissed) {
          _refreshBtnAnimationController.forward();
        }
      });

    _refreshTextAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    refreshTextAnimation = Tween<double>(begin: 2, end: 1)
        .animate(_refreshTextAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("_refreshTextAnimationController");
        }
      });

  }

  Future<void> initPlatform() async {
    packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo: version: ${packageInfo?.version}");

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return !isBalanceRefreshing;
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (
            context, state) {
          if (state is GetLoginDataSuccess) {
            if (state.response != null) {
              //var dummyResponse = """{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"lastName":"williams","userStatus":"ACTIVE","walletType":"PREPAID","mobileNumber":"8505957513","isHead":"YES","orgId":2,"accessSelfDomainOnly":"YES","balance":"70,00 ","qrCode":null,"orgCode":"ORGRET101test1111231","parentAgtOrgId":0,"parentMagtOrgId":0,"creditLimit":"0,00 ","userBalance":"-266 000,00 ","distributableLimit":"0,00 ","orgTypeCode":"RET","mobileCode":"+91","orgName":"ret_test_1011111231","userId":672,"isAffiliate":"NO","domainId":1,"walletMode":"COMMISSION","orgStatus":"ACTIVE","firstName":"ret","regionBinding":"REGION","rawUserBalance":-266000.0,"parentSagtOrgId":0,"username":"monuret"}}}""";
              //BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(loginDataResponse: GetLoginDataResponse.fromJson(jsonDecode(dummyResponse))));
              _refreshTextAnimationController.forward();
              print("UPDATED SUCCESSFULLY");
              BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(loginDataResponse: state.response!));
            }
          }
        },
        child: AbsorbPointer(
          absorbing: isBalanceRefreshing,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UserInfoUpdated) {
                setState(() {
                  isBalanceRefreshing = false;
                });
                _refreshBtnAnimationController.stop();
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return FutureBuilder<void>(
              future: initPlatform(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    break;
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    return SafeArea(
                      bottom: false,
                      left: false,
                      right: false,
                      child: Drawer(
                        width: context.screenWidth * 0.8,
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.screenHeight * 0.2,
                              child: Stack(children: [
                                Container(
                                  width: context.screenWidth * 0.8,
                                  color: LongaLottoPosColor.light_golden_rod,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/icons/icon_drawer_user.png",
                                            width: 70, height: 70),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: ((context.screenWidth * 0.8) - 120),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${UserInfo.userName} (${UserInfo.userId})",
                                                  style: const TextStyle(
                                                    color: LongaLottoPosColor.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  "${context.l10n.organisation} : ${UserInfo.organisation}",
                                                  style: const TextStyle(
                                                    color: LongaLottoPosColor.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                SharedPrefUtils.getCreditLimitConfig == "YES"
                                                    ? Text("${context.l10n.limit} : ${GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo)).responseData?.data?.creditLimit}",
                                                        style: const TextStyle(
                                                          color: LongaLottoPosColor.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        maxLines: 2,
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(0, 1.85),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.09,
                                    child: Card(
                                      elevation: 12,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                          context.l10n.wallet_balance,
                                                          style: const TextStyle(
                                                              color: LongaLottoPosColor.game_color_grey,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w500
                                                          )
                                                      ),
                                                      const HeightBox(2),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                                        textBaseline: TextBaseline.ideographic,
                                                        children: [
                                                          Text(
                                                              UserInfo.totalBalance.replaceAll('.', ","),
                                                              style: const TextStyle(
                                                                  color: LongaLottoPosColor.game_color_blue,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700
                                                              )
                                                          ),
                                                          WidthBox(2),
                                                          Text(
                                                              getDefaultCurrency(getLanguage()),
                                                              style: const TextStyle(
                                                                  color: LongaLottoPosColor.game_color_blue,
                                                                  fontSize: 8,
                                                                  fontWeight: FontWeight.w700
                                                              )
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )

                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print("---------------------");
                                                _refreshBtnAnimationController
                                                    .forward();
                                                showDialog(context);
                                                setState(() {
                                                  isBalanceRefreshing = true;
                                                });
                                                BlocProvider.of<LoginBloc>(context)
                                                    .add(GetLoginDataApi(
                                                    context: context));
                                              },
                                              customBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                              ),
                                              child: Ink(
                                                child: RotationTransition(
                                                    turns: refreshBtnAnimation,
                                                    child: const Icon(Icons.loop, color: LongaLottoPosColor.tangerine, size: 30)
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          context.l10n.accured_commission,
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: LongaLottoPosColor.game_color_grey,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w500
                                                          )
                                                      ),
                                                      const HeightBox(2),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                                        textBaseline: TextBaseline.ideographic,
                                                        children: [
                                                          Text(
                                                            //"${UserInfo.totalBalance} ${getDefaultCurrency(getLanguage())}",
                                                              UserInfo.displayCommission.replaceAll('.', ","),
                                                              style: const TextStyle(
                                                                  color: LongaLottoPosColor.game_color_blue,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700
                                                              )
                                                          ),
                                                          const WidthBox(2),
                                                          Text(
                                                              getDefaultCurrency(getLanguage()),
                                                              style: const TextStyle(
                                                                  color: LongaLottoPosColor.game_color_blue,
                                                                  fontSize: 8,
                                                                  fontWeight: FontWeight.w700
                                                              )
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )

                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 40),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 0, bottom: 0),
                                child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.drawerModuleList[index]?[0]
                                                .displayName !=
                                                null
                                                ? widget.drawerModuleList[index]![0]
                                                .displayName!
                                                .toString()
                                                : "",
                                            style: const TextStyle(
                                                color: LongaLottoPosColor
                                                    .warm_grey_seven,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: context.screenWidth,
                                            height: ((widget
                                                .drawerModuleList[index]?[0]
                                                .menuBeanList
                                                ?.length)! *
                                                42),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ListView.builder(
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index1) {
                                                  return Material(
                                                    child: InkWell(
                                                      onTap: () {
                                                        _onClick(widget
                                                            .drawerModuleList[
                                                        index]![0]
                                                            .menuBeanList![index1]
                                                            .menuCode!);
                                                      },
                                                      child: Container(
                                                        color: Colors.transparent,
                                                        child: Row(children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            child: Image.asset(
                                                              "assets/icons/${_getImage(widget.drawerModuleList[index]![0].menuBeanList![index1].menuCode!)}",
                                                              width: 25,
                                                              height: 25,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          Text(
                                                            widget
                                                                .drawerModuleList[
                                                            index]
                                                            ?[0]
                                                                .menuBeanList?[
                                                            0]
                                                                .caption !=
                                                                null
                                                                ? widget
                                                                .drawerModuleList[
                                                            index]![0]
                                                                .menuBeanList![
                                                            index1]
                                                                .caption!
                                                                : "",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                                color:
                                                                LongaLottoPosColor
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: widget
                                                    .drawerModuleList[index]?[0]
                                                    .menuBeanList
                                                    ?.length,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        color: LongaLottoPosColor.black,
                                      );
                                    },
                                    itemCount: widget.drawerModuleList.length),
                              ),
                            ),
                            Text("v ${packageInfo?.version}", style: const TextStyle(fontWeight: FontWeight.bold)).p(16)
                          ],
                        ),
                      ),
                    );
                }

                return SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: Drawer(
                    width: context.screenWidth * 0.8,
                    child: Container(
                      //header of drawer
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.screenHeight * 0.2,
                            child: Stack(children: [
                              Container(
                                width: context.screenWidth * 0.8,
                                color: LongaLottoPosColor.light_golden_rod,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/icons/icon_drawer_user.png",
                                          width: 70, height: 70),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          width: ((context.screenWidth * 0.8) - 120),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${UserInfo.userName} (${UserInfo.userId})",
                                                style: const TextStyle(
                                                  color: LongaLottoPosColor.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                              Text(
                                                "${context.l10n.organisation} : ${UserInfo.organisation}",
                                                style: const TextStyle(
                                                  color: LongaLottoPosColor.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(0, 1.85),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  child: Card(
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        context.l10n.wallet_balance,
                                                        style: const TextStyle(
                                                            color: LongaLottoPosColor.game_color_grey,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                    const HeightBox(2),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                                      textBaseline: TextBaseline.ideographic,
                                                      children: [
                                                        Text(
                                                            UserInfo.totalBalance,
                                                            style: const TextStyle(
                                                                color: LongaLottoPosColor.game_color_blue,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        ),
                                                        WidthBox(2),
                                                        Text(
                                                            getDefaultCurrency(getLanguage()),
                                                            style: const TextStyle(
                                                                color: LongaLottoPosColor.game_color_blue,
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )

                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print("---------------------");
                                              _refreshBtnAnimationController
                                                  .forward();
                                              showDialog(context);
                                              setState(() {
                                                isBalanceRefreshing = true;
                                              });
                                              BlocProvider.of<LoginBloc>(context)
                                                  .add(GetLoginDataApi(
                                                  context: context));
                                            },
                                            customBorder: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: Ink(
                                              child: RotationTransition(
                                                  turns: refreshBtnAnimation,
                                                  child: const Icon(Icons.loop, color: LongaLottoPosColor.tangerine, size: 30)
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        context.l10n.accured_commission,
                                                        style: const TextStyle(
                                                            color: LongaLottoPosColor.game_color_grey,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                    const HeightBox(2),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                                      textBaseline: TextBaseline.ideographic,
                                                      children: [
                                                        Text(
                                                          //"${UserInfo.totalBalance} ${getDefaultCurrency(getLanguage())}",
                                                            UserInfo.displayCommission,
                                                            style: const TextStyle(
                                                                color: LongaLottoPosColor.game_color_blue,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        ),
                                                        const WidthBox(2),
                                                        Text(
                                                            getDefaultCurrency(getLanguage()),
                                                            style: const TextStyle(
                                                                color: LongaLottoPosColor.game_color_blue,
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 40),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0, bottom: 0),
                              child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.drawerModuleList[index]?[0]
                                              .displayName !=
                                              null
                                              ? widget.drawerModuleList[index]![0]
                                              .displayName!
                                              .toString()
                                              : "",
                                          style: const TextStyle(
                                              color: LongaLottoPosColor
                                                  .warm_grey_seven,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          width: context.screenWidth,
                                          height: ((widget
                                              .drawerModuleList[index]?[0]
                                              .menuBeanList
                                              ?.length)! *
                                              42),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index1) {
                                                return Material(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _onClick(widget
                                                          .drawerModuleList[
                                                      index]![0]
                                                          .menuBeanList![index1]
                                                          .menuCode!);
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Row(children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                          child: Image.asset(
                                                            "assets/icons/${_getImage(widget.drawerModuleList[index]![0].menuBeanList![index1].menuCode!)}",
                                                            width: 25,
                                                            height: 25,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        Text(
                                                          widget
                                                              .drawerModuleList[
                                                          index]
                                                          ?[0]
                                                              .menuBeanList?[
                                                          0]
                                                              .caption !=
                                                              null
                                                              ? widget
                                                              .drawerModuleList[
                                                          index]![0]
                                                              .menuBeanList![
                                                          index1]
                                                              .caption!
                                                              : "",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              color:
                                                              LongaLottoPosColor
                                                                  .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: widget
                                                  .drawerModuleList[index]?[0]
                                                  .menuBeanList
                                                  ?.length,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: LongaLottoPosColor.black,
                                    );
                                  },
                                  itemCount: widget.drawerModuleList.length),
                            ),
                          ),
                          Text("v ${packageInfo?.version}", style: const TextStyle(fontWeight: FontWeight.bold)).p(16)
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  _spacer() {
    return const SizedBox(height: 5);
  }

  _getImage(String code) {
    if (code == PAYMENT_REPORT) {
      return "icon_drawer_payment_report.png";
    }
    if (code == OLA_REPORT) {
      return "icon_drawer_deposit_withdraw_report.png";
    }
    if (code == CHANGE_PASSWORD) {
      return "icon_drawer_change_password.png";
    }
    if (code == DEVICE_REGISTRATION) {
      return "icon_drawer_device_register.png";
    }
    if (code == LOGOUT) {
      return "icon_drawer_logout.png";
    }
    if (code == BILL_REPORT) {
      return "icon_drawer_invoice.png";
    }
    if (code == M_LEDGER) {
      return "icon_drawer_ledger_report.png";
    }
    if (code == USER_REGISTRATION) {
      return "icon_drawer_user_registration.png";
    }
    if (code == USER_SEARCH) {
      return "icon_drawer_search_user.png";
    }
    if (code == ACCOUNT_SETTLEMENT) {
      return "icon_drawer_account_settlement.png";
    }
    if (code == SETTLEMENT_REPORT) {
      return "icon_drawer_settlement_report.png";
    }
    if (code == SALE_WINNING_REPORT) {
      return "icon_drawer_sale_winning_report.png";
    }
    if (code == INTRA_ORG_CASH_MGMT) {
      return "icon_drawer_cash_management.png";
    }
    if (code == M_SUMMARIZE_LEDGER) {
      return "ledger.png";
    }
    if (code == COLLECTION_REPORT) {
      return "icon_drawer_ledger_report.png";
    }
    if (code == ALL_RETAILERS) {
      return "icon_drawer_search_user.png";
    }
    if (code == QR_CODE_REGISTRATION) {
      return "icon_qr.png";
    }
    if (code == NATIVE_DISPLAY_QR) {
      return "icon_qr.png";
    }
    if (code == BALANCE_REPORT) {
      return "statistics.png";
    }
    if (code == OPERATIONAL_REPORT) {
      return "statistics.png";
    }
    if (code == "M_CHANGE_NETWORk") {
      return "icon_drawer_change_password.png";
    }
    if (code == "M_ORGANIZATION_COMMISSION_REPORT") {
      return "icon_drawer_change_password.png";
    } else {
      return "statistics.png";
    }
  }

  _onClick(String code) {
    if (code == PAYMENT_REPORT) {
      return "icon_drawer_payment_report.png";
    }
    if (code == OLA_REPORT) {
      Navigator.pop(context);
      Navigator.pushNamed(context, LongaLottoPosScreen.depositWithdrawalScreen);
      // return "icon_drawer_deposit_withdraw_report.png";
    }
    if (code == CHANGE_PASSWORD) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, LongaLottoPosScreen.changePin);
    }
    if (code == DEVICE_REGISTRATION) {
      return "icon_drawer_device_register.png";
    }
    if (code == LOGOUT) {
      UserInfo.logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
          LongaLottoPosScreen.loginScreen, (Route<dynamic> route) => false);
    }
    if (code == BILL_REPORT) {
      return "icon_drawer_invoice.png";
    }
    if (code == M_LEDGER) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, LongaLottoPosScreen.ledgerReportScreen);
    }
    if (code == USER_REGISTRATION) {
      return "icon_drawer_user_registration.png";
    }
    if (code == USER_SEARCH) {
      return "icon_drawer_search_user.png";
    }
    if (code == ACCOUNT_SETTLEMENT) {
      return "icon_drawer_account_settlement.png";
    }
    if (code == SETTLEMENT_REPORT) {
      return "icon_drawer_settlement_report.png";
    }
    if (code == SALE_WINNING_REPORT) {
      Navigator.of(context).pop();

      Navigator.pushNamed(context, LongaLottoPosScreen.saleWinTxn);
    }
    if (code == INTRA_ORG_CASH_MGMT) {
      return "icon_drawer_cash_management.png";
    }
    if (code == M_SUMMARIZE_LEDGER) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, LongaLottoPosScreen.summarizeLedgerReport);
    }
    if (code == COLLECTION_REPORT) {
      return "icon_drawer_ledger_report.png";
    }
    if (code == ALL_RETAILERS) {
      return "icon_drawer_search_user.png";
    }
    if (code == QR_CODE_REGISTRATION) {
      return "icon_qr.png";
    }
    if (code == NATIVE_DISPLAY_QR) {
      return "icon_qr.png";
    }
    if (code == BALANCE_REPORT) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, LongaLottoPosScreen.balanceInvoiceReportScreen);
    }
    if (code == OPERATIONAL_REPORT) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, LongaLottoPosScreen.operationalReportScreen);
    }
    if (code == "M_CHANGE_NETWORk") {
      final MethodChannel _methodChannel = MethodChannel('com.skilrock.longalottoretail/notification_panel_swipe');
      try {
        _methodChannel.invokeMethod('disableNotificationSwipe');
      } on PlatformException catch (e) {
        // Handle any platform exceptions
        print('Failed to disable notification panel swipe: ${e.message}');
      }
    }
    if (code == "M_ORGANIZATION_COMMISSION_REPORT") {
      Navigator.pop(context);
      Navigator.pushNamed(context, LongaLottoPosScreen.commissionReportScreen);
    }
  }

  showDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        pageBuilder: (BuildContext ctx, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return const Dialog(
            elevation: 0.0,
            insetPadding:
                EdgeInsets.symmetric(horizontal: 32.0, vertical: 200.0),
            backgroundColor: Colors.transparent,
            child: HeightBox(20),
          );
        });
  }
}
