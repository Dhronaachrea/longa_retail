part of 'inv_flow_bloc.dart';

@immutable
abstract class InvFlowState {}

class InvFlowInitial extends InvFlowState {}

class GettingInvFlowReport extends InvFlowState {}

class GotInvFlowReport extends InvFlowState {
  final InvFlowResponse response;

  GotInvFlowReport({required this.response});
}

class InvFlowReportError extends InvFlowState {
  final String errorMessage;

  InvFlowReportError({required this.errorMessage});
}
