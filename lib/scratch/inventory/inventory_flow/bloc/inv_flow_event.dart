part of 'inv_flow_bloc.dart';

@immutable
abstract class InvFlowEvent {}

class InvFlowReport extends InvFlowEvent {
  final BuildContext context;
  final MenuBeanList? menuBeanList;
  final String startDate;
  final String endDate;

  InvFlowReport({
    required this.context,
    required this.menuBeanList,
    required this.startDate,
    required this.endDate,
  });
}
