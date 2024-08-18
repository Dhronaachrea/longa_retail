

import '../model/response/change_pin_response.dart';

abstract class ChangePinState {}

class ChangePinInitial extends ChangePinState {}

class ChangePinLoading extends ChangePinState{}

class ChangePinSuccess extends ChangePinState{
  ChangePinResponse response;

  ChangePinSuccess({required this.response});

}
class ChangePinError extends ChangePinState{
  String errorMessage;

  ChangePinError({required this.errorMessage});
}
