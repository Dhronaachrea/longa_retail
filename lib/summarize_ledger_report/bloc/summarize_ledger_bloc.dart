import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/summarize_ledger_report/bloc/summarize_ledger_event.dart';
import 'package:longalottoretail/summarize_ledger_report/bloc/summarize_ledger_state.dart';

import '../../main.dart';
import '../../utility/app_constant.dart';
import '../../utility/user_info.dart';
import '../model/response/summarize_date_wise_response.dart';
import '../model/response/summarize_defalut_response.dart';
import '../summarize_ledger_logic.dart';

class SummarizeLedgerBloc
    extends Bloc<SummarizeLedgerEvent, SummarizeLedgerState> {
  SummarizeLedgerBloc() : super(SummarizeLedgerInitial()) {
    on<SummarizeLedgerModel>(_getSummarizeDateWiseList);
  }

  _getSummarizeDateWiseList(
      SummarizeLedgerModel event, Emitter<SummarizeLedgerState> emit) async {
    emit(SummarizeLedgerLoading());
    BuildContext context = event.context;

    Map<String, String> param = {
      'orgId': UserInfo.organisationID,
      'startDate': event.startDate,
      'endDate': event.endDate,
      'type': event.type,
      'languageCode': languageCode,
      'appType': appType,
    };

    var response =
        await SummarizeLedgerLogic.getSummarizeDateWise(context, param, event.type);

    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(SummarizeLedgerDateWiseError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            if (event.type == "default") {
              SummarizeDefaultResponse _response =
                  value as SummarizeDefaultResponse;
              emit(SummarizeLedgerDefaultSuccess(response: _response));
            } else {
              SummarizeDateWiseResponse _response =
                  value as SummarizeDateWiseResponse;
              emit(SummarizeLedgerDateWiseSuccess(response: _response));
            }
          },
          responseFailure: (value) {
            SummarizeDateWiseResponse errorResponse =
                value as SummarizeDateWiseResponse;
            print(
                "bloc responseFailure: ${errorResponse.responseData?.message} =======> ");
            emit(SummarizeLedgerDateWiseError(
                errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode)  ?? errorResponse.responseMessage ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(SummarizeLedgerDateWiseError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }
}
