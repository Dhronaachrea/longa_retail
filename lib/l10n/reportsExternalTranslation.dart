import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/l10n/l10n.dart';

String getTranslatedString(BuildContext context, String inputString) {
  switch(inputString) {
    case "Draw Game"  : return context.l10n.draw_game;
    case "Sale"       : return context.l10n.sale;
    case "Sale Return"    : return context.l10n.winning;
    case "Winning"    : return context.l10n.winning;
    case "Credit"    : return context.l10n.credit;
    case "Debit"    : return context.l10n.debit;
    case "Cash Payment By"    : return context.l10n.cash_payment_by;
    case "Credit Note By"    : return context.l10n.credit_note_by;
    case "Debit Note BY"    : return context.l10n.debit_note_by;
    case "Retail Payments"    : return context.l10n.retail_payments;
    case "Player And Management"    : return context.l10n.player_and_management;

    default           : return inputString;
  }
}