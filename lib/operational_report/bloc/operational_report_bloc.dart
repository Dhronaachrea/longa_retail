import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/operational_report/models/response/operational_cash_report_response.dart';
import 'package:longalottoretail/operational_report/operational_report_logic.dart';
import 'package:longalottoretail/saleWinTxnReport/model/get_service_list_response.dart';
import '../../utility/app_constant.dart';
import '../../utility/user_info.dart';
import 'operational_report_event.dart';
import 'operational_report_state.dart';

class OperationalReportBloc extends Bloc<OperationalReportEvent, OperationalReportState> {
  OperationalReportBloc() : super(OperationalReportInitial()) {
    on<GetOperationalReportApiData>(_onHomeEvent);
    on<ServiceList>(_getServiceList);
  }
}

_onHomeEvent(GetOperationalReportApiData event, Emitter<OperationalReportState> emit) async {
  emit(OperationalReportLoading());

  BuildContext context = event.context;
  String toDate = event.fromDate ?? "";
  String fromDate = event.toDate ?? "";



  Map<String, String> request = {
    "startDate" : toDate,
    "endDate": fromDate,
    "languageCode": languageCode,
    "appType": appType,
    "serviceCode": event.serviceCode ?? "",
    "domainId": UserInfo.domainID,
    "orgId": UserInfo.organisationID
  };

  var response = await OperationalReportLogic.callLedgerReportList(
      context,
      request
  );

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(OperationalReportError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          OperationalCashReportResponse operationalCashReportResponse = value;
          emit(OperationalReportSuccess(operationalReportApiResponse: operationalCashReportResponse));
        },
        responseFailure: (value) {
          OperationalCashReportResponse errorResponse = value;
          print("bloc responseFailure:");
          emit(OperationalReportError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(OperationalReportError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}

_getServiceList(ServiceList event, Emitter<OperationalReportState> emit) async {
  emit(ServiceListLoading());

  BuildContext context = event.context;

  var response = await OperationalReportLogic.getSaleList(context);
  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(ServiceListError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          GetServiceListResponse _response = value as GetServiceListResponse;

          emit(ServiceListSuccess(response: _response));
        },
        responseFailure: (value) {
          GetServiceListResponse errorResponse =
          value as GetServiceListResponse;
          print(
              "bloc responseFailure: ${errorResponse.responseData?.message} =======> ");
          emit(ServiceListError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(ServiceListError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}
