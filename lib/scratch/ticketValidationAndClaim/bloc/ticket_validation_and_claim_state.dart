
import '../model/response/ticket_claim_response.dart';
import '../model/response/ticket_validation_response.dart';

abstract class TicketValidationAndClaimState {}

class TicketValidationAndClaimInitial extends TicketValidationAndClaimState {}

class TicketValidationAndClaimLoading extends TicketValidationAndClaimState {}

class TicketValidationAndClaimSuccess extends TicketValidationAndClaimState {
  TicketValidationResponse response;

  TicketValidationAndClaimSuccess({required this.response});
}

class TicketValidationAndClaimError extends TicketValidationAndClaimState {
  String errorMessage;

  TicketValidationAndClaimError({required this.errorMessage});
}


class TicketClaimInitial extends TicketValidationAndClaimState {}

class TicketClaimLoading extends TicketValidationAndClaimState {}

class TicketClaimSuccess extends TicketValidationAndClaimState {
  TicketClaimResponse response;

  TicketClaimSuccess({required this.response});
}

class TicketClaimError extends TicketValidationAndClaimState {
  String errorMessage;

  TicketClaimError({required this.errorMessage});
}
