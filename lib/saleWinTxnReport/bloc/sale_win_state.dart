

import '../model/get_sale_report_response.dart';
import '../model/get_service_list_response.dart';

abstract class SaleWinState {}

class SaleListInitial extends SaleWinState {}

class SaleListLoading extends SaleWinState {}

class SaleListSuccess extends SaleWinState {
  GetServiceListResponse response;

  SaleListSuccess({required this.response});
}

class SaleListError extends SaleWinState {
  String errorMessage;

  SaleListError({required this.errorMessage});
}


class SaleWinTaxListLoading extends SaleWinState {}

class SaleWinTaxListSuccess extends SaleWinState {
  GetSaleReportResponse response;

  SaleWinTaxListSuccess({required this.response});
}

class SaleWinTaxListError extends SaleWinState {
  String errorMessage;

  SaleWinTaxListError({required this.errorMessage});
}
