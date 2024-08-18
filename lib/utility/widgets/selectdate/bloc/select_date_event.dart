part of 'select_date_bloc.dart';

@immutable
abstract class SelectDateEvent {}

class PickFromDate extends SelectDateEvent {
  final BuildContext context;

  PickFromDate({required this.context});
}

class PickToDate extends SelectDateEvent {
  final BuildContext context;

  PickToDate({required this.context});
}

class PickToFromDate extends SelectDateEvent {
  final BuildContext context;

  PickToFromDate({required this.context});
}

class SetDate extends SelectDateEvent{
  String fromDate;
  String toDate;
  SetDate({required this.fromDate, required this.toDate});
}
