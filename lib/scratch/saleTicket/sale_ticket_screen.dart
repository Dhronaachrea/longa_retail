import 'dart:async';
import 'dart:developer';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:longalottoretail/scratch/pack_activation/model/game_list_response.dart';
import 'package:longalottoretail/scratch/saleTicket/sale_widget/sale_widget.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/utility/widgets/longa_pos_text_field_underline.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/scratch/saleTicket/bloc/sale_ticket_bloc.dart';
import 'package:longalottoretail/scratch/saleTicket/bloc/sale_ticket_event.dart';
import 'package:longalottoretail/scratch/saleTicket/bloc/sale_ticket_state.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/shake_animation.dart';

import '../../utility/widgets/scanner_error.dart';
import '../packOrder/bloc/pack_event.dart';
import '../packOrder/bloc/pack_state.dart';
import 'model/response/remaining_ticket_count_response.dart';
import 'model/response/sale_ticket_response.dart';

class SaleTicketScreen extends StatefulWidget {
  MenuBeanList? scratchList;

  SaleTicketScreen({Key? key, required this.scratchList}) : super(key: key);

  @override
  State<SaleTicketScreen> createState() => _SaleTicketScreenState();
}

class _SaleTicketScreenState extends State<SaleTicketScreen> {
  TextEditingController barCodeController = TextEditingController();
  ShakeController barCodeShakeController = ShakeController();
  bool isGenerateOtpButtonPressed = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  double mAnimatedButtonSize = 140.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  double addAnimatedButtonSize = 140.0;
  bool addButtonTextVisibility = true;
  ButtonShrinkStatus addButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  final MobileScannerController _scanController =
      MobileScannerController(autoStart: true);
  var isLoading = false;

  var isSingle = true;
  var isMultiple = false;
  var isSeries = false;
  var isRandom = false;
  double buttonRadius = 20;
  double optionsButtonHeight = 30;
  double optionsButtonWidth = 100;
  int numberOfTicketInBook = 0;
  int maxTicketInSeries = 1;
  bool remainingTicketCountIsCalled = false;

  //int ticketCount = 1;

  var ticketCountController = TextEditingController();
  ShakeController numOfTicketShakeController = ShakeController();
  List<String> ticketNumberList = [];

  @override
  void initState() {
    ticketCountController.text = "1";
    super.initState();
  }

