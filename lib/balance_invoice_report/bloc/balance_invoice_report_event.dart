import 'package:flutter/cupertino.dart';

abstract class BalanceInvoiceReportEvent {}

class GetBalanceInvoiceReportApiData extends BalanceInvoiceReportEvent {
  BuildContext context;
  String? fromDate;
  String? toDate;

  GetBalanceInvoiceReportApiData({required this.context, required this.fromDate, required this.toDate});
}
