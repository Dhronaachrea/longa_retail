import 'package:flutter/cupertino.dart';

abstract class ChangePinEvent {}

class ChangePinApi extends ChangePinEvent {
  BuildContext context;
  String oldPassword;
  String newPassword;
  String confirmPassword;

  ChangePinApi({required this.context, required this.oldPassword, required this.newPassword
    , required this.confirmPassword});
}

