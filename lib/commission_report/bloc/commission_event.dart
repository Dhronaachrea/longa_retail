import 'package:flutter/cupertino.dart';

abstract class CommissionEvent {}

class FetchOrgCommission extends CommissionEvent {
  BuildContext context;
  String startDate;
  String endDate;
  String orgId;
  String commType;

  FetchOrgCommission({required this.context, required this.startDate, required this.endDate, required this.orgId, required this.commType});
}

class CommissionDetailedData extends CommissionEvent {
  BuildContext context;
  CommissionDetailedData({required this.context});
}