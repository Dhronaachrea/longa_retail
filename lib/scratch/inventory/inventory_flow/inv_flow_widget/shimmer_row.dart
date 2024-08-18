part of 'inv_flow_widget.dart';

class ShimmerRow extends StatelessWidget {
  const ShimmerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 30,
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[400]!),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 30,
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: LongaLottoPosColor.white),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 30,
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: LongaLottoPosColor.white_five_two),
          ),
        ),
      ],
    ).pSymmetric(h: 8, v: 2);
  }
}
