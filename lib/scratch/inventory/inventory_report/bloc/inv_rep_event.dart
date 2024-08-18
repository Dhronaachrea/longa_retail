part of 'inv_rep_bloc.dart';

abstract class InvRepEvent {}


class InvRepForRetailer extends InvRepEvent{
  BuildContext context;
  MenuBeanList? menuBeanList;

  InvRepForRetailer({required this.context, this.menuBeanList});
}
