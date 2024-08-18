import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import '../../utility/app_constant.dart';
import '../../utility/user_info.dart';
import '../ledger_report_logic.dart';
import '../models/request/ledgerReportApiRequest.dart';
import '../models/response/ledgerReportApiResponse.dart';
import 'ledger_report_event.dart';
import 'ledger_report_state.dart';

class LedgerReportBloc extends Bloc<LedgerReportEvent, LedgerReportState> {
  LedgerReportBloc() : super(LedgerReportInitial()) {
    on<GetLedgerReportApiData>(_onHomeEvent);
  }
}

_onHomeEvent(
    GetLedgerReportApiData event, Emitter<LedgerReportState> emit) async {
  emit(LedgerReportLoading());

  BuildContext context = event.context;
  String? toDate = event.fromDate;
  String? fromDate = event.toDate;

  var response = await LedgerReportLogic.callLedgerReportList(
      context,
      LedgerReportApiRequest(
        orgId: UserInfo.organisationID,
        startDate: toDate,
        endDate: fromDate,
        // RMS
        languageCode: languageCode,
        appType: appType,
      ).toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(LedgerReportError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          LedgerReportApiResponse ledgerReportApiResponse = value;

          emit(LedgerReportSuccess(
              ledgerReportApiResponse: ledgerReportApiResponse));
        },
        responseFailure: (value) {
          LedgerReportApiResponse errorResponse = value;
          print("bloc responseFailure:");
          emit(LedgerReportError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(LedgerReportError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}
