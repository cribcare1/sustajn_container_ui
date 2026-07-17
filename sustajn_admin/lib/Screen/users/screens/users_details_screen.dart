import 'package:container_tracking/Screen/Partner/provider/provider/product_provider.dart';
import 'package:container_tracking/Screen/users/screens/user__products_screen.dart';
import 'package:container_tracking/Screen/users/screens/user_damaged_screen.dart';
import 'package:container_tracking/Screen/users/screens/user_details_bottomsheet.dart';
import 'package:container_tracking/Screen/users/screens/user_extendedfee_screen.dart';
import 'package:container_tracking/Screen/users/screens/user_sold_screens.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/nav_utils.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import '../../Partner/model/get_container_data.dart';
import '../model/users_data.dart';


class UsersDetailsScreen extends ConsumerStatefulWidget {
  final CustomersData? customersData;

  const UsersDetailsScreen({super.key, required this.customersData});

  @override
  ConsumerState<UsersDetailsScreen> createState() => _PartnerDetailsScreenState();
}

class _PartnerDetailsScreenState extends ConsumerState<UsersDetailsScreen> {

  ContainersDetails? selectedType;
  static final monthList=Utils.getLast12Months();
  List<ContainersDetails> containerTypeList =[];
  String? selectedMonth = monthList.last;
  Map<String, dynamic> dashboardData = {
    "containers": "1286",
    "active": "1120",
    "overdue": "166",
    "todayLeased": "542",
    "todayReturns": "498",
    "mostLeased": {
      "percent": "68%",
      "name": "Round Container",
      "code": "ST-RDC-500",
      "capacity": "500ml",
      "image": "assets/images/round_container.png",
    },
    "lessLeased": {
      "percent": "5%",
      "name": "Rectangular Containers",
      "code": "ST-RC-1200",
      "capacity": "1200ml",
      "image": "assets/images/rectangular_container.png",
    },
    "mostReturn": {
      "percent": "89%",
      "name": "Round Container",
      "code": "ST-RDC-500",
      "capacity": "500ml",
      "image": "assets/images/white_container.png",
    },
    "lessReturn": {
      "percent": "2%",
      "name": "Rectangular Containers",
      "code": "ST-RC-1200",
      "capacity": "1200ml",
      "image": "assets/images/rectangular_container.png",
    },
  };

  @override
  void initState() {
    _getInventoryNetworkCall();
    _getLeaseBorrowDataNetworkCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(false);
    final orderState = ref.watch(productProvider);
    containerTypeList = orderState.filterInventory;
    return Scaffold(
      appBar: CustomAppBar(
        title: "User Details",
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                children: [
                  _usersDetails(
                    themeData!,
                    widget.customersData
                  ),
                  _viewDetails(),
                  SizedBox(height: Constant.SIZE_05),
                  _productDetails(themeData!),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  _activeOverdueCard(),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  _leased(),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  _returned(),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                ],
              ),
            ),
          ),

