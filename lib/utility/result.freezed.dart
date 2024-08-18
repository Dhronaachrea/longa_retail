// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Result<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(T data) networkFault,
    required TResult Function(T data) responseSuccess,
    required TResult Function(T? data) responseFailure,
    required TResult Function(T? data) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(T data)? networkFault,
    TResult? Function(T data)? responseSuccess,
    TResult? Function(T? data)? responseFailure,
    TResult? Function(T? data)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(T data)? networkFault,
    TResult Function(T data)? responseSuccess,
    TResult Function(T? data)? responseFailure,
    TResult Function(T? data)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T> value) idle,
    required TResult Function(NetworkFault<T> value) networkFault,
    required TResult Function(ResponseSuccess<T> value) responseSuccess,
    required TResult Function(ResponseFailure<T> value) responseFailure,
    required TResult Function(Failure<T> value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle<T> value)? idle,
    TResult? Function(NetworkFault<T> value)? networkFault,
    TResult? Function(ResponseSuccess<T> value)? responseSuccess,
    TResult? Function(ResponseFailure<T> value)? responseFailure,
    TResult? Function(Failure<T> value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T> value)? idle,
    TResult Function(NetworkFault<T> value)? networkFault,
    TResult Function(ResponseSuccess<T> value)? responseSuccess,
    TResult Function(ResponseFailure<T> value)? responseFailure,
    TResult Function(Failure<T> value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<T, $Res> {
  factory $ResultCopyWith(Result<T> value, $Res Function(Result<T>) then) =
      _$ResultCopyWithImpl<T, $Res, Result<T>>;
}

/// @nodoc
class _$ResultCopyWithImpl<T, $Res, $Val extends Result<T>>
    implements $ResultCopyWith<T, $Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$IdleCopyWith<T, $Res> {
  factory _$$IdleCopyWith(_$Idle<T> value, $Res Function(_$Idle<T>) then) =
      __$$IdleCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$IdleCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$Idle<T>>
    implements _$$IdleCopyWith<T, $Res> {
  __$$IdleCopyWithImpl(_$Idle<T> _value, $Res Function(_$Idle<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$Idle<T> with DiagnosticableTreeMixin implements Idle<T> {
  const _$Idle();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.idle()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'Result<$T>.idle'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Idle<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(T data) networkFault,
    required TResult Function(T data) responseSuccess,
    required TResult Function(T? data) responseFailure,
    required TResult Function(T? data) failure,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(T data)? networkFault,
    TResult? Function(T data)? responseSuccess,
    TResult? Function(T? data)? responseFailure,
    TResult? Function(T? data)? failure,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(T data)? networkFault,
    TResult Function(T data)? responseSuccess,
    TResult Function(T? data)? responseFailure,
    TResult Function(T? data)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T> value) idle,
    required TResult Function(NetworkFault<T> value) networkFault,
    required TResult Function(ResponseSuccess<T> value) responseSuccess,
    required TResult Function(ResponseFailure<T> value) responseFailure,
    required TResult Function(Failure<T> value) failure,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle<T> value)? idle,
    TResult? Function(NetworkFault<T> value)? networkFault,
    TResult? Function(ResponseSuccess<T> value)? responseSuccess,
    TResult? Function(ResponseFailure<T> value)? responseFailure,
    TResult? Function(Failure<T> value)? failure,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T> value)? idle,
    TResult Function(NetworkFault<T> value)? networkFault,
    TResult Function(ResponseSuccess<T> value)? responseSuccess,
    TResult Function(ResponseFailure<T> value)? responseFailure,
    TResult Function(Failure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class Idle<T> implements Result<T> {
  const factory Idle() = _$Idle<T>;
}

/// @nodoc
abstract class _$$NetworkFaultCopyWith<T, $Res> {
  factory _$$NetworkFaultCopyWith(
          _$NetworkFault<T> value, $Res Function(_$NetworkFault<T>) then) =
      __$$NetworkFaultCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$NetworkFaultCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$NetworkFault<T>>
    implements _$$NetworkFaultCopyWith<T, $Res> {
  __$$NetworkFaultCopyWithImpl(
      _$NetworkFault<T> _value, $Res Function(_$NetworkFault<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$NetworkFault<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$NetworkFault<T>
    with DiagnosticableTreeMixin
    implements NetworkFault<T> {
  const _$NetworkFault({required this.data});

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.networkFault(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.networkFault'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFault<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFaultCopyWith<T, _$NetworkFault<T>> get copyWith =>
      __$$NetworkFaultCopyWithImpl<T, _$NetworkFault<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(T data) networkFault,
    required TResult Function(T data) responseSuccess,
    required TResult Function(T? data) responseFailure,
    required TResult Function(T? data) failure,
  }) {
    return networkFault(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(T data)? networkFault,
    TResult? Function(T data)? responseSuccess,
    TResult? Function(T? data)? responseFailure,
    TResult? Function(T? data)? failure,
  }) {
    return networkFault?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(T data)? networkFault,
    TResult Function(T data)? responseSuccess,
    TResult Function(T? data)? responseFailure,
    TResult Function(T? data)? failure,
    required TResult orElse(),
  }) {
    if (networkFault != null) {
      return networkFault(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T> value) idle,
    required TResult Function(NetworkFault<T> value) networkFault,
    required TResult Function(ResponseSuccess<T> value) responseSuccess,
    required TResult Function(ResponseFailure<T> value) responseFailure,
    required TResult Function(Failure<T> value) failure,
  }) {
    return networkFault(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle<T> value)? idle,
    TResult? Function(NetworkFault<T> value)? networkFault,
    TResult? Function(ResponseSuccess<T> value)? responseSuccess,
    TResult? Function(ResponseFailure<T> value)? responseFailure,
    TResult? Function(Failure<T> value)? failure,
  }) {
    return networkFault?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T> value)? idle,
    TResult Function(NetworkFault<T> value)? networkFault,
    TResult Function(ResponseSuccess<T> value)? responseSuccess,
    TResult Function(ResponseFailure<T> value)? responseFailure,
    TResult Function(Failure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (networkFault != null) {
      return networkFault(this);
    }
    return orElse();
  }
}

abstract class NetworkFault<T> implements Result<T> {
  const factory NetworkFault({required final T data}) = _$NetworkFault<T>;

  T get data;
  @JsonKey(ignore: true)
  _$$NetworkFaultCopyWith<T, _$NetworkFault<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResponseSuccessCopyWith<T, $Res> {
  factory _$$ResponseSuccessCopyWith(_$ResponseSuccess<T> value,
          $Res Function(_$ResponseSuccess<T>) then) =
      __$$ResponseSuccessCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$ResponseSuccessCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$ResponseSuccess<T>>
    implements _$$ResponseSuccessCopyWith<T, $Res> {
  __$$ResponseSuccessCopyWithImpl(
      _$ResponseSuccess<T> _value, $Res Function(_$ResponseSuccess<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$ResponseSuccess<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$ResponseSuccess<T>
    with DiagnosticableTreeMixin
    implements ResponseSuccess<T> {
  const _$ResponseSuccess({required this.data});

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.responseSuccess(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.responseSuccess'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseSuccess<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseSuccessCopyWith<T, _$ResponseSuccess<T>> get copyWith =>
      __$$ResponseSuccessCopyWithImpl<T, _$ResponseSuccess<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(T data) networkFault,
    required TResult Function(T data) responseSuccess,
    required TResult Function(T? data) responseFailure,
    required TResult Function(T? data) failure,
  }) {
    return responseSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(T data)? networkFault,
    TResult? Function(T data)? responseSuccess,
    TResult? Function(T? data)? responseFailure,
    TResult? Function(T? data)? failure,
  }) {
    return responseSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(T data)? networkFault,
    TResult Function(T data)? responseSuccess,
    TResult Function(T? data)? responseFailure,
    TResult Function(T? data)? failure,
    required TResult orElse(),
  }) {
    if (responseSuccess != null) {
      return responseSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T> value) idle,
    required TResult Function(NetworkFault<T> value) networkFault,
    required TResult Function(ResponseSuccess<T> value) responseSuccess,
    required TResult Function(ResponseFailure<T> value) responseFailure,
    required TResult Function(Failure<T> value) failure,
  }) {
    return responseSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle<T> value)? idle,
    TResult? Function(NetworkFault<T> value)? networkFault,
    TResult? Function(ResponseSuccess<T> value)? responseSuccess,
    TResult? Function(ResponseFailure<T> value)? responseFailure,
    TResult? Function(Failure<T> value)? failure,
  }) {
    return responseSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T> value)? idle,
    TResult Function(NetworkFault<T> value)? networkFault,
    TResult Function(ResponseSuccess<T> value)? responseSuccess,
    TResult Function(ResponseFailure<T> value)? responseFailure,
    TResult Function(Failure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (responseSuccess != null) {
      return responseSuccess(this);
    }
    return orElse();
  }
}

abstract class ResponseSuccess<T> implements Result<T> {
  const factory ResponseSuccess({required final T data}) = _$ResponseSuccess<T>;

  T get data;
  @JsonKey(ignore: true)
  _$$ResponseSuccessCopyWith<T, _$ResponseSuccess<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResponseFailureCopyWith<T, $Res> {
  factory _$$ResponseFailureCopyWith(_$ResponseFailure<T> value,
          $Res Function(_$ResponseFailure<T>) then) =
      __$$ResponseFailureCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T? data});
}

/// @nodoc
class __$$ResponseFailureCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$ResponseFailure<T>>
    implements _$$ResponseFailureCopyWith<T, $Res> {
  __$$ResponseFailureCopyWithImpl(
      _$ResponseFailure<T> _value, $Res Function(_$ResponseFailure<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$ResponseFailure<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$ResponseFailure<T>
    with DiagnosticableTreeMixin
    implements ResponseFailure<T> {
  const _$ResponseFailure({required this.data});

  @override
  final T? data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.responseFailure(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.responseFailure'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseFailure<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseFailureCopyWith<T, _$ResponseFailure<T>> get copyWith =>
      __$$ResponseFailureCopyWithImpl<T, _$ResponseFailure<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(T data) networkFault,
    required TResult Function(T data) responseSuccess,
    required TResult Function(T? data) responseFailure,
    required TResult Function(T? data) failure,
  }) {
    return responseFailure(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(T data)? networkFault,
    TResult? Function(T data)? responseSuccess,
    TResult? Function(T? data)? responseFailure,
    TResult? Function(T? data)? failure,
  }) {
    return responseFailure?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(T data)? networkFault,
    TResult Function(T data)? responseSuccess,
    TResult Function(T? data)? responseFailure,
    TResult Function(T? data)? failure,
    required TResult orElse(),
  }) {
    if (responseFailure != null) {
      return responseFailure(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T> value) idle,
    required TResult Function(NetworkFault<T> value) networkFault,
    required TResult Function(ResponseSuccess<T> value) responseSuccess,
    required TResult Function(ResponseFailure<T> value) responseFailure,
    required TResult Function(Failure<T> value) failure,
  }) {
    return responseFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle<T> value)? idle,
    TResult? Function(NetworkFault<T> value)? networkFault,
    TResult? Function(ResponseSuccess<T> value)? responseSuccess,
    TResult? Function(ResponseFailure<T> value)? responseFailure,
    TResult? Function(Failure<T> value)? failure,
  }) {
    return responseFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T> value)? idle,
    TResult Function(NetworkFault<T> value)? networkFault,
    TResult Function(ResponseSuccess<T> value)? responseSuccess,
    TResult Function(ResponseFailure<T> value)? responseFailure,
    TResult Function(Failure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (responseFailure != null) {
      return responseFailure(this);
    }
    return orElse();
  }
}

abstract class ResponseFailure<T> implements Result<T> {
  const factory ResponseFailure({required final T? data}) =
      _$ResponseFailure<T>;

  T? get data;
  @JsonKey(ignore: true)
  _$$ResponseFailureCopyWith<T, _$ResponseFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailureCopyWith<T, $Res> {
  factory _$$FailureCopyWith(
          _$Failure<T> value, $Res Function(_$Failure<T>) then) =
      __$$FailureCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T? data});
}

/// @nodoc
class __$$FailureCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$Failure<T>>
    implements _$$FailureCopyWith<T, $Res> {
  __$$FailureCopyWithImpl(
      _$Failure<T> _value, $Res Function(_$Failure<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$Failure<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$Failure<T> with DiagnosticableTreeMixin implements Failure<T> {
  const _$Failure({required this.data});

  @override
  final T? data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.failure(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.failure'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Failure<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureCopyWith<T, _$Failure<T>> get copyWith =>
      __$$FailureCopyWithImpl<T, _$Failure<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(T data) networkFault,
    required TResult Function(T data) responseSuccess,
    required TResult Function(T? data) responseFailure,
    required TResult Function(T? data) failure,
  }) {
    return failure(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(T data)? networkFault,
    TResult? Function(T data)? responseSuccess,
    TResult? Function(T? data)? responseFailure,
    TResult? Function(T? data)? failure,
  }) {
    return failure?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(T data)? networkFault,
    TResult Function(T data)? responseSuccess,
    TResult Function(T? data)? responseFailure,
    TResult Function(T? data)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T> value) idle,
    required TResult Function(NetworkFault<T> value) networkFault,
    required TResult Function(ResponseSuccess<T> value) responseSuccess,
    required TResult Function(ResponseFailure<T> value) responseFailure,
    required TResult Function(Failure<T> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle<T> value)? idle,
    TResult? Function(NetworkFault<T> value)? networkFault,
    TResult? Function(ResponseSuccess<T> value)? responseSuccess,
    TResult? Function(ResponseFailure<T> value)? responseFailure,
    TResult? Function(Failure<T> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T> value)? idle,
    TResult Function(NetworkFault<T> value)? networkFault,
    TResult Function(ResponseSuccess<T> value)? responseSuccess,
    TResult Function(ResponseFailure<T> value)? responseFailure,
    TResult Function(Failure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class Failure<T> implements Result<T> {
  const factory Failure({required final T? data}) = _$Failure<T>;

  T? get data;
  @JsonKey(ignore: true)
  _$$FailureCopyWith<T, _$Failure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
