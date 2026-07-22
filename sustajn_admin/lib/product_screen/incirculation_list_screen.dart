import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../provider/order_provider.dart';

class InCirculationListScreen extends ConsumerStatefulWidget {
  const InCirculationListScreen({super.key});

  @override
  ConsumerState<InCirculationListScreen> createState() =>
      _InCirculationScreenState();
}

class _InCirculationScreenState
    extends ConsumerState<InCirculationListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _getIncirculationNetworkCall();
  }

  final List<Map<String, dynamic>> users = [
    {"id": "ROBE-2323", "qty": 2},
    {"id": "BESS-1323", "qty": 10},
    {"id": "KATH-2312", "qty": 1},
    {"id": "DEVO-2123", "qty": 4},
    {"id": "CAME-1232", "qty": 2},
    {"id": "JACO-3222", "qty": 5},
    {"id": "ARLE-2123", "qty": 9},
    {"id": "ALBE-1865", "qty": 6},
    {"id": "KIRA-1644", "qty": 3},
    {"id": "LIMS-1432", "qty": 2},
  ];

  @override
  Widget build(BuildContext context, ) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    final list = orderState.getIncirculationList;

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.INCRICULATION,
        leading: CustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ).getAppBar(context),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Constant.PrimaryColor,
                Constant.PrimaryColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
                child: Container(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                    border: Border.all(
                      color: Colors.white30,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: Constant.CONTAINER_SIZE_55,
                        width: Constant.CONTAINER_SIZE_55,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(Constant.SIZE_08),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Constant.SIZE_08),
                          child: list.isNotEmpty
                              ? Image.network(
                            "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${list.first.imageUrl}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/images/no_image_container.png");
                            },
                          )
                              : Image.asset("assets/images/no_image_container.png"),
                        ),
                      ),
                      SizedBox(width: Constant.CONTAINER_SIZE_12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              list.isNotEmpty ? list.first.name ?? "" : "",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: Constant.SIZE_02),
                            Text(
                              list.isNotEmpty ? list.first.productId ?? "" : "",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: Constant.CONTAINER_SIZE_13,
                              ),
                            ),
                            SizedBox(height: Constant.SIZE_04),
                            Text(
                              list.isNotEmpty
                                  ? "${list.first.capacity} ml"
                                  : "",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: Constant.CONTAINER_SIZE_12,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Text(
                         list.isNotEmpty
                             ? "${list.first.inCirculationCount}"
                             : "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_22,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_18),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
                child: Container(
                  height: Constant.CONTAINER_SIZE_45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                    border: Border.all(
                      color: Colors.white24,
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Strings.SEARCH_BY_USERID,
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(.6),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      suffixIcon: const Icon(
                        Icons.filter_list,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_14),

              Expanded(
                child: ListView.separated(
                  padding:
                  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
                  itemCount: list.length,                  separatorBuilder: (_, __) =>
                      SizedBox(height: Constant.CONTAINER_SIZE_10),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Container(
                      height: Constant.CONTAINER_SIZE_55,
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.05),
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                        border: Border.all(
                          color: Colors.white24,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Expanded(
                            // child: Text(
                            //   item["id"],
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: Constant.CONTAINER_SIZE_15,
                            //   ),
                            // ),
                          // ),
                          // Text(
                          //   item["qty"].toString(),
                          //   style: TextStyle(
                          //     color: Color(0xffF6C343),
                          //     fontSize: Constant.CONTAINER_SIZE_18,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}