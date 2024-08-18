

import '../models/response/ledgerReportApiResponse.dart';

abstract class LedgerReportState {}

class LedgerReportInitial extends LedgerReportState {}

class LedgerReportLoading extends LedgerReportState{}

class LedgerReportSuccess extends LedgerReportState{
  LedgerReportApiResponse ledgerReportApiResponse;

  LedgerReportSuccess({required this.ledgerReportApiResponse});

}
class LedgerReportError extends LedgerReportState{
  String errorMessage;

  LedgerReportError({required this.errorMessage});
}