part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class UpdateUserInfo extends AuthEvent {
  final GetLoginDataResponse loginDataResponse;

  UpdateUserInfo({required this.loginDataResponse});
}
