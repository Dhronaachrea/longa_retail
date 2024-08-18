import 'package:flutter/cupertino.dart';

abstract class SummarizeLedgerEvent {}

class SummarizeLedgerModel extends SummarizeLedgerEvent {
  BuildContext context;
  String url;
  String startDate;
  String type;
  String endDate;

  SummarizeLedgerModel({
    required this.context,
    required this.url,
    required this.type,
    required this.startDate,
    required this.endDate,
  });
}
