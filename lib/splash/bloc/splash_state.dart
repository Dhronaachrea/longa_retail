import 'package:longalottoretail/home/models/response/get_config_response.dart';
import 'package:longalottoretail/splash/model/model/response/DefaultConfigData.dart';
import 'package:longalottoretail/splash/model/model/response/VersionControlResponse.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class VersionControlLoading extends SplashState {}

class VersionControlSuccess extends SplashState {
  VersionControlResponse? response;

  VersionControlSuccess({required this.response});
}

class VersionControlError extends SplashState {
  final String errorMsg;

  VersionControlError({required this.errorMsg});
}

class DefaultConfigLoading extends SplashState {}

class  DefaultConfigSuccess extends SplashState{
  DefaultDomainConfigData response;

  DefaultConfigSuccess({required this.response});

}
class DefaultConfigError extends SplashState{
  String errorMessage;

  DefaultConfigError({required this.errorMessage});
}
