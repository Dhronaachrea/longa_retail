// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:wls_pos/utility/wls_pos_color.dart';
//
// import '../bloc/date_bloc/date_selector_bloc.dart';
//
// class DateSelector extends StatefulWidget {
//   final Function(String, String) selectedDate;
//
//   const DateSelector({
//     Key? key,
//     required this.selectedDate,
//   }) : super(key: key);
//
//   @override
//   State<DateSelector> createState() => _DateSelectorState();
// }
//
// class _DateSelectorState extends State<DateSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DateSelectorBloc, DateSelectorState>(
//       listener: (context, state) {
//         if (state is SelectedDate) {
//           widget.selectedDate(context.read<DateSelectorBloc>().fromDate,
//               context.read<DateSelectorBloc>().toDate);
//         }
//       },
//       child: InkWell(
//         onTap: () {
//           context.read<DateSelectorBloc>().add(
//                 SelectDate(context: context),
//               );
//         },
//         child: Row(
//           children: [
//             SvgPicture.asset(
//               "assets/icons/calendar.svg",
//               width: 24,
//               height: 24,
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             const Text(
//               "Select Date Range",
//               style: TextStyle(
//                   color: WlsPosColor.orangey_red_two,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: "Roboto",
//                   fontStyle: FontStyle.normal,
//                   fontSize: 12.7),
//               textAlign: TextAlign.left,
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Text(
//                   "${context.read<DateSelectorBloc>().fromDate} to ${context.read<DateSelectorBloc>().toDate}",
//                   style: const TextStyle(
//                       color: WlsPosColor.orangey_red_two,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: "Roboto",
//                       fontStyle: FontStyle.normal,
//                       fontSize: 12.7),
//                   textAlign: TextAlign.left),
//             )
//           ],
//         ).p(10),
//       ),
//     );
//   }
// }
