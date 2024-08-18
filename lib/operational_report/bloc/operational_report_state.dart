
import 'package:longalottoretail/operational_report/models/response/operational_cash_report_response.dart';
import 'package:longalottoretail/saleWinTxnReport/model/get_service_list_response.dart';

abstract class OperationalReportState {}

class OperationalReportInitial extends OperationalReportState {}

class OperationalReportLoading extends OperationalReportState{}

class OperationalReportSuccess extends OperationalReportState{
  OperationalCashReportResponse operationalReportApiResponse;

  OperationalReportSuccess({required this.operationalReportApiResponse});

}
class OperationalReportError extends OperationalReportState{
  String errorMessage;

  OperationalReportError({required this.errorMessage});
}


class ServiceListLoading extends OperationalReportState {}

class ServiceListSuccess extends OperationalReportState {
  GetServiceListResponse response;

  ServiceListSuccess({required this.response});
}

class ServiceListError extends OperationalReportState {
  String errorMessage;

  ServiceListError({required this.errorMessage});
}