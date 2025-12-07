import 'package:container_tracking/auth/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
    final size = MediaQuery.of(context).size;

    final scale = size.width / 375.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * scale,
                  vertical: 12 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme, scale),
                    SizedBox(height: 18 * scale),

                    _buildEarningsCard(theme, scale),
                    SizedBox(height: 18 * scale),

                    _buildSegmentedControl(theme, scale),
                    SizedBox(height: 18 * scale),

                    _buildStatsSection(theme, scale),
                    SizedBox(height: 18 * scale),

                    _lowerSection(theme, scale),
                    SizedBox(height: 18 * scale),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildHeader(ThemeData theme, double scale) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyProfileScreen()));
          },
          child: CircleAvatar(
            radius: 22 * scale,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_2_outlined,
                color: theme.primaryColor, size: 22 * scale),
          ),
        ),
        SizedBox(width: 10 * scale),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi,',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontSize: 16 * scale)),
            SizedBox(height: 2),
            Text('Lucky',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontSize: 22 * scale)),
          ],
        ),

        Spacer(),

        _circleIcon(theme, Icons.notifications_none, scale),
        SizedBox(width: 10 * scale),
        _circleIcon(theme, Icons.menu, scale),
      ],
    );
  }

  Widget _circleIcon(ThemeData theme, IconData icon, double scale) {
    return Container(
      height: 45 * scale,
      width: 45 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Icon(icon, color: theme.primaryColor, size: 20 * scale),
    );
  }


  Widget _buildEarningsCard(ThemeData theme, double scale) {
    return Container(
      height: 100 * scale,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.85)
          ],
        ),
        borderRadius: BorderRadius.circular(14 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)
        ],
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 20 * scale, vertical: 12 * scale),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total Earnings",
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: Colors.white, fontSize: 14 * scale)),
                SizedBox(height: 8 * scale),
                Text("₹ 4,000",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24 * scale,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
          Container(
            height: 45 * scale,
            width: 45 * scale,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10 * scale)),
            child: Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16 * scale),
          )
        ],
      ),
    );
  }


  Widget _buildSegmentedControl(ThemeData theme, double scale) {
    return Container(
      padding: EdgeInsets.all(4 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: _segBtn(theme, "Restaurant", false, scale)),
          Expanded(
              child: _segBtn(theme, "Customer", true, scale)),
        ],
      ),
    );
  }

  Widget _segBtn(
      ThemeData theme, String title, bool isCust, double scale) {
    final selected = (isCustomerSelected == isCust);
    return GestureDetector(
      onTap: () => setState(() => isCustomerSelected = isCust),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12 * scale),
        decoration: BoxDecoration(
          color: selected ? theme.secondaryHeaderColor : Colors.transparent,
          borderRadius: BorderRadius.circular(26 * scale),
        ),
        alignment: Alignment.center,
        child: Text(title,
            style: theme.textTheme.titleMedium?.copyWith(
              color:
              selected ? theme.primaryColor : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15 * scale,
            )),
      ),
    );
  }


  Widget _buildStatsSection(ThemeData theme, double scale) {
    return Column(
      children: [
        Row(
          children: [
            _statCard("Total Registered Customers", "534", theme, scale),
            SizedBox(width: 10 * scale),
            _statCard(
                isCustomerSelected
                    ? "Total Active Customers"
                    : "Total Active Restaurants",
                "456",
                theme,
                scale),
          ],
        ),
        SizedBox(height: 10 * scale),
        Row(
          children: [
            _statCard(
                isCustomerSelected
                    ? "Total Borrowed"
                    : "Total Issued",
                "4,343",
                theme,
                scale),
            SizedBox(width: 10 * scale),
            _statCard("Total Returned", "3,344", theme, scale),
          ],
        )
      ],
    );
  }

  Widget _statCard(
      String title, String value, ThemeData theme, double scale) {

    return Expanded(
      child: Container(
        height: 90 * scale,
        padding: EdgeInsets.all(12 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontSize: 14 * scale),
              ),
            ),
            SizedBox(height: 6 * scale),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _lowerSection(ThemeData theme, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topTabs(theme, scale),
        SizedBox(height: 14 * scale),
        _filter(theme, scale),
        SizedBox(height: 18 * scale),
        _chartCard(theme, scale),
        SizedBox(height: 18 * scale),
        _metrics(theme, scale),
      ],
    );
  }

  Widget _topTabs(ThemeData theme, double scale) {
    return Row(
      children: [
        _topTab(theme, "Daily", 0, scale),
        SizedBox(width: 12 * scale),
        _topTab(theme, "Monthly", 1, scale),
      ],
    );
  }

  Widget _topTab(
      ThemeData theme, String label, int idx, double scale) {
    final selected = topTabIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => topTabIndex = idx),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 10 * scale, horizontal: 18 * scale),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30 * scale),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: selected ? theme.primaryColor : Colors.black54,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 15 * scale,
          ),
        ),
      ),
    );
  }

  Widget _filter(ThemeData theme, double scale) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: filterValue,
          items: [
            'All containers',
            'Container A',
            'Container B'
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => filterValue = v!),
        ),
      ),
    );
  }


  Widget _chartCard(ThemeData theme, double scale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      padding: EdgeInsets.all(12 * scale),
      child: Column(
        children: [
          _chartLegend(theme, scale),
          SizedBox(height: 12 * scale),
          SizedBox(
            height: 250 * scale,
            child: _barChart(theme, scale),
          ),
        ],
      ),
    );
  }

  Widget _chartLegend(ThemeData theme, double scale) {
    return Row(
      children: [
        _legend("Borrowed", theme.primaryColor, scale),
        SizedBox(width: 12 * scale),
        _legend("Returned", Colors.black87, scale),
        SizedBox(width: 12 * scale),
        _legend("Overdue", Colors.redAccent, scale),
      ],
    );
  }

  Widget _legend(String label, Color color, double scale) {
    return Row(
      children: [
        Container(
          width: 12 * scale,
          height: 12 * scale,
          decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        SizedBox(width: 8 * scale),
        Text(label, style: TextStyle(fontSize: 12 * scale)),
      ],
    );
  }

  Widget _barChart(ThemeData theme, double scale) {
    final maxY = _calcMaxY();

    return BarChart(
      BarChartData(
        maxY: maxY,
        groupsSpace: 18 * scale,
        gridData: FlGridData(show: false),
        barGroups: _makeBarGroups(theme, scale),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30 * scale,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(fontSize: 10 * scale),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                return Text(
                  weekLabels[idx],
                  style: TextStyle(fontSize: 10 * scale),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<BarChartGroupData> _makeBarGroups(ThemeData theme, double scale) {
    return List.generate(weeklyData.length, (i) {
      return BarChartGroupData(x: i, barsSpace: 4 * scale, barRods: [
        BarChartRodData(
            toY: weeklyData[i][0].toDouble(),
            width: 6 * scale,
            borderRadius: BorderRadius.circular(6 * scale),
            color: theme.primaryColor),
        BarChartRodData(
            toY: weeklyData[i][1].toDouble(),
            width: 6 * scale,
            borderRadius: BorderRadius.circular(6 * scale),
            color: Colors.black),
        BarChartRodData(
            toY: weeklyData[i][2].toDouble(),
            width: 6 * scale,
            borderRadius: BorderRadius.circular(6 * scale),
            color: Colors.redAccent),
      ]);
    });
  }

  double _calcMaxY() {
    int maxVal = weeklyData.expand((e) => e).reduce((a, b) => a > b ? a : b);
    int step = maxVal <= 1000 ? 200 : 1000;
    return ((maxVal + step) / step).ceil() * step.toDouble();
  }


  Widget _metrics(ThemeData theme, double scale) {
    return Row(
      children: [
        _metric("Borrowed", "3,993", Colors.blue, scale),
        SizedBox(width: 10 * scale),
        _metric("Returned", "1,087", Colors.green, scale),
        SizedBox(width: 10 * scale),
        _metric("Overdue", "247", Colors.redAccent, scale),
      ],
    );
  }

  Widget _metric(
      String label, String value, Color dotColor, double scale) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 10 * scale, horizontal: 12 * scale),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * scale),
            border: Border.all(color: Colors.grey.withOpacity(0.15))),
        child: Row(
          children: [
            Container(
              width: 8 * scale,
              height: 8 * scale,
              decoration:
              BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            SizedBox(width: 10 * scale),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6 * scale),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}