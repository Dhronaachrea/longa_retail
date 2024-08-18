import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/balance_invoice_report/balance_invoice_report_screen.dart';
import 'package:longalottoretail/balance_invoice_report/bloc/balance_invoice_report_bloc.dart';
import 'package:longalottoretail/commission_report/bloc/commission_bloc.dart';
import 'package:longalottoretail/commission_report/commission_report.dart';
import 'package:longalottoretail/home/bloc/home_bloc.dart';
import 'package:longalottoretail/home/home_screen.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/login_screen.dart';
import 'package:longalottoretail/lottery/lottery_bottom_nav/last_result_dialog/result_preview.dart';
import 'package:longalottoretail/operational_report/bloc/operational_report_bloc.dart';
import 'package:longalottoretail/operational_report/operational_report_screen.dart';
import 'package:longalottoretail/scan_and_play/scan_and_play_screen.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/bloc/inv_flow_bloc.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/inventory_flow_screen.dart';
import 'package:longalottoretail/scratch/inventory/inventory_report/bloc/inv_rep_bloc.dart';
import 'package:longalottoretail/scratch/inventory/inventory_report/inventory_report_screen.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:longalottoretail/scratch/packOrder/pack_order_screen.dart';
import 'package:longalottoretail/scratch/packReceive/pack_receive_screen.dart';
import 'package:longalottoretail/scratch/pack_activation/pack_activation_screen.dart';
import 'package:longalottoretail/scratch/pack_return/pack_return_screen.dart';
import 'package:longalottoretail/scratch/saleTicket/bloc/sale_ticket_bloc.dart';
import 'package:longalottoretail/scratch/saleTicket/sale_ticket_screen.dart';
import 'package:longalottoretail/scratch/scratch_screen.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_bloc.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/ticket_validation_and_claim_screen.dart';
import 'package:longalottoretail/splash/bloc/splash_bloc.dart';
import 'package:longalottoretail/splash/splash_screen.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';

import '../lottery/bloc/lottery_bloc.dart';
import '../lottery/lottery_bottom_nav/winning_claim/bloc/winning_claim_bloc.dart';
import '../lottery/lottery_bottom_nav/winning_claim/winning_claim_screen.dart';
import '../lottery/lottery_screen.dart';

import '../change_pin/bloc/change_pin_bloc.dart';
import '../change_pin/change_pin.dart';
import '../ledger_report/bloc/ledger_report_bloc.dart';
import '../ledger_report/ledger_report_screen.dart';
import '../saleWinTxnReport/bloc/sale_win_bloc.dart';
import '../saleWinTxnReport/sale_win_transaction_report.dart';
import '../summarize_ledger_report/bloc/summarize_ledger_bloc.dart';
import '../summarize_ledger_report/summarize_ledger_report_screen.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import 'package:longalottoretail/lottery/models/response/ResultResponse.dart' as result_response;


class AppRoute {
  router(RouteSettings setting) {
    switch (setting.name) {
      case LongaLottoPosScreen.splashScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<SplashBloc>(
                  create: (BuildContext context) => SplashBloc(),
                )
              ],
              child: const SplashScreen(),
            )
        );

      case LongaLottoPosScreen.homeScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeBloc>(
                      create: (BuildContext context) => HomeBloc(),
                    ),
                    BlocProvider<LoginBloc>(
                      create: (BuildContext context) => LoginBloc(),
                    )
                  ],
                  child: const HomeScreen(),
                ));

      case LongaLottoPosScreen.loginScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<LoginBloc>(
                      create: (BuildContext context) => LoginBloc(),
                    )
                  ],
                  child: const LoginScreen(),
                ));

      case LongaLottoPosScreen.lotteryScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<LotteryBloc>(
                  create: (BuildContext context) => LotteryBloc(),
                ),
                BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(),
                ),
                BlocProvider<WinningClaimBloc> (
                  create: (BuildContext context) => WinningClaimBloc(),
                )
              ],
              child: const LotteryScreen(),
            ));

