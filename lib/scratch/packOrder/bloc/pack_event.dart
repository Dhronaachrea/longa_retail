import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';

abstract class PackEvent {}

class PackApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  var requestData;

  PackApi({required this.context, required this.scratchList, required this.requestData});
}

class GameDetailsApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;

  GameDetailsApi({required this.context, required this.scratchList});
}

class DlDetailsApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  String? barCodeText;

  DlDetailsApi({required this.context, required this.scratchList, required this.barCodeText});
}

class BookReceiveApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  var requestData;

  BookReceiveApi({required this.context, required this.scratchList, required this.requestData});
}

class PackActivationApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  var requestData;

  PackActivationApi({required this.context, required this.scratchList, required this.requestData});
}

class GameListApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;

  GameListApi({required this.context, required this.scratchList});
}

class GameViseInventoryApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  var requestData;

  GameViseInventoryApi({required this.context, required this.scratchList, required this.requestData});
}

class PackReturnNoteApi extends PackEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  var requestData;

  PackReturnNoteApi({required this.context, required this.scratchList, required this.requestData});
}

class PackReturnSubmitApi extends PackEvent {
BuildContext context;
MenuBeanList? scratchList;
var requestData;

PackReturnSubmitApi({required this.context, required this.scratchList, required this.requestData});
}