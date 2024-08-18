import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';

import '../user_info.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<UpdateUserInfo>(_onUpdateUserEvent);
  }
  String? currencyCode;
  String? referCode;
  String? countryName;
  String? cashBalance;
  String? userName;
  String? totalBalance;
  String? mobNumber;
  String? email;
  String? dob;
  String? gender;
  String? address;
  String? profileImage;
  String? firstName;
  String? lastName;

  FutureOr<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    if (UserInfo.isLoggedIn()) {
      emit(AuthLoggedIn());
    } else {
      emit(AuthLoggedOut());
    }
  }
  FutureOr<void> _onUpdateUserEvent(UpdateUserInfo event, Emitter<AuthState> emit) {

    GetLoginDataResponse response = event.loginDataResponse;

    UserInfo.setTotalBalance("${response.responseData?.data?.balance ?? 0}");

    emit(UserInfoUpdated());
  }
}
