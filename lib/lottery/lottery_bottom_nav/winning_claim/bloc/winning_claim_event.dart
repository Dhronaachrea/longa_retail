import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/utility/UrlDrawGameBean.dart';

import '../models/request/ClaimWinPayPwtRequest.dart';

abstract class WinningClaimEvent {}

class TicketVerifyApi extends WinningClaimEvent {
  BuildContext context;
  String ticketNumber;
  UrlDrawGameBean? apiDetails;

  TicketVerifyApi({required this.context, required this.ticketNumber, required this.apiDetails});
}

class ClaimWinPayPwtApi extends WinningClaimEvent {
  BuildContext context;
  ClaimWinPayPwtRequest request;
  UrlDrawGameBean? apiDetails;

  ClaimWinPayPwtApi({required this.context, required this.request,required this.apiDetails});
}

class RePrintApiClaim extends WinningClaimEvent {
  BuildContext context;
  UrlDrawGameBean? apiUrlDetails;
  String? gameCode;
  String? claimTicketNumber;

  RePrintApiClaim({required this.context, required this.apiUrlDetails, this.gameCode, this.claimTicketNumber});
}
