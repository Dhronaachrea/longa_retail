import 'package:flutter/cupertino.dart';

abstract class HomeEvent {}

class GetUserMenuListApiData extends HomeEvent {
  BuildContext context;

  GetUserMenuListApiData({required this.context});
}

class GetConfigData extends HomeEvent {
  BuildContext context;

  GetConfigData({required this.context});
}
