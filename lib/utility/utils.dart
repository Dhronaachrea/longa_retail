import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
//import 'package:location/location.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/utility/UrlDrawGameBean.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/shared_pref.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:package_info_plus/package_info_plus.dart';

final navigatorKey = GlobalKey<NavigatorState>();

enum TotalTextFields{userName, password}

enum ButtonShrinkStatus{notStarted, started, over}

encryptMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

formatDate({
  required String date,
  required String inputFormat,
  required String outputFormat,
}) {
  DateFormat inputDateFormat = DateFormat(inputFormat);
  DateTime input = inputDateFormat.parse(date);
  DateFormat outputDateFormat = DateFormat(outputFormat);
  return outputDateFormat.format(input);
}

/* Future<DateTimeRange?> showCalendar(
    BuildContext context, DateTime? firstDate, DateTime? lastDate) async {
  DateTimeRange? pickedDate = await showDateRangePicker(
    context: context,
    //initialDatePickerMode: DatePickerMode.day,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    firstDate: firstDate ?? DateTime(1900),
    lastDate:
    lastDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: WlsPosColor.orangey_red_two,
            onPrimary: WlsPosColor.white,
            onSurface: WlsPosColor.tomato,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
              WlsPosColor.orangey_red_two, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate == null) {
    return null;
  }
  return pickedDate;
}*/

AndroidDeviceInfo? androidInfo;
Future<void> initPlatform() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  androidInfo = await deviceInfo.androidInfo;
  print("androidInfo-----> $androidInfo");
}
Future<DateTime?> showCalendar(BuildContext context, DateTime? initialDate,
    DateTime? firstDate, DateTime? lastDate) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime(1990),
    firstDate: firstDate ?? DateTime(1900),
    lastDate:
    lastDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: LongaLottoPosColor.orangey_red,
            onPrimary: LongaLottoPosColor.white,
            onSurface: LongaLottoPosColor.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: LongaLottoPosColor.icon_green, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  ).then((pickedDate) {
    if (pickedDate == null) {
      return null;
    }
    return pickedDate;
  });
  return pickedDate;
}


DateTime? loginClickTime;

bool isRedundentClick() {
  DateTime currentTime = DateTime.now();
  if (loginClickTime == null) {
    loginClickTime = currentTime;
    return false;
  }
  if (currentTime.difference(loginClickTime!).inMilliseconds < 400) {
    return true;
  }

  loginClickTime = currentTime;
  return false;
}

int nCr(int n, int r) {
  return factorial(n) ~/ (factorial(r) * factorial(n - r));
}

int factorial(int n) {
  int res = 1;
  for (int i = 2; i <= n; i++) {
    res = res * i;
  }
  return res;
}

String getLanguage() {
  return "en";
}

