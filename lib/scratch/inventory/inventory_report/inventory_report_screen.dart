import 'dart:developer';

import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/scratch/inventory/inventory_report/bloc/inv_rep_bloc.dart';
import 'package:longalottoretail/scratch/inventory/inventory_report/inv_widget/inv_widget.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_scaffold.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utility/longa_lotto_pos_color.dart';
import 'model/request/inv_rep_details.dart';
import 'model/response/inv_rep_response.dart';

class InventoryReportScreen extends StatefulWidget {
  final MenuBeanList? menuBeanList;

  const InventoryReportScreen({Key? key, required this.menuBeanList})
      : super(key: key);

  @override
  State<InventoryReportScreen> createState() => _InventoryReportScreenState();
}

class _InventoryReportScreenState extends State<InventoryReportScreen> {
  List<GameWiseBookDetailList>? gameWiseBookDetailList;
  bool mIsShimmerLoading = false;

  @override
  void initState() {
    BlocProvider.of<InvRepBloc>(context).add(
      InvRepForRetailer(context: context, menuBeanList: widget.menuBeanList),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LongaScaffold(
        appBackGroundColor: LongaLottoPosColor.app_bg,
        backgroundColor: LongaLottoPosColor.white,
        showAppBar: true,
        //centerTitle: false,
        appBarTitle: widget.menuBeanList?.caption ?? '',
        body: BlocListener<InvRepBloc, InvRepState>(
          listener: (context, state) {
            log("state : $state");
            if (state is GettingInvRepForRet) {
              setState(() {
                mIsShimmerLoading = true;
              });
            } else if (state is GotInvRepForRet) {
              setState(() {
                gameWiseBookDetailList = state.response.gameWiseBookDetailList;
                mIsShimmerLoading = false;
              });
            } else if (state is InvRepForRetError) {
              setState(() {
                mIsShimmerLoading = false;
              });
              Alert.show(
                  context: context,
                  title: context.l10n.report_error.toUpperCase(),
                  subtitle: state.errorMessage,
                  type: AlertType.error,
                  buttonText: context.l10n.ok.toUpperCase(),
                  isDarkThemeOn: false,
                  buttonClick: () {
                    Navigator.of(context).pop();
                  });
            }
          },
          child: GridView.builder(
              itemCount: mIsShimmerLoading ? 10 : gameWiseBookDetailList?.length,
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7),
              itemBuilder: (context, cardIndex) {
                return mIsShimmerLoading
                    ? Shimmer.fromColors(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                              ).pOnly(bottom: 10),
                              Container(
                                width: 80,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                              ),
                            ],
                          ),
                        ).p(6),
                      )
                    : gameWiseBookDetailList != null &&
                            gameWiseBookDetailList!.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              List<InvRepDetailsModel> invRepDetailList = [];
                              if(gameWiseBookDetailList![cardIndex].inTransitPacksList != null){
                                invRepDetailList.add(InvRepDetailsModel(title : context.l10n.in_transit , packList : gameWiseBookDetailList![cardIndex].inTransitPacksList!),);
                              }
                              if(gameWiseBookDetailList![cardIndex].receivedPacksList != null){
                                invRepDetailList.add(InvRepDetailsModel(title :  context.l10n.received, packList : gameWiseBookDetailList![cardIndex].receivedPacksList!),);
                              }
                              if(gameWiseBookDetailList![cardIndex].activatedPacksList != null){
                                invRepDetailList.add(InvRepDetailsModel(title : context.l10n.activated , packList : gameWiseBookDetailList![cardIndex].activatedPacksList!),);
                              }
                              if(gameWiseBookDetailList![cardIndex].invoicedPacksList != null){
                                invRepDetailList.add(InvRepDetailsModel(title : context.l10n.in_voice , packList : gameWiseBookDetailList![cardIndex].invoicedPacksList!),);
                              }
                              InvRepDetail().show(
                                context: context,
                                title: context.l10n.books,
                                invRepDetailList: invRepDetailList,
                              );
                            },
                            child: InvRepCard(
                              gameWiseBookDetailList: gameWiseBookDetailList,
                              cardIndex: cardIndex,
                            ),
                          )
                        : Container();
              }),
        ),
      ),
    );
  }
}
