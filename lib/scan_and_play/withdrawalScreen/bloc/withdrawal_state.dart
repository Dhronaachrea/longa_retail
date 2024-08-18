import '../../depositScreen/model/deposit_response.dart';
import '../model/Pending_withdrawal_response.dart';
import '../model/update_qr_withdrawal_response.dart';

abstract class WithdrawalState {}

class PendingWithdrawalInitial extends WithdrawalState {}

class PendingWithdrawalLoading extends WithdrawalState {}

class PendingWithdrawalSuccess extends WithdrawalState {
  PendingWithdrawalResponse response;

  PendingWithdrawalSuccess({required this.response});
}

class PendingWithdrawalError extends WithdrawalState {
  String errorMessage;

  PendingWithdrawalError({required this.errorMessage});
}

class UpdateWithdrawalInitial extends WithdrawalState {}

class UpdateWithdrawalLoading extends WithdrawalState {}

class UpdateWithdrawalSuccess extends WithdrawalState {
  UpdateQRWithdrawalResponse response;

  UpdateWithdrawalSuccess({required this.response});
}

class UpdateWithdrawalError extends WithdrawalState {
  String errorMessage;

  UpdateWithdrawalError({required this.errorMessage});
}