  @override
  void dispose() {
    log("dispose is called");
    _scanController.dispose();
    barCodeController.dispose();
    ticketCountController.dispose();
    barCodeShakeController.dispose();
    numOfTicketShakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LongaScaffold(
        appBackGroundColor: LongaLottoPosColor.app_bg,
        backgroundColor: LongaLottoPosColor.white,
        resizeToAvoidBottomInset: true,
        showAppBar: true,
        appBarTitle: widget.scratchList?.caption ?? context.l10n.sale_ticket,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is GetLoginDataSuccess) {
              if (state.response != null) {
                BlocProvider.of<AuthBloc>(context)
                    .add(UpdateUserInfo(loginDataResponse: state.response!));
              }
            } else if (state is GetLoginDataError) {}
          },
          child: BlocListener<SaleTicketBloc, SaleTicketState>(
            listener: (context, state) {
              if (state is SaleTicketLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is SaleTicketSuccess) {
                SaleTicketResponse response = state.response;
                setState(() {
                  isLoading = false;
                });
                BlocProvider.of<LoginBloc>(context)
                    .add(GetLoginDataApi(context: context));
                Alert.show(
                  type: AlertType.success,
                  isDarkThemeOn: false,
                  buttonClick: () {
                    Navigator.of(context).pop();
                  },
                  title: context.l10n.success,
                  subtitle: ((response.responseCode) == 1000)
                      ? context.l10n.ticket_is_marked_as_sold
                      : state.response.responseMessage!,
                  otherData: response.saleTicketDetails != null && response.saleTicketDetails!.isNotEmpty
                      ? SizedBox(
                       height: 220,
                        child: SingleChildScrollView(
                          child: Column(
                    children: response.saleTicketDetails!.map((saleTicketDetailsItem)=>Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //gameName
                            Opacity(
                              opacity: 0.5,
                              child: Text(context.l10n.name,
                                  style: const TextStyle(
                                      color: LongaLottoPosColor
                                          .brownish_grey_three,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                            ),
                            const HeightBox(2.0),
                            Text(saleTicketDetailsItem.gameName!,
                                style: const TextStyle(
                                    color:
                                    LongaLottoPosColor.brownish_grey_three,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                            const HeightBox(5),
                            //Ticket Price
                            Opacity(
                              opacity: 0.5,
                              child: Text(context.l10n.ticket_price,
                                  style: const TextStyle(
                                      color: LongaLottoPosColor
                                          .brownish_grey_three,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                            ),
                            const HeightBox(2),
                            Text(
                                saleTicketDetailsItem.ticketPrice
                                    .toString(),
                                style: const TextStyle(
                                    color:
                                    LongaLottoPosColor.brownish_grey_three,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                            const HeightBox(5),
                            //Ticket number
                            saleTicketDetailsItem.ticketNumbers != null &&
                                saleTicketDetailsItem
                                    .ticketNumbers!.isNotEmpty
                                ? Opacity(
                              opacity: 0.5,
                              child: Text(context.l10n.ticket_number,
                                  style: const TextStyle(
                                      color: LongaLottoPosColor
                                          .brownish_grey_three,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                            )
                                : Container(),
                            const HeightBox(2),
                            saleTicketDetailsItem.ticketNumbers != null &&
                                saleTicketDetailsItem
                                    .ticketNumbers!.isNotEmpty ?
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5) ,
                                border: Border.all(
                                  color: LongaLottoPosColor
                                      .brownish_grey_three.withOpacity(0.5)
                                ),
                              ),
                              height: 60,
                              child: SingleChildScrollView(
                                child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                    children:saleTicketDetailsItem.ticketNumbers!.map((ticketNumber) => Text(
                                        ticketNumber,
                                        style: const TextStyle(
                                            color:
                                            LongaLottoPosColor.brownish_grey_three,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.left),).toList()),
                              ),
                            )
                                : Container(),
                            const HeightBox(10),
                            Divider(
                              color: LongaLottoPosColor
                                  .brownish_grey_three.withOpacity(0.5)
                            ),
                            const HeightBox(10),
                          ],
                    )).toList(),
                  ),
                        ),
                      )
                      : Container(),
                  buttonText: context.l10n.ok.toUpperCase(),
                  context: context,
                );
              }
              if (state is SaleTicketError) {
                setState(() {
                  isLoading = false;
                  mAnimatedButtonSize = 140.0;
                  mButtonTextVisibility = true;
                  mButtonShrinkStatus = ButtonShrinkStatus.over;
                  addAnimatedButtonSize = 140;
                  addButtonTextVisibility = true;
                  addButtonShrinkStatus = ButtonShrinkStatus.over;
                  barCodeController.clear();
                  ticketNumberList = [];
                });
                // Navigator.of(context).pop();
                Alert.show(
                  type: AlertType.error,
                  isDarkThemeOn: false,
                  buttonClick: () {
                    _scanController.start();
                  },
                  title: context.l10n.error,
                  subtitle: state.errorMessage,
                  buttonText: context.l10n.ok.toUpperCase(),
                  context: context,
                );
              }
              if (state is RemainingTicketCountError) {
                Alert.show(
                  type: AlertType.error,
                  isDarkThemeOn: false,
                  buttonClick: () {
                    _scanController.start();
                   setState(() {
                     remainingTicketCountIsCalled = false;
                   });
                  },
                  title: context.l10n.error,
                  subtitle: state.errorMessage,
                  buttonText: context.l10n.ok.toUpperCase(),
                  context: context,
                );
              }
              if (state is RemainingTicketCountSuccess) {
                RemainingTicketCountResponse response = state.response;
                setState(() {
                  remainingTicketCountIsCalled = false;
                  numberOfTicketInBook = response.responseData.values.first;
                  maxTicketInSeries = numberOfTicketInBook /*-int.parse(barCodeController.text.substring(11,14))*/;
                });
              }
            },
            child: BlocListener<PackBloc, PackState>(
              listener: (context, state) {
                if (state is PackLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is GameListSuccess) {
                  GameListResponse response = state.response;
                  String trimmedTicketNumber = barCodeController.text.trim();
                  String ticketNumber = trimmedTicketNumber;
                  String? formattedTicketNum;
                  if (response.games != null && response.games!.isNotEmpty) {
                    List<Games>? games = response.games
                        ?.where((element) => ((element.gameNumber.toString()) ==
                            (trimmedTicketNumber.substring(0, 3))))
                        .toList();
                    if (games != null && games.isNotEmpty) {
                      Games game = games[0];
                      int gameNumberDigits = game.gameNumber.toString().length;
                      int packAndBookNumberDigit =
                          game.packNumberDigits + game.bookNumberDigits;
                      formattedTicketNum =
                          "${ticketNumber.substring(0, gameNumberDigits)}-${ticketNumber.substring(gameNumberDigits, (gameNumberDigits + packAndBookNumberDigit))}"
                          "-${ticketNumber.substring((gameNumberDigits + packAndBookNumberDigit), ticketNumber.length)}"
                          "";
                    }
                  }
                  ticketNumberList.add(formattedTicketNum ?? ticketNumber);
                  if(isSeries){
                    BlocProvider.of<SaleTicketBloc>(context).add(
                        SaleTicketApi(
                            context: context,
                            scratchList: widget.scratchList,
                           fromTicket: barCodeController.text,
                          toTicket: getToTicket(barCodeController.text, ticketCountController)
                        ));
                  } else{
                  BlocProvider.of<SaleTicketBloc>(context).add(
                    SaleTicketApi(
                        context: context,
                        scratchList: widget.scratchList,
                        ticketNumberList: ticketNumberList),
                  );
                }
                } else if (state is PackError) {
                  setState(() {
                    isLoading = false;
                    mAnimatedButtonSize = 140.0;
                    mButtonTextVisibility = true;
                    mButtonShrinkStatus = ButtonShrinkStatus.over;
                    addAnimatedButtonSize = 140;
                    addButtonTextVisibility = true;
                    addButtonShrinkStatus = ButtonShrinkStatus.over;
                    barCodeController.clear();
                    ticketNumberList = [];
                  });
                  Alert.show(
                    type: AlertType.error,
                    isDarkThemeOn: false,
                    buttonClick: () {
                      _scanController.start();
                    },
                    title: 'Error!',
                    subtitle: state.errorMessage,
                    buttonText: 'ok'.toUpperCase(),
                    context: context,
                  );
                }
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _loginForm,
                  autovalidateMode: autoValidate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      //Single and Multiple button
                      SingleMultipleButton(
                        singleButtonOnTap: () {
                          setState(() {
                            isSingle = true;
                            isMultiple = false;
                            isSeries = false;
                            isRandom = false;
                            barCodeController.clear();
                            ticketNumberList = [];
                            numberOfTicketInBook = 0;
                          });
                        },
                        multipleButtonOnTap: () {
                          setState(() {
                            isSingle = false;
                            isMultiple = true;
                            isSeries = true;
                            isRandom = false;
                            barCodeController.clear();
                            ticketNumberList = [];
                            ticketCountController.text = "1";
                            numberOfTicketInBook = 0;
                          });
                        },
                        optionsButtonWidth: optionsButtonWidth,
                        optionsButtonHeight: optionsButtonHeight,
                        buttonRadius: buttonRadius,
                        isSingle: isSingle,
                        isMultiple: isMultiple,
                      ),
                      //Series and Random button
                      SeriesRandomButton(
                        isMultiple: isMultiple,
                        optionsButtonWidth: optionsButtonWidth,
                        optionsButtonHeight: optionsButtonHeight,
                        buttonRadius: buttonRadius,
                        isSingle: isSingle,
                          isRandom: isRandom,
                        isSeries: isSeries,
                        seriesButtonOnTap: () {
                          setState(() {
                            isSingle = false;
                            isMultiple = true;
                            isSeries = true;
                            isRandom = false;
                            barCodeController.clear();
                            ticketNumberList = [];
                            ticketCountController.text = "1";
                            numberOfTicketInBook = 0;
                          });
                        },
                        randomButtonOnTap: () {
                          setState(() {
                            isSingle = false;
                            isMultiple = true;
                            isSeries = false;
                            isRandom = true;
                            barCodeController.clear();
                            ticketNumberList = [];
                            numberOfTicketInBook = 0;
                          });
                        },
                      ),
                      //Series ticket number info
                      isSeries
                          ? const SizedBox(
                          height: 20,
                          child: SeriesTicketNumberInfo())
                          : const SizedBox(
                              height: 20,
                            ),
                      //ticket number
                      barCodeTextField(
                        onChanged: (text) {
                            int textLength = text.length;
                            if (textLength == 14 && isSeries && !remainingTicketCountIsCalled) {
                              remainingTicketCountIsCalled = true;
                              BlocProvider.of<SaleTicketBloc>(context).add(
                                  RemainingTicketCountApi(
                                      context: context,
                                      scratchList: widget.scratchList,
                                      bookNumber: text.substring(0,10),
                                  ));
                              setState(() {
                                log(" set state is called");
                                barCodeController.text = text;
                              });
                              barCodeController.selection =
                                  TextSelection.collapsed(offset: barCodeController.text.length);
                            } else {
                              setState(() {
                                numberOfTicketInBook = 0;
                                maxTicketInSeries = 1;
                                ticketCountController.text = "1";
                              });
                            }
                        },
                      ),
                      //scanner
                      SizedBox(
                        height: 200,
                        child: MobileScanner(
                          startDelay: true,
                          errorBuilder: (context, error, child) {
                            return ScannerError(
                              context: context,
                              error: error,
                            );
                          },
                          controller: _scanController,
                          onDetect: (capture) {
                            try {
                              final List<Barcode> barcodes = capture.barcodes;
                              String? data = barcodes[0].rawValue?.trim();
                              if (data != null && data.length >= 12) {
                                String formattedTicketNumber =
                                    formatTicketNumber(data);
                                if (isSeries && !remainingTicketCountIsCalled) {
                                  remainingTicketCountIsCalled = true;
                                  BlocProvider.of<SaleTicketBloc>(context).add(
                                      RemainingTicketCountApi(
                                        context: context,
                                        scratchList: widget.scratchList,
                                        bookNumber: formattedTicketNumber.substring(0,10),
                                      ));
                                  setState(() {
                                    barCodeController.text = formattedTicketNumber;
                                  });
                                  /*barCodeController.selection =
                                      TextSelection.collapsed(offset: barCodeController.text.length);*/
                                } else {
                                  setState(() {
                                    numberOfTicketInBook = 0;
                                    maxTicketInSeries = 1;
                                    ticketCountController.text = "1";
                                    barCodeController.text =
                                        formattedTicketNumber;
                                  });
                                }
                              }
                            } catch (e) {
                              print("Something went wrong with bar code: $e");
                            }
                          },
                        ),
                      ),
                      //left ticket in series
                      isMultiple &&
                              isSeries &&
                              (barCodeController.text.length == 14) && (numberOfTicketInBook > 0)
                          ? Text(
                              context.l10n.num_ticket_left_in_this_book(numberOfTicketInBook),
                              style: const TextStyle(
                                  color: LongaLottoPosColor.medium_green),
                            ).p2()
                          : const SizedBox(),
                      //selected number ticket in series
                      isMultiple &&
                              isSeries &&
                              (barCodeController.text.length == 14) && (numberOfTicketInBook > 0)
                          ? Text(
                              context.l10n.number_of_tickets,
                              style: const TextStyle(
                                  color:
                                      LongaLottoPosColor.brownish_grey_three),
                            ).p2()
                          : const SizedBox(),
                      isMultiple &&
                              isSeries &&
                              (barCodeController.text.length == 14) && (numberOfTicketInBook > 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Ink(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                          color:  ticketCountController.text.isEmpty || int.parse(ticketCountController.text) <= 1
                                              ? LongaLottoPosColor
                                              .game_color_grey
                                              : LongaLottoPosColor.black,
                                          width: .5)),
                                  child: AbsorbPointer(
                                    absorbing:ticketCountController.text.isEmpty ||  int.parse(ticketCountController.text) <= 1,
                                    child: InkWell(
                                      onTap: () {
                                        if (_loginForm.currentState!.validate()) {
                                          int ticketCount = int.parse(
                                              ticketCountController.text);
                                          if (ticketCount <= 1) {
                                            return;
                                          }
                                          --ticketCount;
                                          setState(() {
                                            ticketCountController.text =
                                            "$ticketCount";
                                          });
                                          ticketCountController.selection =
                                              TextSelection.collapsed(offset: ticketCountController.text.length);
                                        }
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: SvgPicture.asset(
                                              'assets/icons/minus.svg',
                                              width: 20,
                                              height: 20,
                                              color: ticketCountController.text.isEmpty || int.parse(ticketCountController.text) <= 1
                                                  ? LongaLottoPosColor
                                                      .game_color_grey
                                                  : LongaLottoPosColor.black)),
                                    ),
                                  ),
                                ).pOnly(right: 8,bottom: 10),
                                _numberOfTicketSelection(),
                                Ink(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                          color: ticketCountController.text.isEmpty || int.parse(ticketCountController.text) >= maxTicketInSeries  || int.parse(ticketCountController.text) == 0
                                              ? LongaLottoPosColor
                                              .game_color_grey
                                              : LongaLottoPosColor.black,
                                          width: .5)),
                                  child: AbsorbPointer(
                                    absorbing: ticketCountController.text.isEmpty || int.parse(ticketCountController.text) >= maxTicketInSeries  || int.parse(ticketCountController.text) == 0,
                                    child: InkWell(
                                      onTap: () {
                                        if (_loginForm.currentState!.validate()) {
                                          int ticketCount = int.parse(
                                              ticketCountController.text);
                                          if (ticketCount >= maxTicketInSeries) {
                                            return;
                                          }
                                          ++ticketCount;
                                         setState(() {
                                           ticketCountController.text =
                                           "$ticketCount";
                                         });
                                          ticketCountController.selection =
                                              TextSelection.collapsed(offset: ticketCountController.text.length);
                                        }
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: SvgPicture.asset(
                                              'assets/icons/plus.svg',
                                              width: 20,
                                              height: 20,
                                              color: ticketCountController.text.isEmpty || int.parse(ticketCountController.text) >= maxTicketInSeries  || int.parse(ticketCountController.text) == 0
                                                  ? LongaLottoPosColor
                                                      .game_color_grey
                                                  : LongaLottoPosColor.black)),
                                    ),
                                  ),
                                ).pOnly(right: 8,bottom: 10),
                              ],
                            )
                          : const SizedBox(),
                      //add Ticket and submit button
                      isSingle ? const SizedBox(height: 20) : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isMultiple && isRandom)
                            Expanded(child: _addTicketButton()),
                          if (isMultiple && isRandom)
                            const SizedBox(
                              width: 10,
                            ),
                          Expanded(child: _submitButton())
                        ],
                      ).pSymmetric(h: 20, v: 0),
                      //ticket details in series
                      isMultiple &&
                              isSeries &&
                              (barCodeController.text.length == 14) && (numberOfTicketInBook > 0)
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${context.l10n.ticket_number_added}:",
                                      style: const TextStyle(
                                        color: LongaLottoPosColor.brownish_grey_three,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        "(${context.l10n.count}: ${ticketCountController.text})",
                                      style : const TextStyle(
                                        color: LongaLottoPosColor.brownish_grey_three,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(context.l10n.from,
                                      style : const TextStyle(
                                        color: LongaLottoPosColor.brownish_grey_three,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(context.l10n.to,
                                      style : const TextStyle(
                                        color: LongaLottoPosColor.brownish_grey_three,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(barCodeController.text),
                                    Text(getToTicket(barCodeController.text,
                                        ticketCountController)),
                                  ],
                                ).pSymmetric(h: 20),
                              ],
                            ).pSymmetric(h: 20, v: 5)
                          : const SizedBox(),
                      // Random add ticket count
                      isMultiple && isRandom && ticketNumberList.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${context.l10n.ticket_number_added}:",
                                  style: const TextStyle(
                                    color: LongaLottoPosColor.brownish_grey_three,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    "(${context.l10n.count}: ${ticketNumberList.length})",
                                  style : const TextStyle(
                                    color: LongaLottoPosColor.brownish_grey_three,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ).p8()
                          : const SizedBox(),
                      //Random added ticket list
                      isMultiple && isRandom && ticketNumberList.isNotEmpty
                          ? Flexible(
                              fit: FlexFit.loose,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: ticketNumberList.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("#${index + 1}"),
                                        const SizedBox(width: 20),
                                        Text(ticketNumberList[index])
                                      ],
                                    ),
                                  );
                                },
                              ).p8(),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  barCodeTextField({ValueChanged? onChanged}) {
    return ShakeWidget(
        controller: barCodeShakeController,
        child: LongaPosTextFieldUnderline(
          isDense: true,
          maxLine: 1,
          hintText: context.l10n.ticket_number ?? "Ticket Number",
          maxLength: 14,
          inputType: TextInputType.number,
          inputFormatters: [maskFormatter],
          controller: barCodeController,
          underLineType: false,
          onChanged: onChanged,
          validator: (value) {
            if (validateInput(TotalTextFields.userName).isNotEmpty) {
              if (isGenerateOtpButtonPressed) {
                barCodeShakeController.shake();
              }
              return validateInput(TotalTextFields.userName);
            } else {
              return null;
            }
          },
        ).pSymmetric(v: 10, h: 20));
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = barCodeController.text.trim();
        if (mobText.isEmpty || mobText.length != 14 ) {
          return context.l10n.please_enter_ticket_number;
        }
        break;
      case TotalTextFields.password:
        var passText = ticketCountController.text.trim();
        if (passText.isEmpty ||  int.parse(passText) <  1 || int.parse(passText) > maxTicketInSeries) {
          return context.l10n.please_enter_valid_ticket_count;
        }
        break;
    }
    return "";
  }

  _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isGenerateOtpButtonPressed = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            isGenerateOtpButtonPressed = false;
          });
        });
        if ((ticketNumberList.isNotEmpty && !isSeries)  ||
            _loginForm.currentState!.validate()) {
          var userName = barCodeController.text.trim();
          setState(() {
            mAnimatedButtonSize = 50.0;
            mButtonTextVisibility = false;
            mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
          });
          if (ticketNumberList.isNotEmpty ||
              barCodeController.text.trim().contains('-')) {
            if (barCodeController.text.isNotEmpty &&
                barCodeController.text != '') {
              if(ticketNumberList.contains(barCodeController.text)){

              } else {
                ticketNumberList.add(barCodeController.text);
              }
            }
            if(isSeries){
              BlocProvider.of<SaleTicketBloc>(context).add(
                  SaleTicketApi(
                      context: context,
                      scratchList: widget.scratchList,
                      fromTicket: barCodeController.text,
                      toTicket: getToTicket(barCodeController.text, ticketCountController)
                  ));
            }else{
              BlocProvider.of<SaleTicketBloc>(context).add(
                SaleTicketApi(
                  context: context,
                  scratchList: widget.scratchList,
                  ticketNumberList: ticketNumberList,
                ),
              );
            }
          } else {
            /* BlocProvider.of<PackBloc>(context).add(
                GameListApi(context: context, scratchList: widget.scratchList));*/
          }
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: LongaLottoPosColor.medium_green,
              borderRadius: BorderRadius.circular(buttonBorder)),
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
                height: 50,
                child: mButtonShrinkStatus == ButtonShrinkStatus.started
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            color: LongaLottoPosColor.white_two),
                      )
                    : Center(
                        child: Visibility(
                        visible: mButtonTextVisibility,
                        child: Text(
                          context.l10n.proceed,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: LongaLottoPosColor.white,
                          ),
                        ),
                      ))),
          )).pOnly(top: 10),
    );
  }

  _addTicketButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isGenerateOtpButtonPressed = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            isGenerateOtpButtonPressed = false;
          });
        });
        if (_loginForm.currentState!.validate()) {
          var ticketNumber = barCodeController.text.trim();
          setState(() {
            addAnimatedButtonSize = 50.0;
            addButtonTextVisibility = false;
            addButtonShrinkStatus = ButtonShrinkStatus.notStarted;
          });
          if(ticketNumberList.contains(ticketNumber)){
            ShowToast.showToast(context, context.l10n.ticket_number_has_already_been_added,type: ToastType.ERROR);
          } else {
            ticketNumberList.add(ticketNumber);
          }
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isLoading = false;
              addAnimatedButtonSize = 140.0;
              addButtonTextVisibility = true;
              addButtonShrinkStatus = ButtonShrinkStatus.over;
              barCodeController.clear();
            });
          });
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: LongaLottoPosColor.white,
            borderRadius: BorderRadius.circular(buttonBorder),
            border: Border.all(color: LongaLottoPosColor.medium_green),
          ),
          child: AnimatedContainer(
            width: addAnimatedButtonSize,
            height: 50,
            onEnd: () {
              setState(() {
                if (addButtonShrinkStatus != ButtonShrinkStatus.over) {
                  addButtonShrinkStatus = ButtonShrinkStatus.started;
                } else {
                  addButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                }
              });
            },
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
                width: addAnimatedButtonSize,
                height: 50,
                child: addButtonShrinkStatus == ButtonShrinkStatus.started
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            color: LongaLottoPosColor.white_two),
                      )
                    : Center(
                        child: Visibility(
                        visible: addButtonTextVisibility,
                        child: Text(
                          context.l10n.add_ticket,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: LongaLottoPosColor.medium_green,
                          ),
                        ),
                      ))),
          )).pOnly(top: 10),
    );
  }

  _numberOfTicketSelection() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          width: 200,
          height: 50,
          child: ShakeWidget(
            controller: numOfTicketShakeController,
            child: LongaPosTextFieldUnderline(
              textAlign: TextAlign.center,
              isDense: true,
              maxLength: 3,
              maxLine: 1,
              inputType: TextInputType.number,
              controller: ticketCountController,
              underLineType: false,
              contentPadding: const EdgeInsets.all(8),
              validator: (value) {
                if (validateInput(TotalTextFields.password).isNotEmpty) {
                  //ticketCountController.text = "1";
                  //if (isGenerateOtpButtonPressed) {
                    numOfTicketShakeController.shake();
                //  }
                  return validateInput(TotalTextFields.password);
                } else {
                  return null;
                }
              },
              onChanged: (value){
                log("chandra  value = $value");
                log("value is not empty ${value.isNotEmpty}");
                if(value.isNotEmpty) {
                  setState(() {
                    ticketCountController.text = value;
                  });
                  ticketCountController.selection =
                      TextSelection.collapsed(offset: ticketCountController.text.length);
                }
              },
            ),
          )),
    ).pOnly(right: 8, bottom: 10);
  }

  String formatTicketNumber(String data) {
    String part1 = data.substring(0, 3);
    String part2 = data.substring(3, 9);
    String part3 = data.substring(9, 12);

    return '$part1-$part2-$part3';
  }

  String getToTicket(String text, TextEditingController ticketCountController) {
    log("isSeries : $isSeries");
    log("ticketCountController.text.isEmpty : ${ticketCountController.text.isEmpty}");
    log("isSeries : $isSeries");
    if((isSeries && ticketCountController.text.isEmpty) || barCodeController.text.length < 14){
      return text;
    }
    String ticketNumberText = text.replaceAll('-', '');
    int ticketNumberInt = int.parse(ticketNumberText);
    int ticketCount = int.parse(ticketCountController.text);
    String toTicketNumber = (ticketNumberInt + ticketCount -1).toString();
    String formattedTicketNumber = formatTicketNumber(toTicketNumber);

    return formattedTicketNumber;
  }
}
