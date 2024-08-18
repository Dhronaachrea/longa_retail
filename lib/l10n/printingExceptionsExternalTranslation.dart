import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/l10n/l10n.dart';

String getPrintingFailedTranslatedMsg(BuildContext context, String inputString) {
  switch(inputString) {
    case "Please insert the paper before printing"        : return context.l10n.please_insert_the_paper_before_printing;
    case "Device overheated, Please try after some time." : return context.l10n.device_overheated_please_try_after_some_time;
    case "Something went wrong while printing"            : return context.l10n.something_went_wrong_while_printing;
    case "Unable to print, Please try after some time."   : return context.l10n.unable_to_print_please_try_after_some_time;
    case "Low battery, Please charge the device !"        : return context.l10n.low_battery_please_charge_the_device;
    default   : return inputString;
  }
}