          if (orderState.isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      )
    );
  }

  Widget _usersDetails(ThemeData themeData, CustomersData? customersData) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customersData?.fullName! ?? "",
            style: themeData.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Constant.SIZE_05),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: CustomTheme.badgeTextColor(),
                size: Constant.CONTAINER_SIZE_18,
              ),
              SizedBox(width: Constant.SIZE_05),
              Expanded(child: Text(customersData?.addresses![0].fullAddress?? "", style: themeData.textTheme.titleSmall,)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewDetails() {
    final themeData = CustomTheme.getTheme(false);
    return Center(
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => UsersDetailsSheet(restaurantId: widget.customersData!.id!),
          );
        },
        child: Text(
          'View More Details',
          style: TextStyle(
            color: Color(0XFFD4AE37),
            decoration: TextDecoration.underline,
            decorationColor: Color(0XFFD4AE37)
          ),
        ),
      ),
    );
  }

  Widget _productDetails(ThemeData themeData) {
    final items = [

      {"title": "Products", "image": "assets/images/products.png"},
      {"title": "Sold", "image": "assets/images/sold_container.png"},
      {"title": "Damaged", "image": "assets/images/Damaged.png"},
      {"title": "Extended Fee", "image": "assets/images/bowl_img.png"},
    ];

    return _card(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: Constant.SIZE_06,
          crossAxisSpacing: Constant.SIZE_06,
          childAspectRatio: 1,
          mainAxisExtent: 95,
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return InkWell(
            onTap: () {
              final title = item["title"]?.toString() ?? "";
              _handleNavigation(title);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: Constant.CONTAINER_SIZE_24,
                    backgroundColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(Constant.SIZE_06),
                      child: Image.asset(
                        item["image"] as String,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  item["title"] as String,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.titleSmall!.copyWith(fontSize: Constant.CONTAINER_SIZE_10,)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _activeOverdueCard() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Constant.CONTAINER_SIZE_14,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(
                Constant.CONTAINER_SIZE_10,
              ),
              border: Border.all(
                color: const Color(0xFF4CAF50),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Active",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  "7",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: Constant.CONTAINER_SIZE_10),

        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Constant.CONTAINER_SIZE_14,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(
                Constant.CONTAINER_SIZE_10,
              ),
              border: Border.all(
                color: const Color(0xFFE53935),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Overdue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  "4",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleNavigation(String title) {
    switch (title) {
      case "Products":
        NavUtil.navigateToPushScreen(
          context,
          UserProductsHomeScreen(userId: widget.customersData!.id!),
        );
        break;
      case "Sold":
        NavUtil.navigateToPushScreen(
          context,
          UserSoldScreen(userId: widget.customersData!.id!),
        );
        break;
      case "Damaged":
        NavUtil.navigateToPushScreen(
          context,
          UserDamagedScreen(userId: widget.customersData!.id!),
        );
        break;
      case "Extended Fee":
        NavUtil.navigateToPushScreen(
          context,
          UserExtendedFeeScreen(userId: widget.customersData!.id!),
        );
        break;
      default:
        break;
    }
  }


  Widget _leased() {
    return Row(
      children: [
        Expanded(
          child: _leasedCard(
            title: "Most borrowed",
            icon: "assets/images/streamline_flex.png",
            data: dashboardData["mostLeased"],
          ),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: _leasedCard(
            title: "Less Borrowed",
            icon: "assets/images/down-arrow.png",
            data: dashboardData["lessLeased"],
          ),
        ),
      ],
    );
  }

  Widget _returned() {
    return Row(
      children: [
        Expanded(
          child: _leasedCard(
            title: "Most Return",
            icon: "assets/images/streamline_flex.png",
            data: dashboardData["mostReturn"],
          ),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: _leasedCard(
            title: "Less Return",
            icon: "assets/images/down-arrow.png",
            data: dashboardData["lessReturn"],
          ),
        ),
      ],
    );
  }

  Widget _leasedCard({
    required String title,
    required String icon,
    required Map<String, dynamic> data,
  }) {
    final themeData = CustomTheme.getTheme(true)!;

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                height: 16,
                width: 16,
                color: themeData.secondaryHeaderColor,
              ),
              SizedBox(width: Constant.SIZE_04),

              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _smallText(themeData.secondaryHeaderColor),
                ),
              ),

              Text(
                data["percent"]?.toString() ?? "",
                style: _smallText(
                  themeData.secondaryHeaderColor,
                  bold: true,
                ),
              ),
            ],
          ),

          SizedBox(height: Constant.SIZE_08),

          Image.asset(
            data["image"]?.toString() ?? "",
            height: 40,
            fit: BoxFit.contain,
          ),

          SizedBox(height: Constant.SIZE_06),

          Text(
            data["name"]?.toString() ?? "",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_12,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2),

          Text(
            data["code"]?.toString() ?? "",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_10,
            ),
          ),

          Text(
            data["capacity"]?.toString() ?? "",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      //width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
      decoration: _cardDecoration(),
      child: child,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
    );
  }

  TextStyle _smallText(Color color, {bool bold = false}) => TextStyle(
    color: color,
    fontSize: Constant.CONTAINER_SIZE_12,
    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
  );

  _getInventoryNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(productProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = '${NetworkUrls.GET_CONTAINER_BY_ID}${widget.customersData!.id}';
          ref.read(getOrderProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  _getLeaseBorrowDataNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(productProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final parts = selectedMonth!.split(" ");
          var month = Utils.getFullMonth(parts[0]);
          var year = parts[1];
          var productId = selectedType != null ? selectedType!.containerId : 0;
          final url = '${NetworkUrls.LEASE_BORROW_CONTAINER}${widget.customersData!.id}/daily-graph?monthName=$month&year=$year&productId=$productId';
          ref.read(getLeaseBorrowProvider(url));
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