String getDefaultCurrency(String language) {
//For eg -> model.responseData?.data?[0].cURRENCYLIST -> "en#.#UAH#N~uk#,#UAH#N#,";
  //String jsonDomainConfigJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":[{"OTP_TYPE":"BOTH","COUNTRY_CODES":"+91,+57","VERIFY_POS_WITHOUT_TERMINAL_MAPPING":"NO","REPORT_CHUNK_SIZE":"10000","DEFAULT_ORG_STATUS":"ACTIVE","DIRECT_RETAILER_DEFAULT_SETS":"5","ASSIGN_SCHEDULED_COMM_SET":"NO","MAILBOX_PASSWORD":"skill@123","SYSTEM_ALLOWED_CHAINTYPE_CODE":"MAGT","LENGTH_OF_DECIMAL_PLACES":"100.0","PLAYER_KYC_APPROVAL_REQUIRED":"NO","DEFAULT_DATE_FORMAT":"dd/MM/yyyy","ALLOW_LOGIN_FOR_BLOCKED_USER":"NO","OTP_LENGTH":"5","EXTERNAL_CALL_HEADER_CREDENTIAL":"password_p@ssw0rd","RETAIL_PASSWORD_REGEX":"^(?=.*[A-z])(?=.*[0-9])S{8,16}\$","TOKEN_REGEX":"zLDNoM2Q17DMsM2gzIA=","PASSWORD_VALIDITY_CHECK":"YES","ORG_CODE_LOGIC_ID":"1","USER_PER_TXN_LIMIT":"50000","NEGATIVE_DISTRIBUTABLE_LIMIT_ALLOWED":"YES","WINNING_TAX_APPLICABLE":"YES","DEFAULT_TXN_IP":"0.0.0.0","ADDITIONAL_TRANSACTION_DATA":"YES","MIN_WIN_AMOUNT_FOR_PARENT_APPROVAL":"10000000000000000000000000000000000000000","EXPIRY_DURATION_FOR_WRONG_PASSWORD":"10","MAGT_DEFAULT_SETS":"","RET_SUB_USER_ROLE_ID":"9","ALLOWED_CHAIN_TYPE":"1,2,3","MULTIPLE_USER_INVENTORY_ACCESS_ORG_TYPE":"BO,MAGT","ZIPCODE_REGEX":"^[0-9]{6}\$","BO_USER_SYNC_ALLOWED":"YES","OLA_GAME_ID":"1","COUNTRY_CODE":"+57","APP_DOWNLOAD_URL":"http://10.160.10.15:8080/WeaverDoc/commonContent/","AWS_REGION_VALUE":"ap-northeast-1","CURRENCY_ID":"20","CREDIT_LIMIT_DISPLAY_ON_APP":"NO","DATE_FORMAT":"dd-mm-yyyy","USER_PER_DAY_TXN_LIMIT":"1000000","SUB_USER_ALLOWED_ORG_CODES":"BO,MAGT,AGT,RET","RESCHEDULE_ALLOWED":"YES","FAILED_LOGIN_ATTEMPT":"5","THIRDPARTY_USER_SEARCH_ALLOWED":"NO","SYSTEM_ID":"00000000","OTP_EXPIRY":"120000","TDS_APPLICABLE":"NO","PHONE_REGEX":"^(((+){1}91)|((+){1}57)){1}[1-9]{1}[0-9]{6,10}\$","AWS_ACCESS_KEY_ID":"AKIAIQ4LMY2D5YIADY6A","WEAVER_ADMIN_LOGIN":"NO","MOBILE_REGEX":"^(((+){1}91)|((+){1}57)){1}[1-9]{1}[0-9]{6,10}\$","PLAYER_TDS_RATE":"0","PLAYER_TDS_REQUIRED_FOR_NOT_APPROVED_WINNING":"NO","ADVANCED_REGISTRATION_REQUEST_STEPS":"LOCATION,BANKING,PAPER_WORK,BUSINESS_INFO,REGISTER_CERTIFICATE","DEFAULT_BILL_CONFIG":"1","SHORT_CLIENT_NAME":"GELSA","DECIMAL_CHARACTER":".","PASSWORD_VALIDITY_DAYS":"90","ORG_BANK_DETAILS_REQUIRED":"NO","DISPLAY_CURRENCY_SYMBOL":"NO","DEFAULT_RETAILER_SUBUSER_ROLE":"7","USER_DEVICE_MAPPING":"YES","REQUEST_TIMESTAMP_CHECK":"NO","SUBSCRIPTION_MSG_COLOR":"black","IS_B2B_AND_B2C":"NO","RMS_SERVER_URL":"http://10.160.10.55:8082/","DISPLAY_USER_BALANCE":"YES","DAILY_TXN_SUMMARY_NUMBERS":"+919521070688,+918860911222","CONTENT_SERVER_TYPE":"WEAVER_DOC","NUMBER_FORMAT_REQUIRED":"YES","TICKET_SERVER_IP":"http://10.160.10.55:8085/LS","PLAYER_REQUIRED_FOR_NOT_APPROVED_WINNING":"NO","REPORT_MAILS":"saket.sharma@skilrock.com,deepanshu.jain@skilrock.com,nikhlesh.singh@skilrock.com","DEFAULT_INVOICE_STATUS":"DUE","MIN_WIN_AMOUNT_FOR_APPROVAL":"499999","IP_CHECK_FOR_CLIENT_TOKEN":"NO","AGT_SUB_USER_ROLE_ID":"14","BALANCE_CHECK_FOR_PAYOUT":"NO","ORGCODE_REQUIRED_ON_REG":"NO","IS_MAIL_MANDATORY":"YES","REQUEST_TIME_OUT":"120","ALLOW_LOGIN_FOR_EXTERNAL_USER":"NO","MASTER_WAREHOUSE_ID":"1","AMOUNT_LOCALE_FORMATING_REQUIRED":"YES","REGISTRATION_ALLOWED_ORG_TYPE":"BO,MAGT,AGT,RET","USER_CHECK_FOR_TERMINAL":"NO","THIRDPARTY_USER_UPDATE_ALLOWED":"NO","USE_MOBILE_AS_USERNAME":"NO","AWS_SECRET_ACCESS_KEY":"7ZLF6pB1J/8HEhF6PIDAb9v2BZ05Anr3AyfCnBtZ","DECIMAL_FORMATING_REQUIRED":"YES","RESOURCE_DOWNLOAD_URL":"http://10.160.10.15:8080/","REGISTRATION_REQUEST_EXPIRY":"60","SEARCH_LATEST_RECORD_FIRST":"NO","ORG_BANK_DETAILS_MANDATORY":"NO","TERMINAL_LOCATION_DETAILS":"YES","AWS_SENDER_ID":"SKICE","SUBSCRIPTION_MSG":"RMS License Expiring on [DATE]","SMS_ON_PAYMENT":"YES","ALLOWED_WALLET_MODE":"SALE,COMMISSION","LANGUAGE_CODE":"en","MAX_TXN_VALUE_ALLOWED":"1000000000","CLIENT_DOMAIN_NAME":"@acdc.com","EMAIL_UNIQUENESS":"NO","COUNTRY":"CO","NET_AMOUNT_CHECK":"NO","CURRENCY_LIST":"en#.#EUR#N~fr#,#\$#N#,","SETTLEMENT_BLOCKED_DURATION":"5","ALERT_NUMBERS":"+918233738932","MULTIPLE_WAREHOUSE_ALLOWED":"NO","BO_SHUTDOWN":"NO","DEFAULT_DOMAIN_ID":"1","ORGCODE_REGEX":"^.{1,50}\$","SEND_IAM_ROLE_MAIL":"NO","CL_AUTO_APPROVAL_LIMIT":"10","IS_LS_ENABLED":"NO","OLA_NET_COLLECTION_COMM_ALLOWED":"YES","ALLOWED_ORG_CODES":"BO,MAGT,AGT,RET","MOBILE_CODE_MIN_MAX_LENGTH": "","SYSTEM_ALLOWED_LANGUAGES":"en,sp,uk","ENABLE_ORG_POS_ASSIGNMENT_ON_REG":"NO","DUPLICATE_TXN_TIME_CHECK":"1","SECONDARY_DB_SYNC":"NO","MAX_CREDIT_LIMIT":"100000","THIRDPARTY_USER_REQUIRED":"NO","MAILBOX_USERNAME":"skilllottosolution@gmail.com","UPDATE_USER_EMAIL_WHEN_ORG_UPDATE":"YES","domainId":1,"IP_CHECK_FOR_USER_TOKEN":"NO","TDS_RATE":"0","PASSWORD_TYPE":"ALPHANUMERIC","MAX_BULK_PAYMENT_ALLOWED":"500","ENABLE_PAY_IN_ORG_SEARCH":"NO","MAGT_SUB_USER_ROLE_ID":"13","BET_GAMES_ID":"35","LOWER_TIER_ACCESS_ALLOWED":"YES","domainName":"poc.igamew.com","CLINET_TOKEN_GENERATION_ALLOWED":"YES","REPORT_DOWNLOAD_URL":"https://beta.lottoweaver.com/download?path=","IS_BACKEND_GRACE_PERIOD":"NO","MOBILE_UNIQUENESS":"NO","ORG_TERMINATE_DAYS":"30","SEND_IAM_ROLE_SMS":"YES","ROUND_OFF_REQUIRED":"NO","CLIENT_NAME":"GELSA","LOWER_TIER_USER_ACCESS_ALLOWED":"NO","MAILBOX_EMAIL_ID":"skilllottosolution@gmail.com","EMAIL_REGEX":"^S+@S+.S+\$","CALL_US_MESSAGE":"+91XXXXXXXXXX","ALLOWED_DECIMAL_SIZE":"2","SCRIPT_USER_ID":"2","PLAYER_TDS_REQUIRED_FOR_APPROVED_WINNING":"NO","LOG_LOGIN_ACTIVITY":"YES","IS_ORG_MOVEMENT":"YES","DOMAIN_USER_ROLE_ID":"6","IS_ORG_AUTHENTICATION_REQUIRED":"NO","XLS_CSV_ON_SEARCH_ALLOWED":"NO","SUBSCRIPTION_BG_COLOR":"white","SEND_MAIL_WITH_SMS":"YES","DEFAULT_DATETIME_FORMAT":"dd/MM/yyyy HH:mm:ss","CLIENT_TOKEN_REGEX":"zLDNoM2Q17DMsM2gzIA=","PLAYER_REQUIRED_FOR_APPROVED_WINNING":"NO","WAR_NAME":"RMS","USER_VALIDATION_NOT_REQUIRED_ORG_TYPES_FOR_PPL":"","ALLOWED_WALLET_TYPE":"PREPAID","INVALID_CHANGE_PWD_RETRY_ALLOWED":"","PASSWORD_REGEX":"^.{1,50}\$","INVOICE_SYNC_REQUIRED":"NO","SERVER_IP":"10.160.10.55","MULTIPLE_SALE_ALLOWED_ON_SAME_GAME":"YES","LOGIN_WITHOUT_TERMINAL_MAPPING":"NO","USERNAME_REGEX":"^([А-ЩЬЮЯҐЄІЇа-щьюяґєії_]|[a-zA-Z0-9_]){1,50}\$","IS_ZIPCODE_MANDATORY":"NO","MAX_COMMISSION_PERCENT":"90","IS_BO_GRACE_PERIOD":"YES","DEFAULT_CREDIT_LIMIT":"0","FORCE_PASSWORD_UPDATE":"NO","ORG_DEVICE_MAPPING":"YES"}]}}';
  //DomainConfigBean model = DomainConfigBean.fromJson(jsonDecode(jsonDomainConfigJson));
  if (SharedPrefUtils.getCurrencyListConfig.isNotEmpty) {
    List<String> currencyListArray = SharedPrefUtils.getCurrencyListConfig.split("~") ?? [];
    if (currencyListArray.isEmpty) {
      return "";
    }
    for (String aCurrencyListItem in currencyListArray) {
      List<String> languageArray = aCurrencyListItem.split("#");
      if (languageArray[0].toUpperCase() == language.toUpperCase()) {
        return languageArray[2];
      }
    }
  }
  return "";
}


