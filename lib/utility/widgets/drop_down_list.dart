// import 'package:flutter/material.dart';
// import 'package:wls_pos/utility/wls_pos_color.dart';
// import 'package:wls_pos/sportsLottery/models/response/sportsLotteryGameApiResponse.dart';
//
// class DropDownList extends StatefulWidget {
//   List<ResponseData>? gameListData;
//   final Function(int)? onSelectedGame;
//
//   DropDownList({Key? key, this.title, this.gameListData, this.onSelectedGame})
//       : super(key: key);
//
//   final String? title;
//
//   @override
//   _DropDownListState createState() => _DropDownListState();
// }
//
// class _DropDownListState extends State<DropDownList> {
//   bool enableList = false;
//   int? _selectedIndex = 1;
//   List gameList = [];
//
//   String _selectedPicGroup="Group A";
//
//   static const _picGroup = [
//     'Group A',
//     'Group B',
//     'Group C',
//     'Group D',
//   ];
//
//
//   _onhandleTap() {
//     setState(() {
//       enableList = !enableList;
//     });
//   }
//
//   _onChanged(int position) {
//     setState(() {
//       _selectedIndex = position;
//       enableList = !enableList;
//     });
//     widget.onSelectedGame!(position);
//   }
//
//   Widget _buildSearchList() => Container(
//         height: 150.0,
//         decoration: BoxDecoration(
//           border: Border.all(color: LongaLottoPosColor.light_grey, width: 1),
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           color: Colors.white,
//         ),
//         // padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//         margin: EdgeInsets.only(top: 5.0),
//         child: ListView.builder(
//             padding: const EdgeInsets.all(0),
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             physics:
//                 BouncingScrollPhysics(
//                     parent: AlwaysScrollableScrollPhysics()
//                 ),
//             itemCount: widget.gameListData!.length,
//             itemBuilder: (context, position) {
//               return InkWell(
//                 onTap: () {
//                   _onChanged(position);
//                 },
//                 child: Container(
//                     // padding: widget.padding,
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//                     decoration: BoxDecoration(
//                         color: position == _selectedIndex
//                             ? Colors.grey[100]
//                             : Colors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                     child: Text(
//                       widget.gameListData![position].gameName!,
//                       style: TextStyle(color: Colors.black),
//                     )),
//               );
//             }),
//       );
//
//
//   @override
//   Widget build(BuildContext context) {
//     for(var gameData in widget.gameListData!)
//     {
//       gameList.add(gameData.gameName);
//     }
//     return Column(
//       children: <Widget>[
//         InkWell(
//           onTap: _onhandleTap,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                   color: enableList ? Colors.black : Colors.grey, width: 1),
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//               color: Colors.white,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             margin: const EdgeInsets.symmetric(vertical: 10.0),
//             height: 48.0,
//             // child: Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   mainAxisSize: MainAxisSize.min,
//             //   children: <Widget>[
//             //     Expanded(
//             //         child: Text(
//             //       _selectedIndex != null
//             //           ? widget.gameListData![0].gameName!
//             //           : "Select value",
//             //       style: TextStyle(fontSize: 16.0),
//             //     )
//             //     ),
//             //     Icon(Icons.expand_more, size: 24.0, color: Color(0XFFbbbbbb)),
//             //   ],
//             // ),
//             child: Column(
//           children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//             border: Border.all(
//             color: Colors.grey,
//             width: 1,
//           )
//     ),
//     margin: const EdgeInsets.all(10),
//     child: SizedBox(
//     height: 48,
//     child: DropdownButtonFormField(
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     decoration: InputDecoration(
//     border: InputBorder.none,
//     filled: true,
//     fillColor: Colors.grey[300],
//     ),
//     isExpanded: true,
//     isDense: true,
//     value: _selectedPicGroup,
//     selectedItemBuilder: (BuildContext context) {
//     return _picGroup.map<Widget>((String item) {
//     print("$item");
//     return DropdownMenuItem(value: item, child: Text(item));
//     }).toList();
//     },
//     items: _picGroup.map((item) {
//     if (item == _selectedPicGroup) {
//     return DropdownMenuItem(
//     value: item,
//     child: Container(
//     height: 48.0,
//     width: double.infinity,
//     color: LongaLottoPosColor.light_dark_white,
//     child: Align(
//     alignment: Alignment.centerLeft,
//     child: Text(
//     item,
//     ),
//     )),
//     );
//     } else {
//     return DropdownMenuItem(
//     value: item,
//     child: Text(item),
//     );
//     }
//     }).toList(),
//     validator: (value) =>
//     value?.isEmpty ?? true ? 'Cannot Empty' : null,
//     onChanged: (selectedItem) => setState(
//     () {
//     _selectedPicGroup = selectedItem!;
//     },
//     ),
//     ),
//     ),
//     ),
//     Row(
//     children: [
//
//     ],
//     )
//     ],
//     ),
//
//     ),
//         ),
//         // enableList ? _buildSearchList() : Container(),
//       ],
//     );
//   }
// }

import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';

class DropDownList extends StatefulWidget {
  var gameListData;
  final Function(int)? onSelectedGame;

  DropDownList({Key? key, required this.gameListData, this.onSelectedGame})
      : super(key: key);

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  List<String>? items = [];
  String? selectedValue;
  var screenWidth;
  var screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    items!.clear();
    for (var itemsValue in widget.gameListData) {
      items!.add(itemsValue.gameName);
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                widget.gameListData[0].gameName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  // color: LongaLottoPosColor.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items!
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: LongaLottoPosColor.black.withOpacity(0.4),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
            widget.onSelectedGame!(items!.indexOf(value!));
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: screenWidth * 0.6,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: LongaLottoPosColor.white,
              ),
              color: LongaLottoPosColor.white),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
          ),
          iconSize: 24,
          // iconEnabledColor: LongaLottoPosColor.black,
          // iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: screenWidth * 0.8,
          padding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: LongaLottoPosColor.white,
          ),
          elevation: 8,
          // offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
