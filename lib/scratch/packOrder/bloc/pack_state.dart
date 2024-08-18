import 'package:longalottoretail/scratch/packOrder/model/game_details_response.dart';
import 'package:longalottoretail/scratch/packOrder/model/pack_order_response.dart';
import 'package:longalottoretail/scratch/packReceive/model/book_receive_response.dart';
import 'package:longalottoretail/scratch/packReceive/model/dl_details_response.dart';
import 'package:longalottoretail/scratch/pack_activation/model/game_list_response.dart';
import 'package:longalottoretail/scratch/pack_activation/model/pack_activation_response.dart';
import 'package:longalottoretail/scratch/pack_return/model/pack_return_note_response.dart';
import 'package:longalottoretail/scratch/pack_return/model/response/game_vise_inventory_response.dart';
import 'package:longalottoretail/scratch/pack_return/model/response/pack_return_submit_response.dart';

abstract class PackState {}

class PackInitial extends PackState {}

class PackLoading extends PackState {}

class PackSuccess extends PackState {
  PackOrderResponse response;

  PackSuccess({required this.response});
}

class PackError extends PackState {
  String errorMessage;

  PackError({required this.errorMessage});
}

class GameDetailsSuccess extends PackState {
  GameDetailsResponse response;

  GameDetailsSuccess({required this.response});
}

class DlDetailsSuccess extends PackState {
  DlDetailsResponse response;

  DlDetailsSuccess({required this.response});
}

class BookReceiveSuccess extends PackState {
  BookReceiveResponse response;

  BookReceiveSuccess({required this.response});
}

class PackActivationSuccess extends PackState {
  PackActivationResponse response;

  PackActivationSuccess({required this.response});
}

class GameListSuccess extends PackState {
  GameListResponse response;

  GameListSuccess({required this.response});
}
class PackReturnNoteSuccess extends PackState {
  PackReturnNoteResponse response;

  PackReturnNoteSuccess({required this.response});
}

class GameViseInventorySuccess extends PackState {
  GameViseInventoryResponse response;

  GameViseInventorySuccess({required this.response});
}

class PackReturnSubmitSuccess extends PackState {
  PackReturnSubmitResponse response;

  PackReturnSubmitSuccess({required this.response});
}