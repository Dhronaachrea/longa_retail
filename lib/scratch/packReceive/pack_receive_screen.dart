import 'dart:async';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/utility/widgets/longa_pos_text_field_underline.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_event.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_state.dart';
import 'package:longalottoretail/scratch/packReceive/model/book_receive_request.dart';
import 'package:longalottoretail/scratch/packReceive/model/book_receive_response.dart';
import 'package:longalottoretail/scratch/packReceive/model/dl_details_response.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/shake_animation.dart';

import '../../utility/widgets/scanner_error.dart';

class PackReceiveScreen extends StatefulWidget {
  final MenuBeanList? scratchList;

  const PackReceiveScreen({Key? key, required this.scratchList})
      : super(key: key);

  @override
  State<PackReceiveScreen> createState() => _PackReceiveScreenState();
}

class _PackReceiveScreenState extends State<PackReceiveScreen> {
  TextEditingController barCodeController = TextEditingController();
  ShakeController barCodeShakeController = ShakeController();
  bool isGenerateOtpButtonPressed = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  double mAnimatedButtonSize = 280.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;

  //final ScanController _scanController = ScanController();
  final MobileScannerController _scanController =
      MobileScannerController(autoStart: true);
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
        // centerTitle: false,
        appBarTitle: widget.scratchList?.caption ?? context.l10n.pack_received,
        body: BlocListener<PackBloc, PackState>(
          listener: (context, state) {
            if (state is PackLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is DlDetailsSuccess) {
              DlDetailsResponse dlDetailsResponse = state.response;
              setState(() {
                isLoading = false;
              });
              List<String>? bookList = [];
              List<BookInfo>? bookInfo = <BookInfo>[];
              BookReceiveRequest bookReceiveRequest = BookReceiveRequest();
              for(var gameWiseDetail in dlDetailsResponse.gameWiseDetails!){
                for (var bookInfoData
                in gameWiseDetail.bookList!) {
                  if (bookInfoData.status == "IN_TRANSIT") {
                    bookList?.add(bookInfoData.bookNumber!);
                  }
                }
                if(bookList != null && bookList.isNotEmpty){
                  bookInfo.add(BookInfo(
                      bookList: bookList,
                      gameId: gameWiseDetail.gameId,
                      gameType: 'SCRATCH'));
                }
                bookList = [];
              }
              var requestData = BookReceiveRequest(
                  bookInfo: bookInfo,
                  // dlChallanId: 1,
                  dlChallanNumber: dlDetailsResponse.dlNumber,
                  receiveType: 'RECEIVED',
                  userName: UserInfo.userName,
                  userSessionId: UserInfo.userToken);

              BlocProvider.of<PackBloc>(context).add(BookReceiveApi(
                  context: context,
                  scratchList: widget.scratchList,
                  requestData: requestData));
              // Alert.show(
              //   isDarkThemeOn: false,
              //   buttonClick: () {
              //     Navigator.of(context).pop();
              //   },
              //   title: 'Success!',
              //   subtitle: dlDetailsResponse.responseMessage!,
              //   buttonText: 'ok'.toUpperCase(),
              //   context: context,
              // );
            }
            if (state is BookReceiveSuccess) {
              BookReceiveResponse bookReceiveResponse = state.response;
              setState(() {
                isLoading = false;
                mAnimatedButtonSize = 280.0;
                mButtonTextVisibility = true;
                mButtonShrinkStatus = ButtonShrinkStatus.over;
                barCodeController.clear();
              });
              Alert.show(
                type: AlertType.success,
                isDarkThemeOn: false,
                buttonClick: () {
                  Navigator.of(context).pop();
                },
                title: context.l10n.success,
                subtitle: bookReceiveResponse.responseMessage!,
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
                    child: MobileScanner(
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
                          String? data = barcodes[0].rawValue;
                          if (data != null) {
                            setState(() {
                              barCodeController.text = data;
                            });
                          }
                        } catch (e) {
                          print("Something Went wrong with bar code: $e");
                        }
                      },
                    ),
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
    );
  }

  barCodeTextField() {
    return ShakeWidget(
        controller: barCodeShakeController,
        child: LongaPosTextFieldUnderline(
          maxLength: 18,
          //inputType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]+')),],
          hintText: context.l10n.challan_number,
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
        ).p20());
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = barCodeController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_challan_number;
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
          BlocProvider.of<PackBloc>(context).add(DlDetailsApi(
              context: context,
              scratchList: widget.scratchList,
              barCodeText: barCodeController.text.trim()));
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                LongaLottoPosColor.medium_green,
                LongaLottoPosColor.medium_green,
              ]),
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
}
