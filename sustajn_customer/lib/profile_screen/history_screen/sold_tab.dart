import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/widgets/no_data_custom_text.dart';

import '../../common_widgets/custom_container.dart';
import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/history_provider.dart';
import '../../utils/utils.dart';
import 'model/detail_model.dart';
import 'model/sold_container_data.dart';

class SoldTab extends ConsumerStatefulWidget {
  final int userId;
  const SoldTab({super.key, required this.userId});

  @override
  ConsumerState<SoldTab> createState() => _SoldTabState();
}

class _SoldTabState extends ConsumerState<SoldTab> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSoldNetworkCall();
  }

  final List<BorrowedDetails> containers = [];

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyProvider);
    return Column(
      children: [
        Expanded(
          child: historyState.soldContainerList.isEmpty
              ? Center(
                  child: NoDataFoundCustomText(text: Strings.NO_SOLD_CONTAINER),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_10),
                  itemCount: historyState.soldContainerList.length,
                  itemBuilder: (context, index) {
                    final month =
                        historyState.soldContainerList[index].monthYear;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _monthHeader(
                          month ?? "",
                          historyState.soldContainerList.length,
                        ),
                        ...historyState
                            .soldContainerList[index]
                            .items!
                            .map((item) => _soldItemCard(item: item)),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: Constant.CONTAINER_SIZE_12),
                ),
        ),
      ],
    );
  }

  // _soldItemCard({required DateWiseSoldContainers item}) {
  //   return Container(
  //     margin: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
  //     child: GlassSummaryCard(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             item.borrowedOn??"",
  //             style: TextStyle(
  //               color: Colors.white70,
  //               fontSize: Constant.CONTAINER_SIZE_12,
  //             ),
  //           ),
  //
  //           SizedBox(height: Constant.SIZE_10),
  //
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
  //                 child: Image.network(
  //                   "${NetworkUrls.BASE_CONTAINER_URL}${item.productImageUrl}",
  //                   errorBuilder: (context, obj, stack) {
  //                     return Image.asset(
  //                       "assets/images/no_image_container.png",
  //                     );
  //                   },
  //                   fit: BoxFit.fill,
  //                   height: Constant.CONTAINER_SIZE_60,
  //                   width: Constant.CONTAINER_SIZE_60,
  //                 ),
  //               ),
  //
  //               SizedBox(width: Constant.CONTAINER_SIZE_14),
  //
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                   children: [
  //                     Text(
  //                       item.productName??"",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: Constant.CONTAINER_SIZE_15,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //
  //                     Text(
  //                       item.productUniqueId??"",
  //                       style: TextStyle(
  //                         color: Colors.white70,
  //                         fontSize: Constant.CONTAINER_SIZE_13,
  //                       ),
  //                     ),
  //
  //                     Text(
  //                       item.soldQuantity.toString(),
  //                       style: TextStyle(
  //                         color: Colors.white60,
  //                         fontSize: Constant.CONTAINER_SIZE_12,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Image.asset(
  //                         'assets/images/img.png',
  //                         height: Constant.CONTAINER_SIZE_16,
  //                         width: Constant.CONTAINER_SIZE_16,
  //                       ),
  //                       SizedBox(width: Constant.SIZE_04),
  //
  //                       Text(
  //                         item.soldQuantity.toString(),
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: Constant.CONTAINER_SIZE_14,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.currency_rupee,
  //                         size: Constant.CONTAINER_SIZE_18,
  //                         color: Colors.white,
  //                       ),
  //                       Text(
  //                         item.soldAmount.toString(),
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: Constant.CONTAINER_SIZE_18,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _soldItemCard({required DateWiseSoldContainers item}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF184D3B), Color(0xFF0E3A2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dateItem(
                    title: "Borrowed on:",
                    value: item.borrowedOn ?? "",
                  ),
                  _dateItem(title: "Due on:", value: item.dueOn ?? ""),
                  _dateItem(title: "Sold on:", value: item.soldOn ?? ""),
                ],
              ),

              const SizedBox(height: 14),

              Divider(color: Colors.white.withOpacity(0.15), height: 1),

              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "${NetworkUrls.BASE_CONTAINER_URL}${item.imageUrl}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/no_image_container.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.productUniqueId ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${item.capacity}ml",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/img.png',
                            height: Constant.CONTAINER_SIZE_16,
                            width: Constant.CONTAINER_SIZE_16,
                          ),
                          SizedBox(width: Constant.SIZE_04),
                          Text(
                            item.soldQuantity?.toString() ?? "",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Image.asset(
                            'assets/images/diarhm.png',
                            height: Constant.CONTAINER_SIZE_16,
                            color: Constant.orange,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          SizedBox(width: Constant.SIZE_02),
                          Text(
                            item.soldQuantity?.toString() ?? "",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Color(0xFFE5C84B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _monthHeader(String title, int count) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_16,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: Constant.CONTAINER_SIZE_15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _getSoldNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(historyProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.GET_SOLD_CONTAINER}$userId';
          ref.read(getSoldContainerProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}
