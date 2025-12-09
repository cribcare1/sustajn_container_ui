import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/profile_screen.dart';

import '../../borrowed/borrowed_home_screen.dart';
import '../../common_widgets/container_count_details.dart';
import '../../constants/number_constants.dart';
import '../../containers/container_list.dart';
import '../../returned_screen/returned_home_screen.dart';
import '../../utils/theme_utils.dart';


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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final cardHorizontalPadding = width * 0.04;
    final cardSpacing = width * 0.03;
    final cardWidth = (width - (cardHorizontalPadding * 2) - cardSpacing) / 2;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: cardHorizontalPadding,
                vertical: Constant.PADDING_HEIGHT_10),
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
                          Text('Hi,',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: Constant.LABEL_TEXT_SIZE_14)),
                          SizedBox(height: Constant.SIZE_05),
                          Text('Marina Sky Dine',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_20,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: Constant.CONTAINER_SIZE_50,
                      height: Constant.CONTAINER_SIZE_50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child:
                      Icon(Icons.notifications_none, color: theme.primaryColor),
                    )
                  ],
                ),
                SizedBox(height: Constant.SIZE_15),
                Wrap(
                  spacing: cardSpacing,
                  runSpacing: Constant.SIZE_06,
                  children: [
                    _buildDashboardCard(context,
                        width: cardWidth, icon: Icons.rice_bowl_outlined,
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>ContainerListScreen(title: 'Containers',)));
                        },
                        label: 'Containers'),
                    _buildDashboardCard(context,
                        width: cardWidth,
                        icon: Icons.call_made_outlined,
                        onTap: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>BorrowedHomeScreen()));
                        },
                        label: 'Borrowed'),
                    _buildDashboardCard(context,
                        width: cardWidth,
                        icon: Icons.call_received,
                        onTap: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>ReturnedHomeScreen()));
                        },
                        label: 'Returned'),
                    _buildDashboardCard(context,
                        onTap: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>MyProfileScreen()));
                        },
                        width: cardWidth, icon: Icons.person_outline, label: 'Profile'),
                  ],
                ),
                SizedBox(height: Constant.SIZE_18),
                Text('Inventory Status Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: Constant.SIZE_10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildDropdown(
                        context,
                        value: selectedDateRange,
                        items: dateOptions,
                        onChanged: (v) => setState(() => selectedDateRange = v!),
                      ),
                    ),
                    SizedBox(width: Constant.SIZE_10),
                    Expanded(
                      flex: 1,
                      child: _buildDropdown(
                        context,
                        value: selectedContainer,
                        items: containerOptions,
                        onChanged: (v) => setState(() => selectedContainer = v!),
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
        }),
      ),
    );
  }


  Widget _buildDashboardCard(BuildContext context,
      {required double width, required IconData icon, required String label,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final cardHeight = width * 0.55;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: cardHeight,
        padding: EdgeInsets.all(Constant.SIZE_10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF6F6F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_48,
              height: Constant.CONTAINER_SIZE_48,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child:
              Icon(icon, color: Colors.white, size: Constant.CONTAINER_SIZE_22),
            ),
            const Spacer(),
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context,
      {required String value,
        required List<String> items,
        required ValueChanged<String?> onChanged}) {
    final theme = Theme.of(context);
    return Container(
      height: Constant.TEXT_FIELD_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          icon:
          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          items: items
              .map((e) => DropdownMenuItem(
              value: e, child: Text(e, style: theme.textTheme.bodyMedium)))
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
        _legendItem('Total Container', Colors.green.shade700, theme),
        SizedBox(width: Constant.SIZE_10),
        _legendItem('Barrowed', Colors.black87, theme),
        SizedBox(width: Constant.SIZE_10),
        _legendItem('Returned', Colors.blue.shade400, theme),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: Constant.SIZE_06),
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildChartRings(BuildContext context, double screenWidth, ThemeData theme) {
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
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(double ringThickness, ThemeData theme) {
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
        color: theme.primaryColor,
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
        color: Colors.black87,
        radius: ringThickness,
        showTitle: false,
        titleStyle: const TextStyle(fontSize: 12),
      ),
    ];
  }
}