import 'dart:async';

import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/utility/widgets/longa_pos_text_field_underline.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_bloc.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_event.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_state.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/shake_animation.dart';

import '../../utility/widgets/scanner_error.dart';
import 'model/response/ticket_claim_response.dart';
import 'model/response/ticket_validation_response.dart';

class TicketValidationAndClaimScreen extends StatefulWidget {
  MenuBeanList? scratchList;
  TicketValidationAndClaimScreen({Key? key, required this.scratchList}) : super(key: key);

  @override
  State<TicketValidationAndClaimScreen> createState() => _TicketVState();
}

class _TicketVState extends State<TicketValidationAndClaimScreen> {

  TextEditingController barCodeController = TextEditingController();
  ShakeController barCodeShakeController = ShakeController();
  bool isGenerateOtpButtonPressed = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  double mAnimatedButtonSize = 280.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  final MobileScannerController _scanController = MobileScannerController(autoStart: true);
  var isLoading = false;

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LongaScaffold(
        appBackGroundColor: LongaLottoPosColor.app_bg,
        backgroundColor: LongaLottoPosColor.white,
        resizeToAvoidBottomInset: false,
        showAppBar: true,
        appBarTitle: widget.scratchList?.caption ?? context.l10n.ticket_validation_and_claim,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is GetLoginDataSuccess) {
              if (state.response != null) {
                BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(loginDataResponse: state.response!));
              }
            } else if (state is GetLoginDataError) {

            }
          },
          child: BlocListener<TicketValidationAndClaimBloc, TicketValidationAndClaimState>(
            listener: (context, state) {
              if (state is TicketValidationAndClaimLoading || state is TicketClaimLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is TicketValidationAndClaimSuccess) {
                TicketValidationResponse response = state.response;
                if(verifyWinSuccessErrorCodes.contains(response.responseCode)){
                  setState(() {
                    isLoading = false;
                    mAnimatedButtonSize = 280.0;
                    mButtonTextVisibility = true;
                    mButtonShrinkStatus = ButtonShrinkStatus.over;
                    barCodeController.clear();
                  });
                  if(verifyWinOopsErrorCodes.contains(response.responseCode)){
                    Alert.show(
                      type: AlertType.oops,
                      isDarkThemeOn: false,
                      buttonClick: () {
                        _scanController.start();
                      },
                      title: context.l10n.oops,
                      subtitle: loadLocalizedData("SCRATCH_${response.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? response.responseMessage ?? "",//response.responseMessage??"",
                      buttonText: context.l10n.ok.toUpperCase(),
                      context: context,
                    );
                  } else {
                    Alert.show(
                      type: AlertType.success,
                      isDarkThemeOn: false,
                      buttonClick: () {
                        _scanController.start();
                      },
                      title: context.l10n.success,
                      subtitle: loadLocalizedData("SCRATCH_${response.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? response.responseMessage ?? "",//response.responseMessage??"",
                      buttonText: context.l10n.ok.toUpperCase(),
                      context: context,
                    );
                  }
                } else {
                  Alert.show(
                    type: AlertType.confirmation,
                    isDarkThemeOn: false,
                    isCloseButton: true,
                    buttonClick: () {
                      BlocProvider.of<TicketValidationAndClaimBloc>(context).add(TicketClaimApi(context: context, scratchList: widget.scratchList, barCodeText: barCodeController.text.trim()));
                    },
                    closeButtonClick: (){
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                    title: context.l10n.claim_ticket.toUpperCase(),
                    subtitle: "",
                    buttonText: context.l10n.claim.toUpperCase(),
                    otherData: response.responseCode == 1000 ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [
                        //Ticket number
                        const HeightBox(5),
                        Opacity(
                          opacity : 0.5,
                          child:Text(
                              context.l10n.ticket_number,
                              style: const TextStyle(
                                  color:  LongaLottoPosColor.brownish_grey_three,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                        ),
                        const HeightBox(2),
                        Text(
                            state.response.ticketNumber ?? "",
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                        //Winning amount
                        const HeightBox(5),
                        Opacity(
                          opacity : 0.5,
                          child:Text(
                              context.l10n.winning_amount,
                              style: const TextStyle(
                                  color:  LongaLottoPosColor.brownish_grey_three,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                        ),
                        const HeightBox(2),
                        Text(
                            ( state.response.winningAmount ?? "0").toString(),
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                        //Tax amount
                        const HeightBox(5),
                        Opacity(
                          opacity : 0.5,
                          child:Text(
                              context.l10n.tax_amount,
                              style: const TextStyle(
                                  color:  LongaLottoPosColor.brownish_grey_three,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                        ),
                        const HeightBox(2),
                        Text(
                            ( state.response.taxAmount ?? "0").toString(),
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                        //Net Winning Amount
                        Opacity(
                          opacity : 0.5,
                          child:Text(
                              context.l10n.net_winning_amount,
                              style: const TextStyle(
                                  color:  LongaLottoPosColor.brownish_grey_three,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                        ),
                        const HeightBox(2),
                        Text(
                            state.response.netWinningAmount.toString() ?? "",
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                        const HeightBox(5),
                      ],
                    )
                        : Container(),
                    context: context,
                  );
                }

              }
              if (state is TicketClaimSuccess) {
                TicketClaimResponse response = state.response;
                setState(() {
                  isLoading = false;
                });
                BlocProvider.of<LoginBloc>(context).add(GetLoginDataApi(context: context));
                Alert.show(
                  type: AlertType.success,
                  isDarkThemeOn: false,
                  buttonClick: () {
                    _scanController.start();
                    Navigator.of(context).pop();
                  },
                  title: context.l10n.success,
                  subtitle: response.responseMessage ?? "Success",
                  buttonText: context.l10n.ok.toUpperCase(),
                  otherData: response.responseCode == 1000?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      //Invoice number
                      Opacity(
                        opacity : 0.5,
                        child:Text(
                            context.l10n.invoice_number,
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      const HeightBox(2),
                      Text(
                          state.response.transactionNumber ?? "",
                          style: const TextStyle(
                              color:  LongaLottoPosColor.brownish_grey_three,
                              fontWeight: FontWeight.w500,
                              fontFamily: "",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                          textAlign: TextAlign.left
                      ),
                      //Invoice Date
                      const HeightBox(5),
                      Opacity(
                        opacity : 0.5,
                        child:Text(
                            context.l10n.invoice_date,
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      const HeightBox(2),
                      Text(
                          response.transactionDate ?? "",
                          style: const TextStyle(
                              color:  LongaLottoPosColor.brownish_grey_three,
                              fontWeight: FontWeight.w500,
                              fontFamily: "",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                          textAlign: TextAlign.left
                      ),
                      //Ticket number
                      const HeightBox(5),
                      Opacity(
                        opacity : 0.5,
                        child:Text(
                            context.l10n.ticket_number,
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      const HeightBox(2),
                      Text(
                          state.response.ticketNumber ?? "",
                          style: const TextStyle(
                              color:  LongaLottoPosColor.brownish_grey_three,
                              fontWeight: FontWeight.w500,
                              fontFamily: "",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                          textAlign: TextAlign.left
                      ),
                      //Winning amount
                      const HeightBox(5),
                      Opacity(
                        opacity : 0.5,
                        child:Text(
                            context.l10n.winning_amount,
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      const HeightBox(2),
                      Text(
                          ( state.response.winningAmount ?? "0").toString(),
                          style: const TextStyle(
                              color:  LongaLottoPosColor.brownish_grey_three,
                              fontWeight: FontWeight.w500,
                              fontFamily: "",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                          textAlign: TextAlign.left
                      ),
                      //Tax amount
                      const HeightBox(5),
                      Opacity(
                        opacity : 0.5,
                        child:Text(
                            context.l10n.tax_amount,
                            style: const TextStyle(
                                color:  LongaLottoPosColor.brownish_grey_three,
                                fontWeight: FontWeight.w500,
                                fontFamily: "",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      const HeightBox(2),
                      Text(
                          ( state.response.taxAmount ?? "0").toString(),
                          style: const TextStyle(
                              color:  LongaLottoPosColor.brownish_grey_three,
                              fontWeight: FontWeight.w500,
                              fontFamily: "",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                          textAlign: TextAlign.left
                      ),
                      const HeightBox(5),
                    ],
                  )
                      : Container(),
                  context: context,
                );
              }
              if (state is TicketValidationAndClaimError) {
                setState(() {
                  isLoading = false;
                  mAnimatedButtonSize = 280.0;
                  mButtonTextVisibility = true;
                  mButtonShrinkStatus = ButtonShrinkStatus.over;
                  barCodeController.clear();
                });
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
              if (state is TicketClaimError) {
                setState(() {
                  isLoading = false;
                  mAnimatedButtonSize = 280.0;
                  mButtonTextVisibility = true;
                  mButtonShrinkStatus = ButtonShrinkStatus.over;
                  barCodeController.clear();
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
            },
            child: SingleChildScrollView(
              child: Form(
                key: _loginForm,
                autovalidateMode: autoValidate,
                child: Column(
                  children: <Widget>[
                    barCodeTextField(),
                    SizedBox(
                      height: 400,
                      child: MobileScanner(
                        errorBuilder: (context, error, child) {
                          return ScannerError(
                            context: context,
                            error: error,
                          );
                        },
                        controller: _scanController,
                        onDetect: (capture) {
                          try{
                            final List<Barcode> barcodes = capture.barcodes;
                            String? data = barcodes[0].rawValue;
                            if( data != null){
                              setState(() {
                                barCodeController.text = data;
                              });
                            }
                          } catch(e){
                            print("Something Went wrong with bar code: $e");
                          }
                        },),
                      // ScanView(
                      //   controller: _scanController,
                      //   scanAreaScale: .7,
                      //   scanLineColor: LongaLottoPosColor.tomato,
                      //   onCapture: (data) {
                      //     setState(() {
                      //       barCodeController.text = data;
                      //     });
                      //     // BlocProvider.of<QrScanBloc>(context).add(GetQrScanDataApi(context: context));
                      //   },
                      // ),
                    ),
                    _submitButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  barCodeTextField() {
    return ShakeWidget(
        controller: barCodeShakeController,
        child: LongaPosTextFieldUnderline(
          maxLength: 16,
          inputType: TextInputType.text,
          hintText: context.l10n.barcode_number ?? "Barcode Number",
          controller: barCodeController,
          underLineType: false,
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
        ).p20()
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = barCodeController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_barCode_number;
        }
        break;
      case TotalTextFields.password:
      // TODO: Handle this case.
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
        if (_loginForm.currentState!.validate()) {
          setState(() {
            mAnimatedButtonSize = 50.0;
            mButtonTextVisibility = false;
            mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
          });
          BlocProvider.of<TicketValidationAndClaimBloc>(context).add(TicketValidationAndClaimApi(context: context, scratchList: widget.scratchList, barCodeText: barCodeController.text.trim()));
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
          )).pOnly(top: 30),
    );
  }

}
