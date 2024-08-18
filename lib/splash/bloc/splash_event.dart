import 'package:flutter/material.dart';

abstract class SplashEvent {}

class VersionControlApi extends SplashEvent {
  final BuildContext context;

  VersionControlApi({required this.context});
}

class GetConfigData extends SplashEvent {
  BuildContext context;

  GetConfigData({required this.context});
}
