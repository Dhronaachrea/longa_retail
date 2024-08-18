part of 'inv_rep_bloc.dart';

@immutable
abstract class InvRepState {}

class InvRepInitial extends InvRepState {}

class GettingInvRepForRet extends InvRepState {}

class GotInvRepForRet extends InvRepState {
  final InvRepResponse response;

  GotInvRepForRet({required this.response});
}

class InvRepForRetError extends InvRepState {
  final String errorMessage;

  InvRepForRetError({required this.errorMessage});
}