UrlDrawGameBean? getDrawGameUrlDetails(MenuBeanList menuBean, BuildContext context, String tag) {
  UrlDrawGameBean mUrlDrawGameBean = UrlDrawGameBean();

  try {

    var apiDetails                = jsonDecode(menuBean.apiDetails ?? "");
    String relativeUrl            = apiDetails[tag]["url"];
    String baseUrl                = menuBean.basePath ?? "";

    mUrlDrawGameBean.url          = relativeUrl;
    mUrlDrawGameBean.basePath     = baseUrl;
    var headerObjects             = apiDetails[tag]["headers"];

    mUrlDrawGameBean.contentType  = headerObjects["Content-Type"];
    mUrlDrawGameBean.username     = headerObjects["username"];
    mUrlDrawGameBean.password     = headerObjects["password"];

    return mUrlDrawGameBean;

  } catch(e) {
    print("error occure------------->$e");
    return null;
  }
}

const Duration buttonClickThreshold = Duration(seconds: 2);

String getThousandSeparatorFormatAmount(String inputFormat) {
  NumberFormat numberFormat = NumberFormat.decimalPattern('fr');
  String newString = inputFormat.split(".")[0];
  print("numberFormat.format(int.parse(newString)): ${numberFormat.format(int.parse(newString))}");
  return numberFormat.format(int.parse(newString));
}

