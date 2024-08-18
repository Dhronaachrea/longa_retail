import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/date_format.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:velocity_x/velocity_x.dart';

/*class DrawResult extends StatefulWidget {
  Content? contentValue;

  DrawResult({Key? key, this.contentValue}) : super(key: key);

  @override
  _DrawResultState createState() => _DrawResultState();
}

class _DrawResultState extends State<DrawResult> {
  List<OneXTwo>? oneXTwo;
  List<OneXTwo>? tossWinner;

  @override
  Widget build(BuildContext context) {
    oneXTwo = widget.contentValue!.marketWiseEventList.oneXTwo;
    tossWinner = widget.contentValue!.marketWiseEventList.tossWinner;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: context.screenWidth * 0.46,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: LongaLottoPosColor.white_two.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Draw Time',
                        style: TextStyle(
                            color: LongaLottoPosColor.brownish_grey,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                    Text(
                        formatDate(
                          date: widget.contentValue!.drawDate.toString() ??
                              '14:30',
                          inputFormat: Format.apiDateFormat2,
                          outputFormat: Format.dateFormat11,
                        ),
                        style: const TextStyle(
                            color: LongaLottoPosColor.brownish_grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                  ],
                )),
            Container(
                width: context.screenWidth * 0.46,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: LongaLottoPosColor.white_two.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Draw No',
                        style: TextStyle(
                            color: LongaLottoPosColor.brownish_grey,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                    Text('${widget.contentValue!.drawNo}',
                        style: const TextStyle(
                            color: LongaLottoPosColor.brownish_grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                  ],
                )),
          ],
        ).pOnly(left: 10, right: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: LongaLottoPosColor.white_two, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: LongaLottoPosColor.white_two.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: const Text('Draw Result',
                      style: TextStyle(
                          color: LongaLottoPosColor.brownish_grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0))),
              Container(
                // alignment: Alignment.center,
                height: 62,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(oneXTwo![0].marketName),
                          Expanded(
                            child: ListView.builder(
                                itemCount: oneXTwo!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                      border: Border.all(
                                          color: LongaLottoPosColor.white_two, width: 1),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            color: LongaLottoPosColor.white_two,
                                            width: 25,
                                            child: Text(oneXTwo![index].eventId,
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.brownish_grey,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: "Roboto",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0))),
                                        Container(
                                          width: 25,
                                          height: 1,
                                          color: LongaLottoPosColor.white_two,
                                        ),
                                        Container(
                                            width: 25,
                                            alignment: Alignment.center,
                                            child: Text(
                                                getResultFirstLetter(
                                                    oneXTwo![index].result),
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: "Roboto",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                maxLines: 1)),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tossWinner![0].marketName),
                          Expanded(
                            child: ListView.builder(
                                itemCount: tossWinner!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                      border: Border.all(
                                          color: LongaLottoPosColor.white_two, width: 1),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            color: LongaLottoPosColor.white_two,
                                            width: 25,
                                            child: Text(tossWinner![index].eventId,
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.brownish_grey,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: "Roboto",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0))),
                                        Container(
                                          width: 25,
                                          height: 1,
                                          color: LongaLottoPosColor.white_two,
                                        ),
                                        Container(
                                            width: 25,
                                            alignment: Alignment.center,
                                            child: Text(
                                                getResultFirstLetter(
                                                    tossWinner![index].result),
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: "Roboto",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                maxLines: 1)),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ).pOnly(left: 10, right: 10),
      ],
    );
  }

  String getResultFirstLetter(Result1 result) {
    if (result.name.isNotEmpty) {
      return result.name[0];
    } else {
      return '';
    }
  }
}*/
