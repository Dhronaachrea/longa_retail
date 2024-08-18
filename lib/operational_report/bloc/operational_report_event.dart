import 'package:flutter/cupertino.dart';

abstract class OperationalReportEvent {}

class GetOperationalReportApiData extends OperationalReportEvent {
  BuildContext context;
  String? fromDate;
  String? toDate;
  String? serviceCode;

  GetOperationalReportApiData({required this.context, required this.fromDate, required this.toDate, required this.serviceCode});
}

class ServiceList extends OperationalReportEvent {
  BuildContext context;
  String url;

  ServiceList({required this.context, required this.url});
}
