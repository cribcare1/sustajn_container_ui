import 'package:container_tracking/Screen/users/model/users_data.dart';
import 'package:container_tracking/Screen/users/screens/users_details_screen.dart';
import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/card_widget.dart';
import '../../../common_widgets/custom_search_bar.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import '../provider/user_provider.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  List<CustomersData> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _getAllUsersCall();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(false);
    final usersProvider = ref.watch(userProvider);
    final usersList = usersProvider.customerDataList ?? [];
    Utils.printLog("List length: ${usersList.length}");
    if (filteredItems.isEmpty && usersList.isNotEmpty) {
      filteredItems = usersList;
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.USER,
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Column(
        children: [
          CustomSearchBar(
            hintText: Strings.SEARCH_BY_USER_NAME,
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  filteredItems = usersList;
                } else {
                  filteredItems = usersList.where((item) {
                    return item.fullName!.toLowerCase().contains(
                      value.toLowerCase(),
                    );
                  }).toList();
                }
              });
            },
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_16),
          Expanded(
            child: usersProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : usersProvider.getUsersData == null
                ? Center(
                    child: Text(
                      Strings.USER_NOT_AVAILABLE,
                      style: TextStyle(color: Constant.BeigeColor),
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

  Widget _containerTile(CustomersData item, ThemeData themeData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsersDetailsScreen(customersData: item),
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
                  border: Border.all(color: Constant.BeigeColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  child:
                      item.profileImage != null && item.profileImage!.isNotEmpty
                      ? Image.network(
                          "${NetworkUrls.IMAGE_BASE_URL}${item.profileImage}",
                          width: Constant.CONTAINER_SIZE_60,
                          height: Constant.CONTAINER_SIZE_60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Strings.USER_IMG,
                              width: Constant.CONTAINER_SIZE_60,
                              height: Constant.CONTAINER_SIZE_60,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          Strings.USER_IMG,
                          width: Constant.CONTAINER_SIZE_60,
                          height: Constant.CONTAINER_SIZE_60,
                        ),
                ),
              ),
              SizedBox(width: Constant.CONTAINER_SIZE_14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fullName!,
                      overflow: TextOverflow.ellipsis,
                      style: themeData.textTheme.titleMedium,
                    ),
                    SizedBox(height: Constant.SIZE_04),
                    Text(item.mobile!, style: themeData.textTheme.titleSmall),
                  ],
                ),
              ),
              SizedBox(width: Constant.SIZE_10),
              Icon(
                Icons.arrow_forward_ios,
                size: Constant.CONTAINER_SIZE_16,
                color: Constant.BeigeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAllUsersCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(userProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = NetworkUrls.CUSTOMER_LIST;
          ref.read(getUsersDataProvider(url));
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