String getLastResultFromTime(String gameCode) {
  switch(gameCode) {
    case "DailyLotto2" : {
      return get24HrsDateTimeFromCurrentDateTime();
    }

    case "EightByTwentyFour" : {
      return get30MinDateTimeFromCurrentDateTime();
    }

    default : {
      return DateTime.now().toString();
    }
  }
}

get24HrsDateTimeFromCurrentDateTime() {
  return DateTime.now().subtract(const Duration(hours: 24)).toString();
}

get30MinDateTimeFromCurrentDateTime() {
  /*String date = formatDate(
    date: .subtract(const Duration(minutes: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.apiDateFormat3, //2023-10-23 20:40:00 (Expected)
  );*/
  return DateTime.now().subtract(const Duration(minutes: 30)).toString();
}

/// Find first date of previous week using a date in current week.
/// [dateTime] A date in current week.
DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfLastWeek =
  dateTime.subtract(const Duration(days: 7));
  return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
}

/// Find last date of previous week using a date in current week.
/// [dateTime] A date in current week.
DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfLastWeek =
  dateTime.subtract(const Duration(days: 7));
  return findLastDateOfTheWeekForPreviousWeek(sameWeekDayOfLastWeek);
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

DateTime findLastDateOfTheWeekForPreviousWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  //return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  return dateTime;
}
DateTime findFirstDateOfLastMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month-1, 1);
}
DateTime findLastDateOfLastMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month-1);
}
DateTime getLastMonthStartDate(DateTime now) {
  // Create a DateTime for the first day of the current month
  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  // Subtract one day from the first day of the current month to get the last day of the previous month
  DateTime lastDayOfPreviousMonth = firstDayOfMonth.subtract(Duration(days: 1));

  // Create a DateTime for the first day of the previous month
  DateTime firstDayOfPreviousMonth = DateTime(lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

  return firstDayOfPreviousMonth;
}

DateTime getLastMonthEndDate(DateTime now) {
  // Create a DateTime for the first day of the current month
  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

  // Subtract one day from the first day of the current month to get the last day of the previous month
  DateTime lastDayOfPreviousMonth = firstDayOfMonth.subtract(Duration(days: 1));

  return lastDayOfPreviousMonth;
}

String getLanguageWithContext(BuildContext context){
  return LongaLottoRetailApp.of(context).locale.languageCode == "fr" ? "pt": LongaLottoRetailApp.of(context).locale.languageCode ;
}

var maskFormatter = MaskTextInputFormatter(
    mask: '###-######-###',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
);

Future<Position?> getPosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  log("serviceEnabled: $serviceEnabled");
  if (!serviceEnabled) {
    if(context.mounted){
      ShowToast.showToast(context, context.l10n.plz_enable_location, type: ToastType.ERROR);
    }
    return null;
  }
  permission = await Geolocator.checkPermission();
  log("permission: $permission");
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    log(" new permission: $permission");
    if (permission == LocationPermission.denied) {
      if(context.mounted){
        ShowToast.showToast(context, context.l10n.plz_enable_location, type: ToastType.ERROR);
      }
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    if(context.mounted){
      ShowToast.showToast(context, context.l10n.plz_enable_location, type: ToastType.ERROR);
    }
    return null;
  }
 try {
   var currentPosition =  await Geolocator.getCurrentPosition(
       forceAndroidLocationManager: true );
   log("currentPosition : $currentPosition");
   return currentPosition;
 } catch (e){
    return null;

 }
}


/*Future<LocationData?> getLocation(BuildContext context) async {
  // Initialize the location plugin
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  // Check if location services are enabled
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      // Location services are not enabled, handle accordingly
      if(context.mounted){
        ShowToast.showToast(context, context.l10n.plz_enable_location, type: ToastType.ERROR);
      }
      return null;
    }
  }

  // Check if location permission is granted
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      // Location permission not granted, handle accordingly
      if(context.mounted){
        ShowToast.showToast(context, context.l10n.plz_enable_location, type: ToastType.ERROR);
      }
      return null;
    }
  }

  // Get the current location
  try {
    _locationData = await location.getLocation();
    double? latitude = _locationData.latitude;
    double? longitude = _locationData.longitude;

    print('Latitude: $latitude, Longitude: $longitude');
    return _locationData;
  } catch (e) {
    print('Error getting location: $e');
  }
}*/
