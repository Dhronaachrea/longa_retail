import 'package:flutter/cupertino.dart';

abstract class SaleWinEvent {}

class SaleList extends SaleWinEvent {
  BuildContext context;
  String url;

  SaleList({required this.context, required this.url});
}

class SaleWinTxnReport extends SaleWinEvent {
  BuildContext context;
  String serviceCode;
  String startDate;
  String endDate;

  SaleWinTxnReport({
    required this.context,
    required this.serviceCode,
    required this.startDate,
    required this.endDate,
  });
}
