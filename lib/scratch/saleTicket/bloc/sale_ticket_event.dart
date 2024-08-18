import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';

abstract class SaleTicketEvent {}

class SaleTicketApi extends SaleTicketEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  List<String>? ticketNumberList;
  String? fromTicket;
  String? toTicket;

  SaleTicketApi({required this.context, required this.scratchList, this.ticketNumberList, this.fromTicket, this.toTicket});
}

class RemainingTicketCountApi extends SaleTicketEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  String? bookNumber;

  RemainingTicketCountApi({required this.context, required this.bookNumber, required this.scratchList});
}