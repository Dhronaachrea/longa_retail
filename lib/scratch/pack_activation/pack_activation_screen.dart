import 'dart:async';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_event.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_state.dart';
import 'package:longalottoretail/scratch/pack_activation/model/game_list_response.dart';
import 'package:longalottoretail/scratch/pack_activation/model/pack_activation_request.dart';
import 'package:longalottoretail/scratch/pack_activation/model/pack_activation_response.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_scaffold.dart';
import 'package:longalottoretail/utility/widgets/longa_pos_text_field_underline.dart';
import 'package:longalottoretail/utility/widgets/scanner_error.dart';
import 'package:longalottoretail/utility/widgets/shake_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utility/widgets/alert_type.dart';

class PackActivationScreen extends StatefulWidget {
  MenuBeanList? scratchList;
  PackActivationScreen({Key? key, required this.scratchList}) : super(key: key);

  @override
  State<PackActivationScreen> createState() => _PackActivationScreenState();
}

class _PackActivationScreenState extends State<PackActivationScreen> {

  TextEditingController barCodeController = TextEditingController();
  ShakeController barCodeShakeController = ShakeController();
  bool isGenerateOtpButtonPressed = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  double mAnimatedButtonSize = 280.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
 // final ScanController _scanController = ScanController();
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
        appBarTitle: widget.scratchList?.caption ?? context.l10n.pack_activation,
        body: BlocListener<PackBloc, PackState>(
          listener: (context, state) {
            if (state is PackLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is GameListSuccess) {
              GameListResponse gameListResponse = state.response;
              setState(() {
                isLoading = false;
              });
              List<String>? bookNumberList = [];
              List<String>? packNumberList = [];
              bookNumberList.add(getBookNumber(barCodeController.text, gameListResponse));
              // for(var bookNumberData in gameListResponse.games!)
              // {
              //   bookNumberList.add(bookNumberData.bookNumberDigits.toString());
              //   packNumberList.add(bookNumberData.packNumberDigits.toString());
              // }

              var requestData = PackActivationRequest(
                  bookNumbers: bookNumberList,
                  gameType: 'SCRATCH',
                  packNumbers: packNumberList,
                  userName: UserInfo.userName,
                  userSessionId: UserInfo.userToken
              );

              BlocProvider.of<PackBloc>(context).add(PackActivationApi(
                  context: context,
                  scratchList: widget.scratchList,
                  requestData: requestData
              ));
            }
            if( state is PackActivationSuccess) {
              PackActivationResponse packActivationResponse = state.response;
              setState(() {
                isLoading = false;
                mAnimatedButtonSize = 280.0;
                mButtonTextVisibility = true;
                mButtonShrinkStatus = ButtonShrinkStatus.over;
              });
              Alert.show(
                type: AlertType.success,
                isDarkThemeOn: false,
                buttonClick: () {
                  Navigator.of(context).pop();
                },
                title: context.l10n.success,
                subtitle: packActivationResponse.responseCode == 1000 ? context.l10n.book_activated_successfully : packActivationResponse.responseMessage!,
                buttonText: context.l10n.ok.toUpperCase(),
                context: context,
              );
            }
            if (state is PackError) {
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
                    child: MobileScanner(  errorBuilder: (context, error, child) {
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
                    //   scanLineColor: BrLottoPosColor.tomato,
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
    );
  }

  barCodeTextField() {
    return ShakeWidget(
        controller: barCodeShakeController,
        child: LongaPosTextFieldUnderline(
          maxLength: 10,
          inputType: TextInputType.number,
          inputFormatters: [
            // FilteringTextInputFormatter.allow(RegExp('[0-9-]+')),
            maskFormatter
          ],
          hintText: context.l10n.book_number,
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
          return context.l10n.please_enter_book_number;
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
          BlocProvider.of<PackBloc>(context).add(GameListApi(
            context: context,
            scratchList: widget.scratchList,
          ));
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [
                    LongaLottoPosColor.medium_green,
                    LongaLottoPosColor.medium_green,
                  ]
              ),
              borderRadius: BorderRadius.circular(10)),
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

  String getBookNumber(String scanText, GameListResponse gameListResponse)
  {
    int gameNumberLength = gameListResponse.games![0].gameNumber.toString().length;
    int bookNumberDigits = gameListResponse.games![0].bookNumberDigits;
    String textValue = '';
    if(scanText.contains('-'))
      {
        textValue = scanText;
      }
    else
      {
        if(scanText.length <= 9)
        {
          textValue = scanText.substring(0, gameNumberLength) + "-" + scanText.substring(3, scanText.length );
        }
        else
        {
          textValue = scanText.substring(0, gameNumberLength) + "-" + scanText.substring(3, gameNumberLength * bookNumberDigits) + "-" + scanText.substring(gameNumberLength + bookNumberDigits, scanText.length);
        }
      }
    return textValue;
  }

}
