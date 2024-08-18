part of 'sale_widget.dart';

class SeriesTicketNumberInfo extends StatelessWidget {
  const SeriesTicketNumberInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.scan_or_enter_series_first_ticket_num,
      style: const TextStyle(
          color: LongaLottoPosColor.brownish_grey_three,
        fontSize: 12,
      ),
    );
  }
}
