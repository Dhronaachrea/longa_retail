import 'package:longalottoretail/commission_report/model/response/CommissionDetailedDataResponse.dart';
import 'package:longalottoretail/commission_report/model/response/FetchOrgCommissionResponse.dart';

abstract class CommissionReportState {}

class FetchOrgCommissionInitial extends CommissionReportState {}

class FetchOrgCommissionLoading extends CommissionReportState{}

class FetchOrgCommissionSuccess extends CommissionReportState{
  FetchOrgCommissionResponse? response;
  FetchOrgCommissionSuccess({required this.response});

}

class FetchOrgCommissionError extends CommissionReportState{
  String errorMessage;

  FetchOrgCommissionError({required this.errorMessage});
}

class CommissionDetailedDataLoading extends CommissionReportState{}

class CommissionDetailedDataSuccess extends CommissionReportState{
  CommissionDetailedDataResponse? response;
  CommissionDetailedDataSuccess({required this.response});

}

class CommissionDetailedDataError extends CommissionReportState{
  String errorMessage;

  CommissionDetailedDataError({required this.errorMessage});
}

