import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/bloc/deposit_bloc.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/deposit_screen.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/bloc/withdrawal_bloc.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/withdrawal_screen.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/primary_button.dart';

import '../home/widget/longa_scaffold.dart';
import '../login/bloc/login_bloc.dart';
import '../login/bloc/login_state.dart';
import '../utility/auth_bloc/auth_bloc.dart';
import '../utility/rounded_container.dart';

class ScanAndPlayScreen extends StatefulWidget {
  const ScanAndPlayScreen({super.key});

  @override
  State<ScanAndPlayScreen> createState() => _ScanAndPlayScreenState();
}

class _ScanAndPlayScreenState extends State<ScanAndPlayScreen>
    with SingleTickerProviderStateMixin {
  var isDeposit = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    secureScreen();
    _tabController = TabController(vsync: this, length: 2);
  }


  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }



  @override
  Widget build(BuildContext context) {
    var body1 = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: PrimaryButton(
                        fillDisableColor: isDeposit
                            ? LongaLottoPosColor.gray
                            : LongaLottoPosColor.red,
                        fillEnableColor: isDeposit
                            ? LongaLottoPosColor.gray
                            : LongaLottoPosColor.red,
                        textColor: LongaLottoPosColor.white,
                        borderColor: isDeposit
                            ? LongaLottoPosColor.dark_gray
                            : LongaLottoPosColor.red,
                        text: context.l10n.deposit,
                        isCancelBtn: true,
                        fontWeight: FontWeight.w500,
                        onPressed: () {
                          setState(() {
                            isDeposit = true;
                            _tabController.index = 0;
                          });
                        }),
                  ),
                  Tab(
                      child: PrimaryButton(
                          fillDisableColor: !isDeposit ? LongaLottoPosColor.gray : LongaLottoPosColor.red,
                          fillEnableColor: !isDeposit
                              ? LongaLottoPosColor.gray
                              : LongaLottoPosColor.red,
                          textColor: LongaLottoPosColor.white,
                          borderColor: !isDeposit ? LongaLottoPosColor.dark_gray : LongaLottoPosColor.red,
                          text: context.l10n.withdrawal,
                          fontWeight: FontWeight.w500,
                          isCancelBtn: true,
                          onPressed: () {
                            setState(() {
                              isDeposit = false;
                              _tabController.index = 1;
                            });
                          })),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.36,
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  MultiBlocProvider(
                      providers: [
                        BlocProvider<DepositBloc>(
                          create: (context) => DepositBloc(),
                        ),
                      ],
                      child: DepositScreen(
                        onTap: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(GetLoginDataApi(context: context));
                        },
                      )),
                  MultiBlocProvider(
                      providers: [
                        BlocProvider<WithdrawalBloc>(
                          create: (context) => WithdrawalBloc(),
                        ),
                      ],
                      child:  WithdrawalScreen(
                        onTap: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(GetLoginDataApi(context: context));
                        },
                      ))
                ]),
          )
        ],
      ),
    );

    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is GetLoginDataSuccess) {
            if (state.response != null) {
              //var dummyResponse = """{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"lastName":"williams","userStatus":"ACTIVE","walletType":"PREPAID","mobileNumber":"8505957513","isHead":"YES","orgId":2,"accessSelfDomainOnly":"YES","balance":"70,00 ","qrCode":null,"orgCode":"ORGRET101test1111231","parentAgtOrgId":0,"parentMagtOrgId":0,"creditLimit":"0,00 ","userBalance":"-266 000,00 ","distributableLimit":"0,00 ","orgTypeCode":"RET","mobileCode":"+91","orgName":"ret_test_1011111231","userId":672,"isAffiliate":"NO","domainId":1,"walletMode":"COMMISSION","orgStatus":"ACTIVE","firstName":"ret","regionBinding":"REGION","rawUserBalance":-266000.0,"parentSagtOrgId":0,"username":"monuret"}}}""";
              //BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(loginDataResponse: GetLoginDataResponse.fromJson(jsonDecode(dummyResponse))));
              BlocProvider.of<AuthBloc>(context)
                  .add(UpdateUserInfo(loginDataResponse: state.response!));
            }
          }
        },
        child: LongaScaffold(
          showAppBar: true,
          appBarTitle: context.l10n.scanNPlay_title,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          body: RoundedContainer(child: body1),
        ));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _tabController.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);

  }
}
