import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_provider/network_provider.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../provider/order_provider.dart';
import '../utils/utility.dart';
import 'models/withpartner_detail_data.dart';

class WithPartnerListScreen extends ConsumerStatefulWidget {
  const WithPartnerListScreen({super.key});

  @override
  ConsumerState<WithPartnerListScreen> createState() =>
      _InPartnerListScreenState();
}

class _InPartnerListScreenState extends ConsumerState<WithPartnerListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWithPartnerListNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    final PartnersDataList? partnerData =
        orderState.getWithPartnerDetailsData?.data;
    final List<Partners> partnerList = partnerData?.partners ?? [];

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,

      appBar: CustomAppBar(
        title: Strings.WITH_PARTNER,
        leading: CustomBackButton(onTap: () => Navigator.pop(context)),
      ).getAppBar(context),

      body: Column(
        children: [
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            child: Container(
              height: Constant.CONTAINER_SIZE_80,
              padding: EdgeInsets.symmetric(
                horizontal: Constant.CONTAINER_SIZE_12,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Container(
                    width: Constant.CONTAINER_SIZE_55,
                    height: Constant.CONTAINER_SIZE_55,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(Constant.SIZE_08),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Constant.SIZE_08),
                      child: Image.network(
                        "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${partnerData?.imageUrl ?? ""}",
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/no_image_container.png",
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_12),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (partnerData?.name ?? ""),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constant.CONTAINER_SIZE_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: Constant.SIZE_02),

                        Text(
                          (partnerData?.productId ?? ""),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Constant.CONTAINER_SIZE_13,
                          ),
                        ),

                        SizedBox(height: Constant.SIZE_03),

                        Text(
                          (partnerData?.capacity ?? ""),
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "${partnerData?.totalWithPartner ?? 0}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: Constant.CONTAINER_SIZE_20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_18),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            child: Container(
              height: Constant.CONTAINER_SIZE_50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(color: Colors.white24),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Strings.SEARCH_BY_PARTNER,
                  hintStyle: TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Constant.SIZE_01,
                        height: Constant.CONTAINER_SIZE_24,
                        color: Colors.white24,
                      ),

                      SizedBox(width: Constant.SIZE_10),

                      const Icon(Icons.filter_list, color: Colors.white70),

                      SizedBox(width: Constant.SIZE_10),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_16),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: Constant.CONTAINER_SIZE_12,
              ),
              itemCount: partnerList.length,
              separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_10),
              itemBuilder: (context, index) {
                final Partners item = partnerList[index];
                return Container(
                  height: Constant.CONTAINER_SIZE_70,
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_14,
                    ),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.partnerName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Constant.CONTAINER_SIZE_16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: Constant.SIZE_04),

                            Text(
                              item.address ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.55),
                                fontSize: Constant.CONTAINER_SIZE_14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "${item.count ?? 0}",
                        style: TextStyle(
                          color: Constant.PrimaryAssentColor,
                          fontSize: Constant.CONTAINER_SIZE_18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _getWithPartnerListNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = '${NetworkUrls.WITH_PARTNER_DETAIL}';
          ref.read(getWithPartnerDetailProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
