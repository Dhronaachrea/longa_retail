import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static const appPref = "APP_PREF";
  static const userPref = "USER_PREF";

  static const mPlayerToken = "playerToken";
  static const mPlayerId = "playerId";
  static const mLoginResponse = "loginResponse";
  static const drawGameMenuBeanListData = "drawGameMenuBeanListData";
  static const mLotteryMenuBeanList = "lotteryMenuBeanList";

  /*
  static const mScratchMenuBeanList   = "scratchMenuBeanList";
  static const mReportsMenuBeanList   = "reportMenuBeanList";
  static const mUserMenuBeanList      = "userMenuBeanList";*/
  static const mTotalBalance = "totalBalance";
  static const mUserName = "userName";
  static const mOrganisation = "organisation";
  static const mOrganisationID = "organisation_id";
  static const mDomainID = "domain_id";
  static const mDisplayCommission = "displayCommission";
  static const mSelectedPanelData = "selectedPanelData";
  static const mSelectedGameObject = "selectedGameObject";
  static const mLastSaleTicketNo = "lastSaleTicketNo";
  static const mLastSaleGameCode = "lastSaleGameCode";
  static const mVerifyTicketResponse = "verifyTicketResponse";
  static const mCurrencyListConfig = "currencyListConfig";
  static const mCreditLimitConfig = "creditLimitConfig";
  static const mAliasName = "aliasName";
  static const mLanguageConfig = "languageConfig";
  static const mLocalConfig = "localConfig";
  static const mLastWinningTicketNo = "lastWinningTicketNo";
  static const mLastReprintTicketNo = "lastReprintTicketNo";
  static const mLastWinningSaleTicketNo = "lastWinningSaleTicketNo";

  static final SharedPrefUtils _instance = SharedPrefUtils._ctor();

  factory SharedPrefUtils() {
    return _instance;
  }

  SharedPrefUtils._ctor();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // APP_DATA functions

  static setAppStringValue(String key, String value) {
    final String? storedData =
        _prefs.containsKey(appPref) ? _prefs.getString(appPref)! : null;
    Map newData = {key: value};
    Map newDataMap = {};

    if (storedData != null) {
      newDataMap.addAll(jsonDecode(storedData));
      newDataMap.addAll(newData);
    } else {
      newDataMap = newData;
    }

    _prefs.setString(appPref, jsonEncode(newDataMap));
  }

  static setUserStringValue(String key, String value) {
    final String? storedData =
        _prefs.containsKey(userPref) ? _prefs.getString(userPref) : null;
    Map newData = {key: value};
    Map newDataMap = {};

    if (storedData != null) {
      newDataMap.addAll(jsonDecode(storedData));
      newDataMap.addAll(newData);
    } else {
      newDataMap = newData;
    }

    _prefs.setString(userPref, jsonEncode(newDataMap));
  }

  static String getAppStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(appPref) != null
        ? jsonDecode(_prefs.getString(appPref) ?? '')
        : {};

    return allPrefs[key] ?? "";
  }

  static String getStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(userPref) != null
        ? jsonDecode(_prefs.getString(userPref) ?? '')
        : {};
    return allPrefs[key] ?? '';
  }

  static String getUserStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(userPref) != null
        ? jsonDecode(_prefs.getString(userPref) ?? '')
        : {};
    return allPrefs[key] ?? '';
  }

  static Map<String, dynamic> getAllUserPrefs() {
    Map<String, dynamic> allPrefs = _prefs.containsKey(userPref)
        ? jsonDecode(_prefs.getString(userPref)!)
        : {};
    return allPrefs;
  }

  static Map<String, dynamic> getAllAppPrefs() {
    Map<String, dynamic> allPrefs = _prefs.containsKey(appPref)
        ? jsonDecode(_prefs.getString(appPref)!)
        : {};
    return allPrefs;
  }

  static removeValue(String key) {
    return _prefs.remove(key);
  }

  ////////////////////////////// SETTERS  /////////////////////////////////////////

  static set playerToken(String value) =>
      setUserStringValue(mPlayerToken, value);

  static set playerId(String value) => setUserStringValue(mPlayerId, value);

  static set loginResponse(String value) =>
      setUserStringValue(mLoginResponse, value);

  static set drawGameMenuBeanList(String value) =>
      setUserStringValue(drawGameMenuBeanListData, value);

  static set setLotteryMenuBeanList(String value) =>
      setUserStringValue(mLotteryMenuBeanList, value);

  /*static set setLotteryMenuBeanList(String value)   => setUserStringValue(mLotteryMenuBeanList, value);
  static set setScratchMenuBeanList(String value)   => setUserStringValue(mScratchMenuBeanList, value);
  static set setReportsMenuBeanList(String value)   => setUserStringValue(mReportsMenuBeanList, value);
  static set setUserMenuBeanList(String value)      => setUserStringValue(mUserMenuBeanList, value);*/

  static set totalBalance(String value) =>
      setUserStringValue(mTotalBalance, value);

  static set userName(String value) => setUserStringValue(mUserName, value);

  static set displayCommission(String value) =>
      setUserStringValue(mDisplayCommission, value);

  static set organisation(String value) =>
      setUserStringValue(mOrganisation, value);

  static set organisationID(String value) =>
      setAppStringValue(mOrganisationID, value);

  static set domainID(String value) => setAppStringValue(mDomainID, value);

  static set setSelectedPanelData(String value) =>
      setAppStringValue(mSelectedPanelData, value);

  static set setSelectedGameObject(String value) =>
      setAppStringValue(mSelectedGameObject, value);

  static set setLastSaleTicketNo(String value) =>
      setAppStringValue(mLastSaleTicketNo, value);

  static set setLastWinningTicketNo(String value) =>
      setAppStringValue(mLastWinningTicketNo, value);

  static set setLastReprintTicketNo(String value) =>
      setAppStringValue(mLastReprintTicketNo, value);

  static set setLastWinningSaleTicketNo(String value) =>
      setAppStringValue(mLastWinningSaleTicketNo, value);

  static set setDgeLastSaleTicketNo(String value) =>
      setAppStringValue(mLastSaleTicketNo, value);

  static set setDgeLastSaleGameCode(String value) =>
      setAppStringValue(mLastSaleGameCode, value);

  static set setCurrencyListConfig(String value) =>
      setUserStringValue(mCurrencyListConfig, value);

  static set setCreditLimitConfig(String value) =>
      setUserStringValue(mCreditLimitConfig, value);

  static set setAliasName(String value) => setAppStringValue(mAliasName, value);

  static set setLanguageConfig(String value) =>
      setAppStringValue(mLanguageConfig, value);

  static set setLocaleConfig(String value) =>
      setAppStringValue(mLocalConfig, value);

  static set setVerifyTicketResponse(String value) =>
      setUserStringValue(mVerifyTicketResponse, value);

  /////////////////////////// GETTERS //////////////////////////////

  static String get playerToken => getStringValue(mPlayerToken);

  static String get playerId => getStringValue(mPlayerId);

  static String get loginResponse => getUserStringValue(mLoginResponse);

  static String get totalBalance => getUserStringValue(mTotalBalance);

  static String get organisation => getUserStringValue(mOrganisation);

  static String get organisationID => getAppStringValue(mOrganisationID);

  static String get domainID => getAppStringValue(mDomainID);

  static String get userName => getUserStringValue(mUserName);

  static String get displayCommission => getUserStringValue(mDisplayCommission);

  static String get drawGameMenuBeanList =>
      getUserStringValue(drawGameMenuBeanListData);

  static String get getLotteryMenuBeanList =>
      getUserStringValue(mLotteryMenuBeanList);

