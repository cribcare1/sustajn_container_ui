import 'package:container_tracking/Screen/Partner/product/product_home_screen.dart';
import 'package:container_tracking/Screen/Partner/view_more_bottomsheet.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'model/get_all_restaurant_data.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import 'order_history/order_history_screen.dart';

class PartnerDetailsScreen extends StatefulWidget {
  final Data? data;
  // final int? restaurantId;
  // final String? name;
  // final String? address;

  const PartnerDetailsScreen({
    super.key,
    required this.data,
    // required this.restaurantId,
    // required this.name,
    // required this.address,
  });

  @override
  State<PartnerDetailsScreen> createState() => _PartnerDetailsScreenState();
}

class _PartnerDetailsScreenState extends State<PartnerDetailsScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Partner Details",
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              _restaurantDetails(widget.data!.name!, widget.data!.address!),
              _viewDetails(),
              SizedBox(height: Constant.SIZE_05),
              _productDetails(),
              SizedBox(height: Constant.CONTAINER_SIZE_10),
              _barChart(),
              SizedBox(height: Constant.CONTAINER_SIZE_10),
              _leased(),
              SizedBox(height: Constant.CONTAINER_SIZE_10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _restaurantDetails(String restaurantName, String address) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurantName,
            style: TextStyle(fontSize: Constant.CONTAINER_SIZE_18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Constant.SIZE_05),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: Constant.CONTAINER_SIZE_18),
              Text(address),
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

  Widget _productDetails() {
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_10,
                    fontWeight: FontWeight.bold,
                  ),
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
      case "Products": NavUtil.navigateToPushScreen(context, ProductsHomeScreen(restaurantId: widget.data!.id!,));
      break;
      case "Order History": NavUtil.navigateToPushScreen(context, OrderHistoryScreen());
      break;

      default:
        break;
    }
  }

  Widget _barChart() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _filterBox("Month")),
              SizedBox(width: Constant.CONTAINER_SIZE_10),
              Expanded(child: _filterBox("Container Type")),
            ],
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_12),

          /// Legend
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
                    style: TextStyle(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_11),
                  ),
                ),
                SizedBox(width: Constant.SIZE_08),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      alignment: BarChartAlignment.spaceBetween,
                      groupsSpace: 14,

                      /// GRID
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white.withOpacity(0.1),
                          strokeWidth: 1,
                        ),
                      ),

                      /// BORDER
                      borderData: FlBorderData(show: false),

                      /// TITLES
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            getTitlesWidget: (value, _) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Constant.CONTAINER_SIZE_11,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              const days = [
                                "Mon",
                                "Tue",
                                "Wed",
                                "Thu",
                                "Fri",
                                "Sat",
                                "Sun",
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Constant.CONTAINER_SIZE_10,
                                      ),
                                    ),
                                    SizedBox(height: Constant.SIZE_02),
                                    Text(
                                      days[value.toInt() % days.length],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Constant.CONTAINER_SIZE_11,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barGroups: _realBarData(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_10),

          Center(
            child: Text(
              "November-2025",
              style: TextStyle(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_11),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _realBarData() {
    final leased = [75, 40, 10, 45, 5, 50, 8, 15, 25, 5, 30];
    final returned = [35, 5, 5, 10, 3, 8, 5, 12, 10, 2, 15];

    return List.generate(leased.length, (i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: leased[i].toDouble(),
            width: Constant.SIZE_05,
            borderRadius: BorderRadius.circular(Constant.SIZE_04),
            color: Color(0xFFFFC107),
          ),

          /// Returned (White)
          BarChartRodData(
            toY: returned[i].toDouble(),
            width: Constant.SIZE_05,
            borderRadius: BorderRadius.circular(Constant.SIZE_04),
            color: Colors.white,
          ),
        ],
      );
    });
  }

  Widget _filterBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_10, vertical: Constant.SIZE_07),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_14)),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.white,
            size: Constant.CONTAINER_SIZE_18,
          ),
        ],
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
        Text(text, style: TextStyle(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_11)),
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
}
