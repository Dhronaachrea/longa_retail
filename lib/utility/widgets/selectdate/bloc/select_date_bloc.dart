import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:longalottoretail/utility/date_format.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:meta/meta.dart';

part 'select_date_event.dart';

part 'select_date_state.dart';

class SelectDateBloc extends Bloc<SelectDateEvent, SelectDateState> {
  SelectDateBloc() : super(SelectDateInitial()) {
    on<PickFromDate>(_onPickFromDate);
    on<PickToDate>(_onPickToDate);
    on<SetDate>(_onSetDate);
  }

  String fromDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );

  String toGameDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.apiDateFormat3,
  );

  String fromGameDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.apiDateFormat3,
  );

  String toDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );

  DateTime? toCustomPickedFirstDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toCustomPickedDate       = DateTime.now();
  DateTime fromCustomPickedLastDate = DateTime.now();
  DateTime fromCustomPickedDate     = DateTime.now().subtract(const Duration(days: 30));

  FutureOr<void> _onPickFromDate(
      PickFromDate event, Emitter<SelectDateState> emit) async {
    BuildContext context = event.context;
    print("-"*100);
    print("pick from initialDate: $fromCustomPickedDate");
    print("pick from firstDate: null");
    print("pick from lastDate: $fromCustomPickedLastDate");
    print("-"*100);

    DateTime? pickedDate = await showCalendar(
        context,
        fromCustomPickedDate,
        null,
        fromCustomPickedLastDate
    );
    if (pickedDate != null) {
      fromDate = formatDate(
        date: DateFormat(Format.calendarFormat).format(pickedDate),
        inputFormat: Format.calendarFormat,
        outputFormat: Format.dateFormat9,
      );

      String fromGameDate = formatDate(
        date: fromDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      );

      toCustomPickedDate = DateFormat("dd-MM-yyyy").parse(fromDate);
      toCustomPickedFirstDate =  DateFormat("dd-MM-yyyy").parse(fromDate);

      emit(DateUpdated(toDate: toGameDate, fromDate: fromGameDate));
    }
  }

  FutureOr<void> _onPickToDate(
      PickToDate event, Emitter<SelectDateState> emit) async {
    BuildContext context = event.context;
/*    DateTime? pickedDate =
        await showCalendar(context, DateFormat("dd-MM-yyyy").parse(fromDate), null, DateTime.now());
    if (pickedDate != null) {
      toDate = formatDate(
        date: DateFormat(Format.calendarFormat).format(pickedDate),
        inputFormat: Format.calendarFormat,
        outputFormat: Format.dateFormat9,
      );

      String toGameDate = formatDate(
        date: toDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      );*/

    DateTime? pickedDate =
    await showCalendar(context, toCustomPickedDate, toCustomPickedFirstDate, DateTime.now());
    if (pickedDate != null) {
      toDate = formatDate(
        date: DateFormat(Format.calendarFormat).format(pickedDate),
        inputFormat: Format.calendarFormat,
        outputFormat: Format.dateFormat9,
      );

      String toGameDate = formatDate(
        date: toDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      );

      /*fromCustomPickedDate = DateFormat("dd-MM-yyyy").parse(toDate);
      fromCustomPickedLastDate = DateFormat("dd-MM-yyyy").parse(toDate);*/
      fromCustomPickedDate = DateFormat("dd-MM-yyyy").parse(toDate).subtract(const Duration(days: 30));
      fromCustomPickedLastDate = DateFormat("dd-MM-yyyy").parse(toDate);
      /*print("toDate: $toDate");
      print("fromDate: $fromDate");*/

      emit(DateUpdated(toDate: toGameDate, fromDate: fromGameDate));
    }
  }

  FutureOr<void> _onSetDate(SetDate event, Emitter<SelectDateState> emit) {
    fromDate = formatDate(
      date: event.fromDate,
      inputFormat: Format.apiDateFormat3,
      outputFormat: Format.dateFormat9,
    );
    toDate = formatDate(
      date: event.toDate,
      inputFormat: Format.apiDateFormat3,
      outputFormat: Format.dateFormat9,
    );
    emit(DateUpdated(toDate: toDate, fromDate: fromDate));
  }
}
