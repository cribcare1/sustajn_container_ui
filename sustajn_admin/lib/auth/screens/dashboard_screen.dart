
import 'package:container_tracking/auth/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../common_widgets/filter_screen_2.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../container_list/total_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool isCustomerSelected = false;
  int topTabIndex = 0;
  String filterValue = 'All containers';
  final List<List<int>> weeklyData = [
    [3876, 1200, 200],
    [2500, 800, 150],
    [3200, 1000, 120],
    [2800, 700, 60],
    [3000, 900, 70],
    [2600, 1100, 30],
    [3900, 1300, 100],
  ];
  final List<String> weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final horizontalPad = width * 0.05;
    final cardRadius = 14.0;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: Constant.SIZE_10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(theme),
                SizedBox(height: Constant.SIZE_15),
                _buildEarningsCard(theme, cardRadius),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
                _buildSegmented(theme),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
                _buildStatsSection(theme),
                SizedBox(height: Constant.CONTAINER_SIZE_12),

                if (!isCustomerSelected) _restaurantLowerSection(theme, cardRadius) else _customerLowerSection(theme, cardRadius),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeaderRow(ThemeData theme) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=> MyProfileScreen()));
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person_2_outlined, color: theme.primaryColor,),
          ),
        ),
        SizedBox(width: Constant.SIZE_07,),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hi,', style: theme.textTheme.titleMedium?.copyWith(fontSize: Constant.LABEL_TEXT_SIZE_16)),
          SizedBox(height: 2),
          Text('Lucky', style: theme.textTheme.titleLarge?.copyWith(fontSize: Constant.LABEL_TEXT_SIZE_22)),
        ]),
        Spacer(),
        _iconCircle(theme, Icons.notifications_none),
        SizedBox(width: Constant.SIZE_08),
        _iconCircle(theme, Icons.menu),
      ],
    );
  }

  Widget _iconCircle(ThemeData theme, IconData icon) {
    return Container(
      height: Constant.CONTAINER_SIZE_45,
      width: Constant.CONTAINER_SIZE_45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Icon(icon, color: theme.primaryColor, size: Constant.CONTAINER_SIZE_20),
    );
  }


  Widget _buildEarningsCard(ThemeData theme, double radius) {
    final cardH = MediaQuery.of(context).size.width * 0.22;
    return Container(
      height: cardH,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.85)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
      ),
      padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_20, vertical: Constant.CONTAINER_SIZE_12),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(Strings.TOTAL_EARNINGS, style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
              SizedBox(height: Constant.SIZE_08),
              Text('₹ 4,000', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
            ]),
          ),
          Container(
            height: Constant.CONTAINER_SIZE_45,
            width: Constant.CONTAINER_SIZE_45,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: Constant.CONTAINER_SIZE_18),
          ),
        ],
      ),
    );
  }


  Widget _buildSegmented(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(child: _segButton(theme,Strings.RESTURANT, false)),
          Expanded(child: _segButton(theme, Strings.CUSTOMER, true)),
        ],
      ),
    );
  }

  Widget _segButton(ThemeData theme, String title, bool forCustomer) {
    final selected = (isCustomerSelected == forCustomer);
    return GestureDetector(
      onTap: () => setState(() => isCustomerSelected = forCustomer),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: selected ? theme.secondaryHeaderColor : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        alignment: Alignment.center,
        child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: selected ? theme.primaryColor : Colors.black87, fontWeight: FontWeight.w600)),
      ),
    );
  }


  Widget _buildStatsSection(ThemeData theme) {
    if (!isCustomerSelected) {
      return Column(children: [
        Row(children: [
          _statCard(Strings.TOTAL_REGISTERED_CUST, '534', theme, showArrow: true),
          SizedBox(width: Constant.SIZE_10),
          _statCard(Strings.TOTAL_ACTIVE_RESTURANTS, '456', theme),
        ]),
        SizedBox(height: Constant.SIZE_10),
        Row(children: [
          _statCard(Strings.TOTAL_ISSUED_TITLE, '4,343', theme, showArrow: true),
          SizedBox(width: Constant.SIZE_10),
          _statCard(Strings.TOTAL_RETURNED_CONTAINER, '3,344', theme, showArrow: true),
        ]),
      ]);
    } else {
      return Column(children: [
        Row(children: [
          _statCard(Strings.TOTAL_REGISTERED_CUST, '534', theme, showArrow: true),
          SizedBox(width: Constant.SIZE_10),
          _statCard(Strings.TOTAL_ACTIVE_CUSTOMER, '456', theme),
        ]),
        SizedBox(height: Constant.SIZE_10),
        Row(children: [
          _statCard(Strings.TOTAL_BORROWED_CONTAINER, '4,343', theme, showArrow: true),
          SizedBox(width: Constant.SIZE_10),
          _statCard(Strings.TOTAL_RETURNED_CONTAINER, '3,344', theme, showArrow: true),
        ]),
      ]);
    }
  }

  Widget _statCard(
      String title,
      String value,
      ThemeData theme, {
        bool showArrow = false,
      }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                  ),
                ),
                SizedBox(height: Constant.SIZE_08),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (showArrow)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: Constant.CONTAINER_SIZE_30,
                  width: Constant.CONTAINER_SIZE_30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_outward,
                    color: theme.primaryColor,
                    size: Constant.CONTAINER_SIZE_16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _restaurantLowerSection(ThemeData theme, double cardRadius) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _topTabsRow(theme),
      SizedBox(height: Constant.CONTAINER_SIZE_12),
      _filterRow(theme),
      SizedBox(height: Constant.CONTAINER_SIZE_12),
      _chartCard(theme, cardRadius),
      SizedBox(height: Constant.CONTAINER_SIZE_12),
      _metricsRow(theme),
    ]);
  }


  Widget _customerLowerSection(ThemeData theme, double cardRadius) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _topTabsRow(theme),
      SizedBox(height: Constant.SIZE_08),
      _filterRow(theme),
      SizedBox(height: Constant.CONTAINER_SIZE_12),
      _chartCard(theme, cardRadius),
      SizedBox(height: Constant.CONTAINER_SIZE_12),
      _metricsRow(theme),

    ]);
  }

  Widget _topTabsRow(ThemeData theme) {
    return Row(children: [
      _topTabButton(Strings.DAILY, 0, theme),
      SizedBox(width: Constant.CONTAINER_SIZE_12),
      _topTabButton(Strings.MONTHLY, 1, theme),
    ]);
  }

  Widget _topTabButton(String label, int index, ThemeData theme) {
    final selected = topTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => topTabIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Constant.SIZE_10, horizontal: Constant.SIZE_18),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label,
            style: theme.textTheme.titleMedium?.copyWith(
                color: selected ? theme.primaryColor : Colors.black54,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _filterRow(ThemeData theme) {
    return Row(children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Constant.SIZE_10),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(12), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: filterValue,
              items: <String>['All containers', 'Container A', 'Container B'].map((e) =>
                  DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => filterValue = v ?? filterValue),
            ),
          ),
        ),
      ),
    ]);
  }


  Widget _chartCard(ThemeData theme, double radius) {
    return Container(
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(radius), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      child: Column(children: [
        SizedBox(height: 6),
        _chartLegendRow(theme),
        SizedBox(height: 10),
        SizedBox(height: MediaQuery.of(context).size.width * 0.70, child: _barChart(theme)),
      ]),
    );
  }

  Widget _chartLegendRow(ThemeData theme) {
    return Column(children: [
      Row(children: [
        _legendChip(Strings.BORROWED, theme.primaryColor),
        SizedBox(width: Constant.CONTAINER_SIZE_12),
        _legendChip(Strings.RETURNED, Colors.black87),
        SizedBox(width: Constant.CONTAINER_SIZE_12),
        _legendChip(Strings.OVERDUE, Colors.redAccent),
        Spacer(),
      ]),
    ]);
  }

  Widget _legendChip(String label, Color color) {
    return Row(children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(4))),
      SizedBox(width: Constant.SIZE_08),
      Text(label, style: Theme.of(context).textTheme.titleSmall),
    ]);
  }

  Widget _metricsRow(ThemeData theme) {
    return Row(children: [
      _metricCard(Strings.BORROWED, '3,993', theme.primaryColor),
      SizedBox(width: Constant.SIZE_10),
      _metricCard(Strings.RETURNED, '1,087', Colors.green),
      SizedBox(width: Constant.SIZE_10),
      _metricCard(Strings.OVERDUE, '247', Colors.redAccent),
    ]);
  }

  Widget _metricCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Constant.SIZE_10, horizontal: Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: Constant.SIZE_10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: Constant.SIZE_06),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _barChart(ThemeData theme) {
    final maxY = _calcMaxY();
    final groups = <BarChartGroupData>[];

    for (var i = 0; i < weeklyData.length; i++) {
      final borrowed = weeklyData[i][0].toDouble();
      final returned = weeklyData[i][1].toDouble();
      final overdue = weeklyData[i][2].toDouble();

      groups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 2,
          barRods: [
            BarChartRodData(
              toY: borrowed,
              width: 6,
              borderRadius: BorderRadius.circular(6),
              color: theme.primaryColor,
              backDrawRodData: BackgroundBarChartRodData(show: false),
            ),
            BarChartRodData(
              toY: returned,
              width: 6,
              borderRadius: BorderRadius.circular(6),
              color: Colors.black87,
              backDrawRodData: BackgroundBarChartRodData(show: false),
            ),
            BarChartRodData(
              toY: overdue,
              width: 6,
              borderRadius: BorderRadius.circular(6),
              color: Colors.redAccent,
              backDrawRodData: BackgroundBarChartRodData(show: false),
            ),
          ],
        ),
      );
    }

    final monthYearLabel = "December - 2025";

    return BarChart(
      BarChartData(
        maxY: maxY,
        groupsSpace: 18,
        barGroups: groups,
        alignment: BarChartAlignment.spaceBetween,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 5,
              getTitlesWidget: (val, meta) {
                return Text(val.toInt().toString(), style: TextStyle(fontSize: 10));
              },
            ),
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                Strings.CONTAINERS_TITLE,
                // monthYearLabel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            axisNameSize: 20,
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                final label = (idx >= 0 && idx < weekLabels.length) ? weekLabels[idx] : '';
                return Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(label, style: TextStyle(fontSize: 11)),
                );
              },
            ),
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                monthYearLabel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            axisNameSize: 20,
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: true),
      ),
    );
  }


  double _calcMaxY() {
    int maxVal = 0;
    for (var row in weeklyData) {
      for (var v in row) {
        if (v > maxVal) maxVal = v;
      }
    }

    int step = 1000;
    if (maxVal <= 1000) step = 200;
    final capped = ((maxVal + step) / step).ceil() * step;
    return capped.toDouble();
  }
}


