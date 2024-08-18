import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/login/models/response/LoginTokenResponse.dart';
import 'package:longalottoretail/login/models/response/VerifyPosResponse.dart';
import 'package:longalottoretail/splash/model/model/response/DefaultConfigData.dart';
import 'package:longalottoretail/splash/model/model/response/VersionControlResponse.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginTokenLoading extends LoginState{}

class LoginTokenSuccess extends LoginState{
  LoginTokenResponse? response;

  LoginTokenSuccess({required this.response});

}
class LoginTokenError extends LoginState{
  String errorMessage;

  LoginTokenError({required this.errorMessage});
}

/////////////////////////////////////////////////////////////////////

class GetLoginDataLoading extends LoginState{}

class GetLoginDataSuccess extends LoginState{
  GetLoginDataResponse? response;

  GetLoginDataSuccess({required this.response});

}
class GetLoginDataError extends LoginState{
  String errorMessage;

  GetLoginDataError({required this.errorMessage});
}

class VerifyPosLoading extends LoginState{}

class VerifyPosSuccess extends LoginState{
  VerifyPosResponse? response;

  VerifyPosSuccess({required this.response});

}
class VerifyPosError extends LoginState{
  String errorMessage;

  VerifyPosError({required this.errorMessage});
}

class VersionControlLoading extends LoginState {}

class VersionControlSuccess extends LoginState {
  VersionControlResponse? response;

  VersionControlSuccess({required this.response});
}

class VersionControlError extends LoginState {
  final String errorMsg;

  VersionControlError({required this.errorMsg});
}

class DefaultConfigLoading extends LoginState {}

class  DefaultConfigSuccess extends LoginState{
  DefaultDomainConfigData response;

  DefaultConfigSuccess({required this.response});

}
class DefaultConfigError extends LoginState{
  String errorMessage;

  DefaultConfigError({required this.errorMessage});
}
