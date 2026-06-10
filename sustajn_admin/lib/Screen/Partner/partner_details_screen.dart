import 'package:container_tracking/Screen/Partner/provider/provider/product_provider.dart';
import 'package:container_tracking/Screen/Partner/screens/damaged_Screen.dart';
import 'package:container_tracking/Screen/Partner/screens/product_home_screen.dart';
import 'package:container_tracking/Screen/Partner/screens/returned_screen.dart';
import 'package:container_tracking/Screen/Partner/screens/sold_screen.dart';
import 'package:container_tracking/Screen/Partner/view_more_bottomsheet.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import 'model/get_all_restaurant_data.dart';
import 'model/get_container_data.dart';
import 'model/lease_barrow_data.dart' hide Data;
import 'order_history/order_history_screen.dart';
import 'screens/issued_screen.dart';

class PartnerDetailsScreen extends ConsumerStatefulWidget {
  final Data? data;

  const PartnerDetailsScreen({super.key, required this.data});

  @override
  ConsumerState<PartnerDetailsScreen> createState() => _PartnerDetailsScreenState();
}

class _PartnerDetailsScreenState extends ConsumerState<PartnerDetailsScreen> {

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
        title: "Partner Details",
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                children: [
                  _restaurantDetails(
                    themeData!,
                    widget.data!.name!,
                    widget.data!.address!,
                  ),
                  _viewDetails(),
                  SizedBox(height: Constant.SIZE_05),
                  _productDetails(themeData!),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  _barChart(themeData!),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  _leased(),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                ],
              ),
            ),
          ),

          if (orderState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      )
    );
  }

  Widget _restaurantDetails(ThemeData themeData, String restaurantName, String address) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurantName,
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
              Expanded(child: Text(address, style: themeData.textTheme.titleSmall,)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewDetails() {
    final themeData = CustomTheme.getTheme(true);
    return Center(
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => PartnerDetailsSheet(restaurantId: widget.data!.id!),
          );
        },
        child: Text(
          'View More Details',
          style: TextStyle(
            color: themeData!.secondaryHeaderColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _productDetails(ThemeData themeData) {
    final items = [
      {"title": "Issued", "image": "assets/images/Issued.png"},
      {"title": "Products", "image": "assets/images/products.png"},
      {"title": "Returned", "image": "assets/images/Return.png"},
      {"title": "Sold", "image": "assets/images/sold_container.png"},
      {"title": "Damaged", "image": "assets/images/Damaged.png"},
      {"title": "Order History", "image": "assets/images/history.png"},
    ];

    return _card(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: Constant.SIZE_08,
          crossAxisSpacing: Constant.SIZE_08,
          childAspectRatio: 1,
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

  void _handleNavigation(String title) {
    switch (title) {
      case "Issued":
        NavUtil.navigateToPushScreen(
          context,
          IssuedScreen(restaurantId: widget.data!.id!),
        );
        break;
      case "Products":
        NavUtil.navigateToPushScreen(
          context,
          ProductsHomeScreen(restaurantId: widget.data!.id!),
        );
        break;
      case "Returned":
        NavUtil.navigateToPushScreen(
          context,
          ReturnedScreen(restaurantId: widget.data!.id!),
        );
        break;
      case "Sold":
        NavUtil.navigateToPushScreen(
          context,
          SoldScreen(restaurantId: widget.data!.id!),
        );
        break;
      case "Damaged":
        NavUtil.navigateToPushScreen(
          context,
          DamagedScreen(restaurantId: widget.data!.id!),
        );
        break;
      case "Order History":
        NavUtil.navigateToPushScreen(
          context,
          OrderHistoryScreen(restaurantId: widget.data!.id!),
        );
        break;
      default:
        break;
    }
  }

  Widget _barChart(ThemeData themeData) {
    final orderState = ref.watch(productProvider);
    final leaseBorrowData = orderState.leaseBorrowData;
    final dailyStats = orderState.dailyStats;
    double maxY = (dailyStats ?? [])
        .expand((e) => [(e.leased ?? 0), (e.returned ?? 0)])
        .fold(0, (prev, element) => element > prev ? element : prev)
        .toDouble();


    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _filterBox(
                themeData,
                "Month",
                selectedMonth,
                monthList,
                    (val) {
                  setState(() {
                    selectedMonth = val;
                  });
                },
              ),),
              SizedBox(width: Constant.CONTAINER_SIZE_10),
              Expanded(
                child: _filterContainerBox(
                  themeData,
                  "Container Type",
                  selectedType,
                  containerTypeList,
                      (val) {
                    setState(() {
                      selectedType = val;
                      _getLeaseBorrowDataNetworkCall();
                    });
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_12),

          Row(
            children: [
              _legendDot(Color(0xFFFFC107), "Leased"),
              SizedBox(width: Constant.CONTAINER_SIZE_12),
              _legendDot(Colors.white, "Returned"),
            ],
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_16),

          SizedBox(
            height: Constant.CONTAINER_SIZE_200,
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    "Customer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.CONTAINER_SIZE_11,
                    ),
                  ),
                ),
                SizedBox(width: Constant.SIZE_08),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: (dailyStats?.length ?? 0) * 25,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.start,
                            groupsSpace: 10,
                            maxY: maxY + 10,

                            titlesData: FlTitlesData(

                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false), // 👈 hides 0,1,2...
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50, // 👈 important fix
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    final stats = dailyStats ?? [];

                                    if (index >= stats.length) return const SizedBox();

                                    final item = stats[index];

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${item.day ?? ""}",
                                          style: const TextStyle(fontSize: 9),
                                        ),
                                        Text(
                                          item.dayName ?? "",
                                          style: const TextStyle(fontSize: 9),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),

                            barGroups: _realBarData(dailyStats ?? []),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_10),

          Center(
            child: Text(
              leaseBorrowData?.leaseBarrowData?.monthYear ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: Constant.CONTAINER_SIZE_11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _realBarData(List<DailyStats> stats) {
    return List.generate(stats.length, (i) {
      final item = stats[i];

      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: (item.leased ?? 0).toDouble(),
            width: Constant.SIZE_05,
            borderRadius: BorderRadius.circular(Constant.SIZE_04),
            color: Color(0xFFFFC107),
          ),
          BarChartRodData(
            toY: (item.returned ?? 0).toDouble(),
            width: Constant.SIZE_05,
            borderRadius: BorderRadius.circular(Constant.SIZE_04),
            color: Colors.white,
          ),
        ],
      );
    });
  }

  Widget _filterBox(
      ThemeData themeData,
      String hint,
      String? value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Container(
      height: Constant.CONTAINER_SIZE_40,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_10,
        vertical: Constant.SIZE_05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
        border: Border.all(color: CustomTheme.badgeTextColor()!),
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          height: Constant.CONTAINER_SIZE_35,
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              hint,
              maxLines: 1,
              style: themeData.textTheme.titleSmall,
            ),
            isExpanded: true, // 👈 VERY IMPORTANT (fixes overflow)
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: CustomTheme.badgeTextColor()!,
              size: Constant.CONTAINER_SIZE_18,
            ),
            style: themeData.textTheme.titleSmall,
            dropdownColor: Color(0xFF0F3727), // optional (match your theme)
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, maxLines: 1, style: themeData.textTheme.titleSmall,),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _filterContainerBox(
      ThemeData themeData,
      String hint,
      ContainersDetails? value,
      List<ContainersDetails> items,
      Function(ContainersDetails?) onChanged,
      ) {
    return Container(
      height: Constant.CONTAINER_SIZE_40,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
        border: Border.all(color: CustomTheme.badgeTextColor()!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ContainersDetails>(
          value: value,
          hint: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeData.textTheme.titleSmall,
          ),
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: CustomTheme.badgeTextColor()!,
            size: Constant.CONTAINER_SIZE_18,
          ),
          style: themeData.textTheme.titleSmall,
          dropdownColor: const Color(0xFF0F3727),
          items: items.map((item) {
            return DropdownMenuItem<ContainersDetails>(
              value: item,
              child: Text(
                item.containerUniqueId ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: Constant.SIZE_06,
          height: Constant.SIZE_06,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: Constant.SIZE_06),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: Constant.CONTAINER_SIZE_11,
          ),
        ),
      ],
    );
  }

  Widget _leased() {
    return Row(
      children: [
        Expanded(
          child: _leasedCard(
            title: "Most Leased",
            icon: "assets/images/streamline_flex.png",
            data: dashboardData["mostLeased"],
          ),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: _leasedCard(
            title: "Less Leased",
            icon: "assets/images/down-arrow.png",
            data: dashboardData["lessLeased"],
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
    final themeData = CustomTheme.getTheme(true);

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    icon,
                    height: Constant.CONTAINER_SIZE_18,
                    color: themeData!.secondaryHeaderColor,
                  ),
                  SizedBox(width: Constant.SIZE_04),
                  Text(
                    title,
                    style: _smallText(themeData.secondaryHeaderColor),
                  ),
                ],
              ),
              Text(
                data["percent"],
                style: _smallText(themeData.secondaryHeaderColor, bold: true),
              ),
            ],
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_10),

          Image.asset(data["image"], height: Constant.CONTAINER_SIZE_45),
          SizedBox(height: Constant.SIZE_08),

          Text(
            data["name"],
           maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center, //
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            data["code"],
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_10,
            ),
          ),
          Text(
            data["capacity"],
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
      width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
      decoration: _cardDecoration(),
      child: child,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
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
          final url = '${NetworkUrls.GET_CONTAINER_BY_ID}${widget.data!.id}';
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
          final url = '${NetworkUrls.LEASE_BORROW_CONTAINER}${widget.data!.id}/daily-graph?monthName=$month&year=$year&productId=$productId';
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
