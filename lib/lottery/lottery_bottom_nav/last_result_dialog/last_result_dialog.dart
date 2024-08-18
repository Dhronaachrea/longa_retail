import 'dart:convert';
import 'dart:developer';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utility/UrlDrawGameBean.dart';

class LastResultDialog extends StatefulWidget {
  List<GameRespVOs> lotteryGameObjectList;
  GlobalKey<LastResultDialogState> dialogKey;
  final Function(
      UrlDrawGameBean? apiUrlDetails ,
      String fromDateTime,
      String toDateTime,
      String gameCode
      ) mCallBack ;

  LastResultDialog({Key? key,required this.lotteryGameObjectList, required this.mCallBack, required this.dialogKey}) : super(key: key);

  @override
  State<LastResultDialog> createState() => LastResultDialogState();
}

class LastResultDialogState extends State<LastResultDialog> {
  String selectedGameName = "";
  String selectedGameCode = "";
  String selectedDate     = "";
  String selectedFromTime = "";
  String selectedToTime   = "";
  UrlDrawGameBean? resultUrlsDetails;
  List<String> lotteryGameCodeList = [];
  bool mIsLoading = false;

  @override
  void initState() {

    ModuleBeanLst? drawerModuleBeanList = ModuleBeanLst.fromJson(jsonDecode(UserInfo.getDrawGameBeanList));
    MenuBeanList? rePrintApiDetails = drawerModuleBeanList.menuBeanList?.where((element) => element.menuCode == "DGE_RESULT_LIST").toList()[0];
    resultUrlsDetails = getDrawGameUrlDetails(rePrintApiDetails!, context, "getSchemaByGame");

    if (widget.lotteryGameObjectList.isNotEmpty) {
      selectedGameName = widget.lotteryGameObjectList[0].gameName ?? "";
      selectedGameCode = widget.lotteryGameObjectList[0].gameCode ?? "";
    }

    for (GameRespVOs gameResp in widget.lotteryGameObjectList) {
      if (gameResp.gameCode?.isNotEmpty == true ) {
        lotteryGameCodeList.add(gameResp.gameCode ?? "");
      }
    }
    super.initState();
  }

  updateUi(bool isLoading) {
    log("-------------------------- updateUi ---------------------> $isLoading ----- ");
    setState(() {
      mIsLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: widget.dialogKey,
      elevation: 5.0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 1.0),
      backgroundColor: LongaLottoPosColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                color: Colors.blue,
              ),
              child: const Text(
                "Result",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ).p(15),
            ),
            SizedBox( // for game options
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.lotteryGameObjectList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 3.6,
                    height: 90,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: (selectedGameName == widget.lotteryGameObjectList[index].gameName) ? LongaLottoPosColor.warm_grey : LongaLottoPosColor.white,
                        boxShadow: const [
                          BoxShadow(
                            color: LongaLottoPosColor.warm_grey_six,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            print("tap on index $index");
                            print("tap on game name ${widget.lotteryGameObjectList[index].gameName.toString()}");
                            selectedGameName = widget.lotteryGameObjectList[index].gameName.toString();
                            selectedGameCode = widget.lotteryGameObjectList[index].gameCode.toString();
                          });
                        },
                        child: Ink(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  width : 50,
                                  height: 50,
                                  lotteryGameCodeList.contains(widget.lotteryGameObjectList[index].gameCode)
                                      ? "assets/icons/${widget.lotteryGameObjectList[index].gameCode}.png"
                                      : "assets/images/splash_logo.png"
                              ),
                              Flexible(
                                child: Text(
                                    widget.lotteryGameObjectList[index].gameName ?? "NA",
                                    maxLines: 2 ,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: LongaLottoPosColor.black,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ),
                            ],
                          ).p(5),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
            const Divider(color: LongaLottoPosColor.orangey_red_two,thickness: 3,),
            Text(
              (selectedGameName == "") ? "" : "Select DATE to print $selectedGameName result",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13
              ),
            ).pOnly(top: 10),
            Column(
              children: [
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Select Date',
                  ),
                  firstDate: DateTime.parse("2000-01-01 00:00:00"),
                  lastDate: DateTime.now().add(const Duration(days: 0)),
                  initialDate: DateTime.now().add(const Duration(days: 0)),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (DateTime? e) {
                    print("------------->$e");
                    (e?.day ?? 0) == 1 ? '' : null;
                  },
                  onDateSelected: (DateTime value) {
                    setState(() {
                      print("selected Date --------------> ${value.day}");
                      selectedDate = value.toString().split(" ")[0];
                    });
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeFormField(
                        use24hFormat: false,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time_rounded),
                            label: Text(
                              "From Time",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            )
                        ),
                        mode: DateTimeFieldPickerMode.time,
                        autovalidateMode: AutovalidateMode.always,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            selectedFromTime = value.toString().split(".")[0];
                            print("from time -------------> $selectedFromTime");
                          });
                        },
                      ),
                    ),
                    const Text("-", style: TextStyle(fontSize:30, fontWeight: FontWeight.w300),).p(10),
                    Expanded(
                      child: DateTimeFormField(
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time_rounded),
                            label: Text(
                              "To Time",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            )
                        ),

                        mode: DateTimeFieldPickerMode.time,
                        initialDatePickerMode: DatePickerMode.day,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            selectedToTime = value.toString().split(".")[0];
                            print("to time -------------> $selectedToTime");
                          });;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                            // call result api
                          if (selectedDate.isNotEmpty  && selectedToTime.isNotEmpty && selectedFromTime.isNotEmpty) {
                            widget.mCallBack(
                                resultUrlsDetails,
                                selectedFromTime,
                                selectedToTime,
                                selectedGameCode
                            );
                          } else {
                            ShowToast.showToast(context, "Please Select Date & Time.", type: ToastType.ERROR);
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: LongaLottoPosColor.reddish_pink
                          ),
                          child: const Text("SHOW RESULT", style: TextStyle(color: LongaLottoPosColor.white),textAlign: TextAlign.center,).p(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Ink(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: LongaLottoPosColor.reddish_pink
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Text("CANCEL", style: TextStyle(color: LongaLottoPosColor.reddish_pink),textAlign: TextAlign.center,).p(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ).pOnly(left: 12, right: 12, top: 16)
          ],
        ).pOnly(bottom: 20),
      ),
    );
  }
}
