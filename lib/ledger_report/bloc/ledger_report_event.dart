import 'package:flutter/cupertino.dart';

abstract class LedgerReportEvent {}

class GetLedgerReportApiData extends LedgerReportEvent {
  BuildContext context;
  String? fromDate;
  String? toDate;

  GetLedgerReportApiData({required this.context, required this.fromDate, required this.toDate});
}
