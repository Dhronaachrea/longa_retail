import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/balance_invoice_report/balance_invoice_report_logic.dart';
import 'package:longalottoretail/balance_invoice_report/bloc/balance_invoice_report_event.dart';
import 'package:longalottoretail/balance_invoice_report/bloc/balance_invoice_report_state.dart';
import 'package:longalottoretail/balance_invoice_report/models/request/balance_invoice_request.dart';
import 'package:longalottoretail/balance_invoice_report/models/response/balance_invoice_report_response.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import '../../utility/app_constant.dart';
import '../../utility/user_info.dart';

class BalanceInvoiceReportBloc extends Bloc<BalanceInvoiceReportEvent, BalanceInvoiceReportState> {
  BalanceInvoiceReportBloc() : super(BalanceInvoiceReportInitial()) {
    on<GetBalanceInvoiceReportApiData>(_onHomeEvent);
  }
}

_onHomeEvent(
    GetBalanceInvoiceReportApiData event, Emitter<BalanceInvoiceReportState> emit) async {
  emit(BalanceInvoiceReportLoading());

  BuildContext context = event.context;
  String? toDate = event.fromDate;
  String? fromDate = event.toDate;

  var response = await BalanceInvoiceReportLogic.callBalanceInvoiceReportApi(
      context,
      BalanceInvoiceReportRequest(
        orgId: UserInfo.organisationID,
        startDate: toDate,
        endDate: fromDate,
        // RMS
        languageCode: languageCode,
        appType: appType,
        domainId: UserInfo.domainID
      ).toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(BalanceInvoiceReportError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          BalanceInvoiceReportResponse balanceInvoiceReportApiResponse = value;

          emit(BalanceInvoiceReportSuccess(balanceInvoiceReportApiResponse: balanceInvoiceReportApiResponse));
        },
        responseFailure: (value) {
          BalanceInvoiceReportResponse errorResponse = value;
          print("bloc responseFailure:");
          emit(BalanceInvoiceReportError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(BalanceInvoiceReportError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}
