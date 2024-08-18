part of 'inv_widget.dart';

class InvRepDetail {
  show({
    required BuildContext context,
    required String title,
    required List<InvRepDetailsModel> invRepDetailList,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        List<Widget> packListTabs = invRepDetailList.map((element) {
          return Tab(
            child: Text(
              element.title,
            ),
          );
        }).toList();

        var packListView = invRepDetailList
            .map(
              (element) => ListView.builder(
                itemCount: element.packList?.length,
                itemBuilder: (ctx, index) {
                  return Text(
                    element.packList![index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ).pOnly(top: 10),
            )
            .toList();
        return StatefulBuilder(
          builder: (context, StateSetter setInnerState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: context.screenHeight * 0.2),
              backgroundColor: LongaLottoPosColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: invRepDetailList.isEmpty
                  ? Center(
                      child: Text(
                      context.l10n.no_data_available_to_preview,
                      style: const TextStyle(
                          color: LongaLottoPosColor.brownish_grey,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Arial",
                          fontStyle: FontStyle.normal,
                          fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ).p(8))
                  : DefaultTabController(
                      length: invRepDetailList.length,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const HeightBox(10),
                          alertTitle(title),
                          const HeightBox(20),
                          SizedBox(
                            height: 20,
                            child: TabBar(
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              indicatorColor: LongaLottoPosColor.white,
                              unselectedLabelColor: LongaLottoPosColor.warm_grey_four,
                              labelColor: LongaLottoPosColor.tomato,
                              tabs: packListTabs,
                            ),
                          ),
                          const Divider(
                            color: LongaLottoPosColor.warm_grey_four,
                            thickness: 1,
                            height: 15,
                          ),
                          Expanded(
                              child: TabBarView(
                            children: packListView,
                          )),
                        ],
                      ).pSymmetric(v: 20, h: 20),
                    ),
            );
          },
        );
      },
    );
  }

  static alertTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: LongaLottoPosColor.warm_grey_four, width: 2)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: LongaLottoPosColor.black),
      ),
    );
  }
}
