import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_provider/network_provider.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../provider/order_provider.dart';
import '../utils/no_data_custom_text.dart';
import '../utils/utility.dart';

class InCirculationListScreen extends ConsumerStatefulWidget {
  final int containerTypeId;
  const InCirculationListScreen({super.key, required this.containerTypeId});

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
    _getIncirculationListNetworkCall();
  }

  @override
  Widget build(BuildContext context,) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    final inCirculationData = orderState.getIncirculationDetailsData!.data!;

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
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_12),
              child: Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_16),
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
                        child: inCirculationData != null
                            ? Image.network(
                          "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${inCirculationData.imageUrl}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                "assets/images/no_image_container.png");
                          },
                        )
                            : Image.asset(
                            "assets/images/no_image_container.png"),
                      ),
                    ),
                    SizedBox(width: Constant.CONTAINER_SIZE_12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            inCirculationData != null ? inCirculationData.name ?? "" : "",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: Constant.LABEL_TEXT_SIZE_16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_02),
                          Text(
                            inCirculationData != null ? inCirculationData.productId ?? "" : "",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: Constant.CONTAINER_SIZE_13,
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_04),
                          Text(
                            inCirculationData != null
                                ? "${inCirculationData.capacity} ml"
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
                      inCirculationData != null
                          ? "${inCirculationData.totalInCirculation}"
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
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_12),
              child: Container(
                height: Constant.CONTAINER_SIZE_45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_14),
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
              child: (inCirculationData!=null && inCirculationData.users!.length! >0) ?ListView.separated(
                padding:
                EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
                itemCount: inCirculationData?.users!.length ?? 0, separatorBuilder: (_, __) =>
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                itemBuilder: (context, index) {
                  final item = inCirculationData?.users![index];
                  return Container(
                    height: Constant.CONTAINER_SIZE_55,
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.05),
                      borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_14),
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(item!.userId!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constant.CONTAINER_SIZE_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Spacer(),
                        Text(item.count.toString(),
                          style: TextStyle(
                            color: Constant.gold2,
                            fontSize: Constant.CONTAINER_SIZE_18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ): Center(
                child: NoDataFoundCustomText(
                  text: Strings.NO_USER_FOUND,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getIncirculationListNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = '${NetworkUrls.INCIRCULATION_DETAIL}${widget.containerTypeId}';
          ref.read(getIncirculationListProvider(url));
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