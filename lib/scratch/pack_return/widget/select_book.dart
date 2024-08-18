import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/scratch/pack_return/model/book_and_pack_model.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

import '../model/bookSelectionDetailModel.dart';

class SelectBook {
  show({
    required BuildContext context,
    required String title,
    required String buttonText,
    required List<TotalBook> totalBook,
    bool? isBackPressedAllowed,
    required Function(List<BookAndPackModel>) buttonClick,
    bool? isCloseButton = true,
  }) {

    List<BookAndPackModel> selectedBookAndPackList = [];
    List<BookSelectionDetailModel> allSelectionDetailList = [];
    for (var element in totalBook) {
      allSelectionDetailList.addAll(element.bookDetailsData ?? []);
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, StateSetter setInnerState) {
            return WillPopScope(
              onWillPop: () async{
                return isBackPressedAllowed ?? true;
              },
              child: Dialog(
                backgroundColor: LongaLottoPosColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HeightBox(20),
                        alertTitle(title),
                        const HeightBox(10),
                        Container(
                          width: 100,
                          height: 0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: LongaLottoPosColor.brownish_grey,
                              width: 1,
                            ),
                          ),
                        ),
                        const HeightBox(20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 2,
                                      crossAxisCount: 3,
                                    ),
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: allSelectionDetailList.length,//totalBook.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Ink(
                                        decoration: const BoxDecoration(
                                            color: LongaLottoPosColor.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            )
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            print("bookNumber: ${allSelectionDetailList[index].bookNumber} for game Id: ${getGameId(allSelectionDetailList[index].bookNumber ?? "", totalBook)}");
                                            int gameId = getGameId(allSelectionDetailList[index].bookNumber ?? "", totalBook);
                                            print("getBookQuantity(gameId, totalBook): ${getBookQuantity(gameId, totalBook)}");

                                            if (gameId != -1) {
                                              if (selectedBookAndPackList.isEmpty && getBookQuantity(gameId, totalBook) > 0) {
                                                print("if");
                                                if(allSelectionDetailList[index].bookNumber != null) {
                                                  selectedBookAndPackList.add(BookAndPackModel(bookList: [allSelectionDetailList[index].bookNumber!], gameId: gameId));
                                                  setInnerState((){
                                                    allSelectionDetailList[index].isSelected = true;
                                                  });

                                                }
                                              } else {
                                                print("else");
                                                List<BookAndPackModel> selectedBookAndPackObjectList = selectedBookAndPackList.where((element) => element.gameId == gameId).toList();
                                                if (selectedBookAndPackObjectList.isNotEmpty) {
                                                    if(selectedBookAndPackObjectList[0].bookList?.contains(allSelectionDetailList[index].bookNumber) == true) {
                                                      selectedBookAndPackObjectList[0].bookList?.remove(allSelectionDetailList[index].bookNumber);
                                                      setInnerState((){
                                                        allSelectionDetailList[index].isSelected = false;
                                                      });

                                                    } else {
                                                      var selectedBookAndPackObjectListLength = selectedBookAndPackObjectList[0].bookList?.length ?? 0;
                                                      if (selectedBookAndPackObjectListLength < getBookQuantity(gameId, totalBook)) {
                                                        if(allSelectionDetailList[index].bookNumber != null) {{
                                                          selectedBookAndPackObjectList[0].bookList?.add(allSelectionDetailList[index].bookNumber!);
                                                          setInnerState((){
                                                            allSelectionDetailList[index].isSelected = true;
                                                          });
                                                        }
                                                      } else {
                                                          print("limit exceed for gameId : $gameId");
                                                        }
                                                      }

                                                    }
                                                } else {
                                                  selectedBookAndPackList.add(BookAndPackModel(bookList: [allSelectionDetailList[index].bookNumber!], gameId: gameId));
                                                  setInnerState(() {
                                                    allSelectionDetailList[index].isSelected = true;
                                                  });
                                                }
                                              }
                                            }
                                            print("selectedBookAndPackList: ${jsonEncode(selectedBookAndPackList)}");

                                          },
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:  allSelectionDetailList[index].isSelected == true ? LongaLottoPosColor.medium_green : LongaLottoPosColor.white,
                                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                border:  allSelectionDetailList[index].isSelected == true ? Border.all(color: Colors.transparent, width: 2) : Border.all(color: LongaLottoPosColor.brownish_grey_three, width: 1)
                                            ),
                                            child: Center(child: Text("${allSelectionDetailList[index].bookNumber}", style: TextStyle(color: allSelectionDetailList[index].isSelected == true ? LongaLottoPosColor.white : LongaLottoPosColor.ball_border_bg, fontSize: 10, fontWeight: allSelectionDetailList[index].isSelected== true ? FontWeight.bold : FontWeight.w400))),
                                          ),
                                        ).p(2),
                                      );
                                    }),
                                const HeightBox(20),
                                const HeightBox(10),
                              ],
                            ).pOnly(top: 0,bottom: 30, left: 10, right: 10),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:  Container(
                        padding: const EdgeInsets.all(10),
                          color: LongaLottoPosColor.white,
                          child: buttons(isCloseButton ?? false, buttonClick, buttonText, ctx, selectedBookAndPackList)),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static alertTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        color: LongaLottoPosColor.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  confirmButton(Function(List<BookAndPackModel>)? buttonClick, String buttonText, BuildContext ctx, List<BookAndPackModel> selectedBookAndTicketList) {
    return InkWell(
      onTap: () {
        if(buttonClick != null && selectedBookAndTicketList.isNotEmpty ) {
          buttonClick(selectedBookAndTicketList);
          Navigator.of(ctx).pop();
        } else {
          Navigator.of(ctx).pop();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: LongaLottoPosColor.medium_green,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        height: 35,
        child:  Center(child: Text(ctx.l10n.ok, style: const TextStyle(color: LongaLottoPosColor.white))),
      ),
    );
  }

  buttons(bool isCloseButton, Function(List<BookAndPackModel>) buttonClick,
      String buttonText, BuildContext ctx, List<BookAndPackModel> selectedBookAndTicketList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isCloseButton ? Expanded(child: closeButton(ctx)) : const SizedBox(),
        const WidthBox(10),
        Expanded(child: confirmButton(buttonClick, buttonText, ctx, selectedBookAndTicketList)),
      ],
    );
  }

  static closeButton(BuildContext ctx) {
    return InkWell(
        onTap: () {
          Navigator.of(ctx).pop();
        },
        child: Container(
          decoration: BoxDecoration(
              color: LongaLottoPosColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: LongaLottoPosColor.game_color_red)
          ),
          height: 35,
          child: Center(child: Text(ctx.l10n.cancel, style: const TextStyle(color: LongaLottoPosColor.game_color_red))),
        )
    );
  }


  int getGameId(String bookNumber, List<TotalBook> totalBookList) {
    List<TotalBook> totalBookListObject = totalBookList.where((element) => element.bookDetailsData?.where((bookData) => bookData.bookNumber?.contains(bookNumber) == true).toList().isNotEmpty == true).toList();
    if (totalBookListObject.isNotEmpty) {
      return totalBookListObject[0].gameId ?? -1;
    }

    return -1;
  }

  int getBookQuantity(int gameId, List<TotalBook> totalBookList) {
    List<TotalBook> totalBookListObject = totalBookList.where((element) => element.gameId == gameId).toList();
    if (totalBookListObject.isNotEmpty) {
      return totalBookListObject[0].bookQuantity ?? -1;
    }

    return -1;
  }
}
