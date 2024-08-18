part of 'inv_flow_widget.dart';

class FlowTableRow extends StatefulWidget {
  final bool detailTypeName;
  final String typeName;
  final String booksOfType;
  final String ticketsOfType;
  final VoidCallback onTap;

  const FlowTableRow({
    Key? key,
    this.detailTypeName = false,
    required this.typeName,
    required this.booksOfType,
    required this.ticketsOfType,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FlowTableRow> createState() => _FlowTableRowState();
}

class _FlowTableRowState extends State<FlowTableRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              widget.onTap();
            },
            child: Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: widget.detailTypeName
                        ? LongaLottoPosColor.white
                        : LongaLottoPosColor.faded_blue),
                child: Text(widget.typeName,
                    style: TextStyle(
                        color: widget.detailTypeName
                            ? LongaLottoPosColor.brownish_grey_two
                            : LongaLottoPosColor.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.center)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: widget.detailTypeName
                    ? LongaLottoPosColor.light_blue_grey
                    : LongaLottoPosColor.light_blue_grey),
            child: Text(widget.booksOfType,
                style: const TextStyle(
                    color: LongaLottoPosColor.brownish_grey_two,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                textAlign: TextAlign.center),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: widget.detailTypeName
                    ? LongaLottoPosColor.white
                    : LongaLottoPosColor.white_five_two),
            child: Text(widget.ticketsOfType,
                style: const TextStyle(
                    color: LongaLottoPosColor.brownish_grey_two,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                textAlign: TextAlign.center),
          ),
        ),
      ],
    ).pSymmetric(h: 8, v: 2);
  }
}
