import 'package:container_tracking/constants/imports.util.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';

class PartnerDetailsScreen extends StatefulWidget {
  final String? name;
  final String? address;
  const PartnerDetailsScreen({super.key, required this.name, required this.address});

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

              _restaurantDetails(widget.name!, widget.address!),
              _viewDetails(),
              SizedBox(height: 5),
              _productDetails(),
              SizedBox(height: 10),
              _leased(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _restaurantDetails(String restaurantName, String address){
    return _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurantName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                Text(address),
              ],
            )
          ],
        )
    );
  }

  Widget _viewDetails(){
    final themeData = CustomTheme.getTheme(true);
    return Center(
      child: TextButton(onPressed: (){}, child: Text('View More Details', style: TextStyle(color: themeData!.secondaryHeaderColor, decoration: TextDecoration.underline),)),
    );
  }

  Widget _productDetails() {
    final items = [
      {"title": "Issued", "image": "assets/images/round_bowl.png"},
      {"title": "Products", "icon": Icons.dashboard_outlined},
      {"title": "Returned", "image": "assets/images/people.png"},
      {"title": "Sold", "image": "assets/images/sold_container.png"},
      {"title": "Damaged", "image": "assets/images/bowl.png"},
      {"title": "Order History", "icon": Icons.history_outlined},
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
                      child: item["image"] != null
                          ? Image.asset(
                        item["image"] as String,
                        color: Colors.white,
                      )
                          : Icon(
                        item["icon"] as IconData,
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

  void _handleNavigation(String title){
    switch(title){
      // case "Products": NavUtil.navigateToPushScreen(context, ContainersScreen());
      // break;
      // case "Partners": NavUtil.navigateToPushScreen(context, PartnerScreen());
      // break;

      default:
        break;
    }
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
