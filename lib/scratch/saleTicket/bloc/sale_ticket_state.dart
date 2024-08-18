
import 'package:longalottoretail/scratch/saleTicket/model/response/remaining_ticket_count_response.dart';
import 'package:longalottoretail/scratch/saleTicket/model/response/sale_ticket_response.dart';

abstract class SaleTicketState {}

class SaleTicketInitial extends SaleTicketState {}

class SaleTicketLoading extends SaleTicketState {}

class SaleTicketSuccess extends SaleTicketState {
  SaleTicketResponse response;

  SaleTicketSuccess({required this.response});
}

class SaleTicketError extends SaleTicketState {
  String errorMessage;

  SaleTicketError({required this.errorMessage});
}

class RemainingTicketCountLoading extends SaleTicketState{}
class RemainingTicketCountError extends SaleTicketState {
  String errorMessage;

  RemainingTicketCountError({required this.errorMessage});
}
class RemainingTicketCountSuccess extends SaleTicketState{
  RemainingTicketCountResponse response;

  RemainingTicketCountSuccess({required this.response});
}
