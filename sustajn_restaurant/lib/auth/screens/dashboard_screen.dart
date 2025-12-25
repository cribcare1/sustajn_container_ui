import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/profile_screen.dart';
import 'package:sustajn_restaurant/order_screen/order_screen/order_screen.dart';

import '../../borrowed/borrowed_home_screen.dart';
import '../../constants/number_constants.dart';
import '../../containers/container_list.dart';
import '../../models/login_model.dart';
import '../../order_screen/order_home_screen.dart';
import '../../product_screen/product_home_screen.dart';
import '../../returned_screen/returned_home_screen.dart';
import '../../utils/utility.dart';
import 'map_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  final double borrowed = 300;
  final double returnedCount = 100;
  final double available = 800;
  final double total = 1000;

  String selectedDateRange = 'Today';
  String selectedContainer = 'Container';

  List<String> dateOptions = ['Today', 'This Week', 'This Month'];
  List<String> containerOptions = ['Container', 'Box', 'Pallet'];


  String userName = "";
  Data? loginResponse;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final cardHorizontalPadding = width * 0.04;
    final cardSpacing = width * 0.03;
    final cardWidth = (width - (cardHorizontalPadding * 2) - cardSpacing) / 2;
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: cardHorizontalPadding,
                vertical: Constant.PADDING_HEIGHT_10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi,',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_14,
                                color: Colors.white
                              ),
                            ),
                            SizedBox(height: Constant.SIZE_05),
                            Text(
                              loginResponse?.fullName?.isNotEmpty == true
                                  ? loginResponse!.fullName!
                                  : "User",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: Constant.CONTAINER_SIZE_50,
                        height: Constant.CONTAINER_SIZE_50,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Constant.grey,
                            width: 0.3
                          ),

                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_15),
                  Wrap(
                    spacing: cardSpacing,
                    runSpacing: Constant.SIZE_06,
                    children: [
                      _buildDashboardCard(
                        context,
                        width: cardWidth,
                        icon: Icons.rice_bowl_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductsScreen(),
                            ),
                          );
                        },
                        label: 'Products',
                      ),
                      _buildDashboardCard(
                        context,
                        width: cardWidth,
                        icon: Icons.call_made_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderHomeScreen(),
                            ),
                          );
                        },
                        label: 'Orders',
                      ),
                      _buildDashboardCard(
                        context,
                        width: cardWidth,
                        icon: Icons.search,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                        },
                        label: 'Search',
                      ),
                      _buildDashboardCard(
                        context,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(),
                            ),
                          );
                        },
                        width: cardWidth,
                        icon: Icons.person_outline,
                        label: 'Profile',
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_18),
                  Text(
                    'Inventory Status Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildDropdown(
                          context,
                          value: selectedDateRange,
                          items: dateOptions,
                          onChanged: (v) =>
                              setState(() => selectedDateRange = v!),
                        ),
                      ),
                      SizedBox(width: Constant.SIZE_10),
                      Expanded(
                        flex: 1,
                        child: _buildDropdown(
                          context,
                          value: selectedContainer,
                          items: containerOptions,
                          onChanged: (v) =>
                              setState(() => selectedContainer = v!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_15),
                  _buildLegendRow(context),
                  SizedBox(height: Constant.SIZE_15),
                  _buildChartRings(context, width, theme),
                  SizedBox(height: Constant.CONTAINER_SIZE_30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required double width,
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final cardHeight = width * 0.55;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: cardHeight,
        padding: EdgeInsets.all(Constant.SIZE_10),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Constant.grey,
            width: 0.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Center(
                child: Container(
                  width: Constant.CONTAINER_SIZE_48,
                  height: Constant.CONTAINER_SIZE_48,
                  decoration: BoxDecoration(
                    color: Constant.gold,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: theme.scaffoldBackgroundColor,
                    size: Constant.CONTAINER_SIZE_22,
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 1,
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDropdown(
    BuildContext context, {
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: Constant.TEXT_FIELD_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constant.grey,
          width: 0.3
        )
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          selectedItemBuilder: (BuildContext context) {
            return items.map((String item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              );
            }).toList();
          },
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black
                  )),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLegendRow(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _legendItem('Total', Colors.greenAccent, theme),
        SizedBox(width: Constant.SIZE_10),
        _legendItem('Lease', Colors.yellowAccent, theme),
        SizedBox(width: Constant.SIZE_10),
        _legendItem('Receive', Colors.lightBlueAccent, theme),
        SizedBox(width: Constant.SIZE_10),
        _legendItem('Available', Colors.amber.shade700, theme),
      ],
    );
  }

  Widget _legendItem(String text, Color color, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: Constant.SIZE_06),
        Text(text, style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white
        )),
      ],
    );
  }

  Widget _buildChartRings(
    BuildContext context,
    double screenWidth,
    ThemeData theme,
  ) {
    double chartSize;
    if (screenWidth < 350) {
      chartSize = screenWidth * 0.65;
    } else if (screenWidth < 400) {
      chartSize = screenWidth * 0.6;
    } else if (screenWidth < 500) {
      chartSize = screenWidth * 0.55;
    } else if (screenWidth < 600) {
      chartSize = screenWidth * 0.5;
    } else {
      chartSize = screenWidth * 0.4;
    }

    chartSize = chartSize.clamp(200.0, 350.0);

    final holeRadius = chartSize * 0.3;
    final ringThickness = chartSize * 0.2;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: 16,
      ),
      child: Column(
        children: [
          SizedBox(
            width: chartSize,
            height: chartSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: holeRadius,
                    startDegreeOffset: -90,
                    sections: _buildChartSections(ringThickness, theme),
                    pieTouchData: PieTouchData(enabled: false),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'November-2025',
              style: TextStyle(
                fontSize: screenWidth < 350 ? 11 : 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(
    double ringThickness,
    ThemeData theme,
  ) {
    return [
      PieChartSectionData(
        value: returnedCount,
        color: const Color(0xFF4AA6FF),
        radius: ringThickness,
        showTitle: false,
        titleStyle: const TextStyle(fontSize: 12),
      ),

      PieChartSectionData(
        value: borrowed,
        color: Colors.lightGreenAccent,
        radius: ringThickness,
        showTitle: false,
        titleStyle: const TextStyle(fontSize: 12),
      ),

      PieChartSectionData(
        value: available,
        color: const Color(0xFFD0A52C),
        radius: ringThickness,
        showTitle: false,
        titleStyle: const TextStyle(fontSize: 12),
      ),
      PieChartSectionData(
        value: total,
        color: Colors.yellowAccent,
        radius: ringThickness,
        showTitle: false,
        titleStyle: const TextStyle(fontSize: 12),
      ),
    ];
  }
}
