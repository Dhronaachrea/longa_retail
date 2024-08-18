import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../login/bloc/login_bloc.dart';
import '../../login/login_screen.dart';
import '../../utility/auth_bloc/auth_bloc.dart';
import '../../utility/user_info.dart';
import '../../utility/utils.dart';
import '../../utility/widgets/primary_button.dart';

class LongaAppBar extends StatefulWidget implements PreferredSizeWidget {
  const LongaAppBar({
    this.myKey,
    Key? key,
    this.title,
    this.showBalance,
    this.showBell,
    this.showDrawer,
    this.appBackGroundColor,
    this.showBottomAppBar = false,
    this.showLoginBtnOnAppBar = true,
    this.centeredTitle = false,
    this.bottomTapvalue,
    this.bottomTapLoginValue,
    this.onBackButton,
    this.mAppBarBalanceChipVisible,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? myKey;
  final String? title;
  final bool? bottomTapvalue;
  final bool? bottomTapLoginValue;
  final bool? showDrawer;
  final bool? showBalance;
  final bool? showBell;
  final Color? appBackGroundColor;
  final bool? showBottomAppBar;
  final bool? showLoginBtnOnAppBar;
  final bool? centeredTitle;
  final VoidCallback? onBackButton;
  final bool? mAppBarBalanceChipVisible;

  // final bool? signin;
  @override
  State<LongaAppBar> createState() => _LongaAppBarState();

  @override
  Size get preferredSize => showBottomAppBar == false
      ? const Size(double.infinity, kToolbarHeight)
      : const Size(double.infinity, kToolbarHeight * 2);
}

class _LongaAppBarState extends State<LongaAppBar> {
  bool? isUserLoggedIn;
  late Map<String, dynamic> prefs;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   var currentPage = ModalRoute.of(context)?.settings.name;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      /*String? cashBalance =(context.watch<AuthBloc>().cashBalance ?? UserInfo.cashBalance).toString();*/

      return AppBar(
        backgroundColor: widget.appBackGroundColor ?? Colors.transparent,
        elevation: 0,
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Text(
            widget.title != null ? widget.title! : '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: LongaLottoPosColor.grape_purple,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
        ),
        leading: Visibility(
          visible: widget.showDrawer ?? true,
          child: widget.title == null
              ? MaterialButton(
                  padding: const EdgeInsets.all(10),
                  minWidth: 0,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Image.asset("assets/icons/drawer.png"),
                )
              : MaterialButton(
                  onPressed: () {
                    widget.onBackButton != null ? widget.onBackButton!() : Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset("assets/icons/back_icon.svg",
                      color: LongaLottoPosColor.black),
                ),
        ),
        actions: [
          widget.mAppBarBalanceChipVisible != null && widget.mAppBarBalanceChipVisible!
            ? Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: LongaLottoPosColor.tangerine.withOpacity(0.7),
              border: Border.all(color: LongaLottoPosColor.white),
              borderRadius: const BorderRadius.all(Radius.circular(30))
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: '${context.l10n.balance}\n',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: LongaLottoPosColor.black)),
                    TextSpan(
                        text:
                            '${UserInfo.totalBalance}${getDefaultCurrency(getLanguage())}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: LongaLottoPosColor.black,
                        )),
                  ],
                ),
              ),
            ),
          )
            : Container()
        ],
      );
    });
  }

  Future _loginOrSignUp() {
    return showDialog(
        context: context,
        builder: (context) => BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(),
              child: const LoginScreen(),
            )
        // builder: (context) => const SignUp(),
        // builder: (context) => const OtpScreen(),
        );
  }
}
