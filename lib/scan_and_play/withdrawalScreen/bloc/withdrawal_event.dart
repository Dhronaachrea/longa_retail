import 'package:flutter/cupertino.dart';

import '../model/update_qr_withdrawal_request.dart';

abstract class WithdrawalEvent {}

class PendingWithdrawalApiData extends WithdrawalEvent {
  BuildContext context;
  String id;

  PendingWithdrawalApiData({required this.context, required this.id});
}

class UpdateWithdrawalApiData extends WithdrawalEvent {
  BuildContext context;
  UpdateQrWithdrawalRequest  updateQrWithdrawalRequest;

  UpdateWithdrawalApiData({required this.context, required this.updateQrWithdrawalRequest});
}
