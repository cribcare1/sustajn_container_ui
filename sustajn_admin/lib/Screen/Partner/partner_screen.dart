import 'package:container_tracking/Screen/Partner/model/get_all_restaurant_data.dart';
import 'package:container_tracking/Screen/Partner/partner_details_screen.dart';
import 'package:container_tracking/Screen/Partner/provider/provider/restaurant_list_provider.dart';
import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_provider/network_provider.dart';
import '../../common_widgets/card_widget.dart';
import '../../common_widgets/custom_search_bar.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class PartnerScreen extends ConsumerStatefulWidget {
  const PartnerScreen({super.key});

  @override
  ConsumerState<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends ConsumerState<PartnerScreen> {
  List<Data> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _getAllRestaurantCall();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    final restaurantState = ref.watch(restaurantProvider);
    final restaurantList = restaurantState.getRestaurantData?.data ?? [];
    Utils.printLog("List length: ${restaurantList.length}");
    if (filteredItems.isEmpty && restaurantList.isNotEmpty) {
      filteredItems = restaurantList;
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: "Partner",
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Column(
        children: [
          CustomSearchBar(
            hintText: "Search by Partner Name",
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  filteredItems = restaurantList;
                } else {
                  filteredItems = restaurantList.where((item) {
                    return item.name!.toLowerCase().contains(
                      value.toLowerCase(),
                    );
                  }).toList();
                }
              });
            },
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_16),
          Expanded(
            child: restaurantState.isLoading
                ? Center(child: CircularProgressIndicator())
                : restaurantState.getRestaurantData == null
                ? Center(
                    child: Text(
                      "Partner List is not available",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Constant.CONTAINER_SIZE_12),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _containerTile(item, themeData!);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _containerTile(Data item, ThemeData themeData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartnerDetailsScreen(data: item),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
        child: GlassSummaryCard(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  child:
                      item.profileImageUrl != null &&
                          item.profileImageUrl!.isNotEmpty
                      ? Image.network(
                          "${NetworkUrls.IMAGE_BASE_URL}${item.profileImageUrl}",
                          width: Constant.CONTAINER_SIZE_40,
                          height: Constant.CONTAINER_SIZE_40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Strings.CUP_IMG,
                              width: Constant.CONTAINER_SIZE_40,
                              height: Constant.CONTAINER_SIZE_40,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          Strings.CUP_IMG,
                          width: Constant.CONTAINER_SIZE_50,
                          height: Constant.CONTAINER_SIZE_50,
                        ),
                ),
              ),
              SizedBox(width: Constant.CONTAINER_SIZE_14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name!,
                      overflow: TextOverflow.ellipsis,
                      style: themeData.textTheme.titleMedium,
                    ),
                    SizedBox(height: Constant.SIZE_04),
                    Text(item.address!, style: themeData.textTheme.titleSmall),
                  ],
                ),
              ),
              SizedBox(width: Constant.SIZE_10),
              Icon(
                Icons.arrow_forward_ios,
                size: Constant.CONTAINER_SIZE_16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAllRestaurantCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(restaurantProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = NetworkUrls.ALL_RESTAURANT_LIST;
          ref.read(getRestaurantListProvider(url));
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
