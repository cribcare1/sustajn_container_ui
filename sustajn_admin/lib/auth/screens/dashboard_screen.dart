import 'package:container_tracking/constants/imports.util.dart';

import '../../utils/theme_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      body: Container(
        decoration: _bgGradient(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Constant.SIZE_08),
                  child: _header(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: Constant.CONTAINER_SIZE_10),
                        _gridMenu(),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                        _containerStats(),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        _todayStats(),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        _revenueStats(),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        _timePeriod(),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        _leased(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Image.asset(
          'assets/logo/sustajn_app_logo.png',
          width: Constant.CONTAINER_SIZE_45,
          height: Constant.CONTAINER_SIZE_50,
        ),
        Spacer(),
        _circleIcon(Icons.settings),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        _circleIcon(Icons.notifications_none),
      ],
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.3),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _gridMenu() {
    final items = [
      {"title": "Products", "image": "assets/images/round_bowl.png"},
      {"title": "Partners", "image": "assets/images/business.png"},
      {"title": "Users", "image": "assets/images/people.png"},
      {"title": "Order Requests", "icon": Icons.file_copy_outlined},
      {"title": "Transactions", "image": "assets/images/exchange.png"},
      {"title": "Damaged", "image": "assets/images/bowl.png"},
    ];

    return GridView.builder(
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
        final themeData = CustomTheme.getTheme(true);
        return _card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: Constant.CONTAINER_SIZE_24,
                backgroundColor: themeData!.secondaryHeaderColor,
                child: Padding(
                  padding: EdgeInsets.all(Constant.SIZE_06),
                  child: item["image"] != null
                      ? Image.asset(
                          item["image"] as String,
                          color: Colors.black,
                        )
                      : Icon(item["icon"] as IconData, color: Colors.black),
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
    );
  }

  Widget _containerStats() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Containers in Circulation"),
          SizedBox(height: Constant.SIZE_06),
          _value(dashboardData["containers"]),
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Row(
            children: [
              _statusBox("Active", dashboardData["active"], Colors.green),
              SizedBox(width: Constant.CONTAINER_SIZE_10),
              _statusBox("Overdue", dashboardData["overdue"], Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_10,
        ),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Constant.SIZE_06),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: Constant.CONTAINER_SIZE_16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todayStats() {
    return Row(
      children: [
        Expanded(
          child: _infoCard(
            title: "Today's Leased",
            value: "542",
            change: "+12%",
            color: Colors.green,
          ),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: _infoCard(
            title: "Today's Returns",
            value: "498",
            change: "-4%",
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required String change,
    required Color color,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(title),
          SizedBox(height: Constant.SIZE_06),
          _value(value),
          SizedBox(height: Constant.SIZE_04),
          Text(change, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _revenueStats() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: _revenueCard("Extended Due Fee Revenue", "1,245")),
          SizedBox(width: Constant.CONTAINER_SIZE_10),
          Expanded(child: _revenueCard("Sold Revenue", "9,282")),
        ],
      ),
    );
  }

  Widget _revenueCard(String title, String value) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          Spacer(),

          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Row(
            children: [
              Image.asset(
                'assets/images/diarhm.png',
                height: Constant.CONTAINER_SIZE_18,
              ),
              SizedBox(width: Constant.SIZE_02),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Constant.CONTAINER_SIZE_18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timePeriod() {
    return Row(
      children: [
        Expanded(child: _timeCard("Average Return Time", "3.2 Days")),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(child: _timeCard("Active Users", "742 Active Today")),
      ],
    );
  }

  Widget _timeCard(String title, String value) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(title),
          SizedBox(height: Constant.SIZE_06),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leased() {
    return Row(
      children: [
        Expanded(
          child: _leasedCard(
            title: "Most Leased",
            icon: "assets/images/trend.png",
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

  BoxDecoration _bgGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF0F3D2E), Color(0xFF0A2F24)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Text _title(String text) => Text(
    text,
    maxLines: 2,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  );

  Text _value(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.white,
      fontSize: Constant.CONTAINER_SIZE_22,
      fontWeight: FontWeight.bold,
    ),
  );

  TextStyle _smallText(Color color, {bool bold = false}) => TextStyle(
    color: color,
    fontSize: Constant.CONTAINER_SIZE_12,
    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
  );
}