/*static String get getLotteryMenuBeanList  => getUserStringValue(mLotteryMenuBeanList);
  static String get getScratchMenuBeanList  => getUserStringValue(mScratchMenuBeanList);
  static String get getReportsMenuBeanList  => getUserStringValue(mReportsMenuBeanList);
  static String get getUserMenuBeanList     => getUserStringValue(mUserMenuBeanList);*/

  static String get getDgeLastSaleTicketNo =>
      getAppStringValue(mLastSaleTicketNo);

  static String get getDgeLastSaleGameCode =>
      getAppStringValue(mLastSaleGameCode);

  static String get getSelectedPanelData =>
      getAppStringValue(mSelectedPanelData);

  static String get getSelectedGameObject =>
      getAppStringValue(mSelectedGameObject);

  static String get getLastSaleTicketNo => getAppStringValue(mLastSaleTicketNo);

  static String get getCurrencyListConfig =>
      getUserStringValue(mCurrencyListConfig);

  static String get getCreditLimitConfig =>
      getUserStringValue(mCreditLimitConfig);

  static String get getAliasName => getAppStringValue(mAliasName);

  static String get getVerifyTicketResponse =>
      getUserStringValue(mVerifyTicketResponse);

  static String get getLanguageConfig => getAppStringValue(mLanguageConfig);

  static String get getLocaleConfig => getAppStringValue(mLocalConfig);

  static String get getLastWinningTicketNo =>
      getAppStringValue(mLastWinningTicketNo);

  static String get getLastWinningSaleTicketNo =>
      getAppStringValue(mLastWinningSaleTicketNo);

  static String get getLastReprintTicketNo =>
      getAppStringValue(mLastReprintTicketNo);
}

enum PrefType { appPref, userPref }

extension PrefExtension on PrefType {
  String get value {
    switch (this) {
      case PrefType.appPref:
        return SharedPrefUtils.appPref;
      case PrefType.userPref:
        return SharedPrefUtils.userPref;
    }
  }
}
