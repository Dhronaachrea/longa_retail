import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:velocity_x/velocity_x.dart';

class ScratchScreen extends StatefulWidget {
  List<MenuBeanList>? scratchMenuBeanList;

  ScratchScreen({Key? key, this.scratchMenuBeanList}) : super(key: key);

  @override
  ScratchScreenState createState() => ScratchScreenState();
}

class ScratchScreenState extends State<ScratchScreen> {

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = (orientation == Orientation.landscape);

    return SafeArea(
      child: LongaScaffold(
        showAppBar: true,
        appBackGroundColor: LongaLottoPosColor.app_bg,
        drawer: LongaLottoPosDrawer(drawerModuleList: const []),
        backgroundColor: LongaLottoPosColor.white,
        appBarTitle: context.l10n.scratch,
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: isLandscape ? 1 : 0.8,
              crossAxisCount: isLandscape ? 5 : 2,
            ),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.scratchMenuBeanList?.length,
            itemBuilder: (BuildContext context, int index) {
              return Ink(
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
                    moveToNextScreen(widget.scratchMenuBeanList![index]);
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Ink(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            "assets/scratch/${widget.scratchMenuBeanList?[index].menuCode}.svg",
                            width: 60,
                            height: 60,
                            semanticsLabel: 'A red up arrow'
                        ).p8(),
                        Text(widget.scratchMenuBeanList?[index].caption ?? "NA",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: LongaLottoPosColor.black,
                                fontWeight: FontWeight.bold,
                                fontSize: isLandscape ? 18 : 14
                            ))
                      ],
                    ),
                  ),
                ),
              ).p(6);
            }).p(10),
      ),
    );
  }

  void moveToNextScreen(MenuBeanList? menuBeanList) {
    print("Screen Open--------------->${menuBeanList?.menuCode}");
    String screenName;
    switch (menuBeanList?.menuCode) {
      case "SCRATCH_SALE":
        screenName = LongaLottoPosScreen.saleTicketScreen;
        break;
      case "SCRATCH_WIN_CLAIM":
        screenName = LongaLottoPosScreen.ticketValidationAndClaimScreen;
        break;
      case "SCRATCH_ORDER_BOOK":
        screenName = LongaLottoPosScreen.packOrderScreen;
        break;
      case "SCRATCH_RECEIVE_BOOK":
        screenName = LongaLottoPosScreen.packReceiveScreen;
        break;
      case "M_SCRATCH_INV_REPORT":
        screenName = LongaLottoPosScreen.inventoryReportScreen;
        break;
      case "SCRATCH_ACTIVATE_BOOK":
        screenName = LongaLottoPosScreen.packActivationScreen;
        break;
      case "SCRATCH_RETURN_BOOK":
        screenName = LongaLottoPosScreen.packReturnScreen;
        break;
      case "M_SCRATCH_INV_SUMMARY_REPORT":
        screenName = LongaLottoPosScreen.inventoryFlowReportScreen;
        break;
      default:
        screenName = LongaLottoPosScreen.qrScanScreen;
    }
    Navigator.pushNamed(context, screenName, arguments: menuBeanList);
  }
}