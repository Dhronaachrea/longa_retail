import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:longalottoretail/l10n/responseCode/responseCodeMsg_eng.dart';
import 'package:longalottoretail/l10n/responseCode/responseCodeMsg_fr.dart';

import '../main.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String? loadLocalizedData(String key, String languageCode) {
  log("Response key => $key , languageCode => $languageCode");
  if (languageCode == "en") {
    return responseCodeMsgEng?[key];
  } else if (languageCode == "fr") {
    return responseCodeMsgFr?[key];
  }
  return null;
}
