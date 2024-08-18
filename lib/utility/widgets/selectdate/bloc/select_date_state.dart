part of 'select_date_bloc.dart';

@immutable
abstract class SelectDateState {}

class SelectDateInitial extends SelectDateState {}
// class DateUpdated extends SelectDateState {}

class DateUpdated extends SelectDateState{
  String toDate;
  String fromDate;

  DateUpdated({required this.toDate, required this.fromDate});

}

