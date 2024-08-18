import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {

  const factory Result.idle() = Idle<T>;

  const factory Result.networkFault({required T data}) = NetworkFault<T>;

  const factory Result.responseSuccess({required T data}) = ResponseSuccess<T>;

  const factory Result.responseFailure({required T? data}) = ResponseFailure<T>;

  const factory Result.failure({required T? data}) = Failure<T>;
}