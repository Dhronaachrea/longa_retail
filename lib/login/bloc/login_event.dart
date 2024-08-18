import 'package:flutter/cupertino.dart';

abstract class LoginEvent {}

class LoginTokenApi extends LoginEvent {
  BuildContext context;
  String userName;
  String password;

  LoginTokenApi({required this.context, required this.userName, required this.password});
}

class GetLoginDataApi extends LoginEvent {
  BuildContext context;

  GetLoginDataApi({required this.context});
}

class VerifyPosApi extends LoginEvent {
  BuildContext context;
  String latitude;
  String longitude;

  VerifyPosApi({required this.context, required this.latitude ,required this.longitude});
}

class VersionControlApi extends LoginEvent {
  final BuildContext context;

  VersionControlApi({required this.context});
}

class GetConfigData extends LoginEvent {
  BuildContext context;

  GetConfigData({required this.context});
}
