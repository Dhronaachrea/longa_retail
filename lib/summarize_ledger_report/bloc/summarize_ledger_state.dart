
import '../model/response/summarize_date_wise_response.dart';
import '../model/response/summarize_defalut_response.dart';

abstract class SummarizeLedgerState {}

class SummarizeLedgerInitial extends SummarizeLedgerState {}

class SummarizeLedgerLoading extends SummarizeLedgerState {}

class SummarizeLedgerDateWiseSuccess extends SummarizeLedgerState {
  SummarizeDateWiseResponse response;

  SummarizeLedgerDateWiseSuccess({required this.response});
}

class SummarizeLedgerDateWiseError extends SummarizeLedgerState {
  String errorMessage;

  SummarizeLedgerDateWiseError({required this.errorMessage});
}

class SummarizeLedgerDefaultSuccess extends SummarizeLedgerState {
  SummarizeDefaultResponse response;

  SummarizeLedgerDefaultSuccess({required this.response});
}
