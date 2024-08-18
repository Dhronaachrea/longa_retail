import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/commission_report/commission_logic.dart';
import 'package:longalottoretail/commission_report/model/response/CommissionDetailedDataResponse.dart';
import 'package:longalottoretail/commission_report/model/response/FetchOrgCommissionResponse.dart';
import 'package:longalottoretail/login/models/response/LoginTokenResponse.dart';
import 'commission_event.dart';
import 'commission_state.dart';

class CommissionReportBloc extends Bloc<CommissionEvent, CommissionReportState> {
  CommissionReportBloc() : super(FetchOrgCommissionInitial()) {
    on<FetchOrgCommission>(_onFetchOrgCommissionEvent);
    on<CommissionDetailedData>(_onCommissionDetailedData);
  }


  _onFetchOrgCommissionEvent(FetchOrgCommission event, Emitter<CommissionReportState> emit) async {
    emit(FetchOrgCommissionLoading());

    Map<String, String> commissionInfo = {
        "startDate" : event.startDate,
        "endDate"   : event.endDate,
        "orgId"     : event.orgId,
        "domainId"  : "",
        "commType"  : event.commType
    };

    var response = await CommissionLogic.callFetchOrgCommissionApi(event.context, commissionInfo);

    try {
      response.when(idle: () {

      },
          networkFault: (value) {
            emit(FetchOrgCommissionError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
        print("success ---->");
            dynamic successResponse = value as FetchOrgCommissionResponse;
            emit(FetchOrgCommissionSuccess(response: successResponse));
          },
          responseFailure: (value) {
            LoginTokenResponse errorResponse = value as LoginTokenResponse;
            print("bloc responseFailure: ${errorResponse.responseData?.message} =======> ");
            emit(FetchOrgCommissionError(errorMessage: errorResponse.responseData?.message ?? "Something Went Wrong!"));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(FetchOrgCommissionError(errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error - $e");
    }
  }

  _onCommissionDetailedData(CommissionDetailedData event, Emitter<CommissionReportState> emit) async {
    emit(CommissionDetailedDataLoading());

    var context = event.context;

    Map<String, String> commissionInfo = {
        "startDate" : "",
        "endDate"   : "",
        "orgId"     : "",
        "domainId"  : ""
    };

    var response = await CommissionLogic.callCommissionDetailedDataApi(context, commissionInfo);

    try {
      response.when(idle: () {

      },
          networkFault: (value) {
            emit(CommissionDetailedDataError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
        print("success ---->");
            dynamic successResponse = value as CommissionDetailedDataResponse;
            emit(CommissionDetailedDataSuccess(response: successResponse));
          },
          responseFailure: (value) {
            LoginTokenResponse errorResponse = value as LoginTokenResponse;
            print("bloc responseFailure: ${errorResponse.responseData?.message} =======> ");
            emit(CommissionDetailedDataError(errorMessage: errorResponse.responseData?.message ?? "Something Went Wrong!"));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(CommissionDetailedDataError(errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error - $e");
    }
  }

}
