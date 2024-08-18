import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/lottery/bloc/lottery_bloc.dart';
import 'package:longalottoretail/lottery/bloc/lottery_state.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';

typedef GameResponseCallback = void Function(String date);

class MyTimerLottery extends StatefulWidget {
  MyTimerLottery(
      {Key? key,
        required this.callback,
        required this.currentDateTime,
        required this.drawDateTime,
        required this.gameType,  this.gameName})
      : super(key: key);

  final GameResponseCallback callback;
  String? gameType;
  DateTime? drawDateTime;
  DateTime? currentDateTime;
  String? gameName;

  @override
  State<MyTimerLottery> createState() => _MyTimerLotteryState();
}

class _MyTimerLotteryState extends State<MyTimerLottery> {
  static const duration = Duration(seconds: 1);
  DateTime drawDate = DateTime(0);
  var timeDiff = 0.toSigned(64);
  bool isApiReadyToCall = true;

  Timer timer = Timer(duration, () {});


  // Repository repository = Repository();

  @override
  void initState() {
    super.initState();
    initlizeTimer(widget.drawDateTime!, widget.currentDateTime!);
    // _callDge();
  }

  _handleTick() {
    if (!mounted) return;
    setState(() {
      if (timeDiff > 0) {
        if (drawDate != widget.currentDateTime) {
          timeDiff = timeDiff - 1;
        }
      } else {
        if (isApiReadyToCall) {
          print('Times up!');
          isApiReadyToCall = false;
          widget.callback("");
        } else {
          if (timeDiff == 0) {
            isApiReadyToCall = true;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<GameRespVOs> lotteryGameObjectList   = [];

    int days = timeDiff ~/ (24 * 60 * 60) % 24;
    int hours = timeDiff ~/ (60 * 60) % 24;
    int minutes = (timeDiff ~/ 60) % 60;
    int seconds = timeDiff % 60;

    String strDays = (days == 0) ? '' : '${days.toString().padLeft(2, '0')} D : ';
    String strHours = (hours == 0) ? '' : '${hours.toString().padLeft(2, '0')} H : ';
    String strMinutes = ((days == 0) && (hours ==0) && (minutes == 0)) ? "" : '${minutes.toString().padLeft(2, '0')} M : ';
    String strSeconds = '${seconds.toString().padLeft(2, '0')} S';
    return BlocListener<LotteryBloc, LotteryState>(
      listener: (context, state) {
        if (state is FetchGameSuccess) {
          setState(() {
            lotteryGameObjectList = state.response.responseData?.gameRespVOs ?? [];
            for (var gameList in lotteryGameObjectList) {
              if (widget.gameName == gameList.gameName) {
                initlizeTimer(DateTime.parse(gameList.drawRespVOs?[0].drawSaleStopTime ?? "2023-03-30 13:44:45") , DateTime.parse(state.response.responseData?.currentDate ?? "2023-03-30 13:44:45"));
              }
            }
          });
        }
      },
      child: (timeDiff == 0)
          ? Text(context.l10n.updating,
                style:  const TextStyle(
                    color: LongaLottoPosColor.warm_grey_three,
                    fontWeight: FontWeight.w300,
                    fontSize: 12
                )
            )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.bet_closes_in,
              style: const TextStyle(
                  color: LongaLottoPosColor.warm_grey_three,
                  fontWeight: FontWeight.w300,
                  fontSize: 12
              )
          ),
          Text(
            '$strDays$strHours$strMinutes$strSeconds',
            style: const TextStyle(
                color: LongaLottoPosColor.black,
                fontWeight: FontWeight.w700,
                fontSize: 12
            ),
            textAlign: TextAlign.left,
          ).pOnly(top: 6),
        ],
      ).pOnly(top: 8)
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void initlizeTimer(DateTime? drawDateTime, DateTime? currentDateTime) {
    try {
      drawDate = drawDateTime!;
      timeDiff = drawDate.difference(currentDateTime!).inSeconds;
    } catch (e) {
      log("Exception Draw Date time @ initState : $e");
    }
    timer.cancel();
    timer = Timer.periodic(duration, (Timer t) {
      _handleTick();
    });
  }
}
