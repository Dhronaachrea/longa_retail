

import 'package:longalottoretail/scan_and_play/depositScreen/model/deposit_coupon_reversal/coupon_reversal_response.dart';

import '../model/deposit_response.dart';

abstract class DepositState {}

class DepositInitial extends DepositState {}

class DepositLoading extends DepositState {}

class DepositSuccess extends DepositState {
  DepositResponse response;

  DepositSuccess({required this.response});
}

class DepositError extends DepositState {
  String errorMessage;

  DepositError({required this.errorMessage});
}

class CouponReversalLoading extends DepositState {}

class CouponReversalSuccess extends DepositState {
  CouponReversalResponse response;

  CouponReversalSuccess({required this.response});
}

class CouponReversalError extends DepositState {
  String errorMessage;

  CouponReversalError({required this.errorMessage});
}