/*      case LongaLottoPosScreen.gameScreen:
        Map<dynamic, dynamic>? gameDataMap = setting.arguments as Map<dynamic, dynamic>?;
        GameRespVOs gameRespV0s = gameDataMap?["particularObject"] as GameRespVOs;
        List<PickType>? pickTypeList = gameDataMap?["pickTypeList"] as List<PickType>?;
        BetRespVOs? betRespV0s = gameDataMap?["betRespV0s"] as BetRespVOs?;
        List<PanelBean>? panelBeanList = gameDataMap?["panelBeanList"] as List<PanelBean>?;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<LotteryBloc>(
                create: (BuildContext context) => LotteryBloc(),
              )
            ],
            child: GameScreen(particularGameObjects: gameRespV0s, pickType: pickTypeList ?? [], betRespV0s: betRespV0s, mPanelBinList: panelBeanList ?? [])
          ),
        );*/

      case LongaLottoPosScreen.winningClaimScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WinningClaimBloc>(
                  create: (BuildContext context) => WinningClaimBloc(),
                ),
                BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(),
                )
              ],
              child: const WinningClaimScreen(),
            )
        );

      case LongaLottoPosScreen.resultPreviewScreen:
        var args = setting.arguments as List<result_response.ResponseData>?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<LotteryBloc>(
                  create: (BuildContext context) => LotteryBloc(),
                )
              ],
              child: ResultPreview(resultList: args),
            )
        );


      case LongaLottoPosScreen.saleWinTxn:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SaleWinBloc>(
                      create: (BuildContext context) => SaleWinBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: const SaleWinTransactionReport(),
                ));

      case LongaLottoPosScreen.ledgerReportScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<LedgerReportBloc>(
                      create: (BuildContext context) => LedgerReportBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: const LedgerReportScreen(),
                ));

      case LongaLottoPosScreen.operationalReportScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<OperationalReportBloc>(
                      create: (BuildContext context) => OperationalReportBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: const OperationalReportScreen(),
                ));

      case LongaLottoPosScreen.balanceInvoiceReportScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<BalanceInvoiceReportBloc>(
                      create: (BuildContext context) => BalanceInvoiceReportBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: const BalanceInvoiceReportScreen(),
                ));

      case LongaLottoPosScreen.summarizeLedgerReport:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                    BlocProvider<SummarizeLedgerBloc>(
                      create: (BuildContext context) => SummarizeLedgerBloc(),
                    )
                  ],
                  child: const SummarizeLedgerReportScreen(),
                ));

      case LongaLottoPosScreen.changePin:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ChangePinBloc>(
                      create: (BuildContext context) => ChangePinBloc(),
                    )
                  ],
                  child: const ChangePin(),
                ));

        case LongaLottoPosScreen.commissionReportScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<CommissionReportBloc>(
                      create: (BuildContext context) => CommissionReportBloc(),
                    )
                  ],
                  child: const CommissionReportScreen(),
                ));

      case LongaLottoPosScreen.scanAndPlayScreen:
        return MaterialPageRoute(
            builder: (context) => const ScanAndPlayScreen());
      case LongaLottoPosScreen.scratchScreen:
        var scratchMenuBeanList = setting.arguments as List<MenuBeanList>?;
        return MaterialPageRoute(
            builder: (context) => ScratchScreen(scratchMenuBeanList: scratchMenuBeanList));

      case LongaLottoPosScreen.inventoryFlowReportScreen:
        MenuBeanList? menuBeanList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<InvFlowBloc>(
                  create: (BuildContext context) => InvFlowBloc(),
                ),
                BlocProvider<SelectDateBloc>(
                  create: (BuildContext context) => SelectDateBloc(),
                )
              ],
              child: InventoryFlowScreen(menuBeanList: menuBeanList),
            ));

      case LongaLottoPosScreen.inventoryReportScreen:
        MenuBeanList? menuBeanList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<InvRepBloc>(
                  create: (BuildContext context) => InvRepBloc(),
                )
              ],
              child: InventoryReportScreen(menuBeanList: menuBeanList),
            ));

      case LongaLottoPosScreen.packOrderScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<PackBloc>(
                  create: (BuildContext context) => PackBloc(),
                )
              ],
              child: PackOrderScreen(
                scratchList: scratchList,
              ),
            ));

      case LongaLottoPosScreen.packReceiveScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<PackBloc>(
                  create: (BuildContext context) => PackBloc(),
                )
              ],
              child: PackReceiveScreen(
                scratchList: scratchList,
              ),
            ));

      case LongaLottoPosScreen.packActivationScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<PackBloc>(
                  create: (BuildContext context) => PackBloc(),
                )
              ],
              child: PackActivationScreen(
                scratchList: scratchList,
              ),
            ));

      case LongaLottoPosScreen.packReturnScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<PackBloc>(
                  create: (BuildContext context) => PackBloc(),
                )
              ],
              child: PackReturnScreen(
                scratchList: scratchList,
              ),
            ));

      case LongaLottoPosScreen.saleTicketScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<SaleTicketBloc>(
                  create: (BuildContext context) => SaleTicketBloc(),
                ),
                BlocProvider<PackBloc>(
                  create: (BuildContext context) => PackBloc(),
                )
              ],
              child: SaleTicketScreen(
                scratchList: scratchList,
              ),
            ));

      case LongaLottoPosScreen.ticketValidationAndClaimScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<TicketValidationAndClaimBloc>(
                  create: (BuildContext context) =>
                      TicketValidationAndClaimBloc(),
                )
              ],
              child: TicketValidationAndClaimScreen(
                scratchList: scratchList,
              ),
            ));  

      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}
