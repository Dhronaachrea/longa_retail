import 'package:flutter/cupertino.dart';

abstract class DepositEvent {}

class DepositApiData extends DepositEvent {
  BuildContext context;
  String url;
  String retailerName;
  String amount;

  DepositApiData(
      {required this.context,
      required this.url,
      required this.retailerName,
      required this.amount});

}


class CouponReversalApi extends DepositEvent {
  BuildContext context;
  String couponCode;

  CouponReversalApi(
      {required this.context,
        required this.couponCode});

}

