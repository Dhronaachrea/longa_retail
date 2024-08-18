

import 'package:longalottoretail/balance_invoice_report/models/response/balance_invoice_report_response.dart';

abstract class BalanceInvoiceReportState {}

class BalanceInvoiceReportInitial extends BalanceInvoiceReportState {}

class BalanceInvoiceReportLoading extends BalanceInvoiceReportState{}

class BalanceInvoiceReportSuccess extends BalanceInvoiceReportState{
  BalanceInvoiceReportResponse balanceInvoiceReportApiResponse;

  BalanceInvoiceReportSuccess({required this.balanceInvoiceReportApiResponse});

}
class BalanceInvoiceReportError extends BalanceInvoiceReportState{
  String errorMessage;

  BalanceInvoiceReportError({required this.errorMessage});
}