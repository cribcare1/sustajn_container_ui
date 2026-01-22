import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/profile_screen.dart';
import 'package:sustajn_restaurant/notification/notification_screen.dart';
import 'package:sustajn_restaurant/provider/login_provider.dart';
import 'package:sustajn_restaurant/search_screen/serarch_restaurant_screen.dart';
import 'package:sustajn_restaurant/utils/global_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../common_widgets/card_widget.dart';
import '../../common_widgets/circle_card_widget.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../lease_receive/screens/lease_scan_screen.dart';
import '../../lease_receive/screens/receive_product_list_screen.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../order_screen/order_home_screen.dart';
import '../../product_screen/product_home_screen.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utility.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final double borrowed = 300;
  final double returnedCount = 100;
  final double available = 800;
  final double total = 1000;
  final double damage = 2;

  String selectedDateRange = 'Today';
  String selectedContainer = 'Container';

  List<String> dateOptions = ['Today', 'This Week', 'This Month'];
  List<String> containerOptions = ['Container', 'Box', 'Pallet'];

  String userName = "";
  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Utils.getUserId();
    _loadProfile();
    if(loginResponse == null){
      Utils.printLog("No data found for profile api will call");
      _getProfileNetworkCall();
    }
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  _getProfileNetworkCall() async {
    try {

      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final profileState = ref.read(profileProvider);

        if (isNetworkAvailable) {
          profileState.setIsLoading(true);
          final userId = Utils.userId!;
          Utils.printLog("userId::$userId");
          final url = '${NetworkUrls.GET_PROFILE}$userId';
          Utils.printLog("url::$url");
          ref.read(getProfileProvider(url));
        } else {
          profileState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    if(profileState.loginResponse != null) {
      loginResponse = profileState.loginResponse;
    }
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final w = MediaQuery.sizeOf(context).width;
    final cardHorizontalPadding = width * 0.04;
    final cardSpacing = width * 0.04;
    final cardWidth = (width - (cardHorizontalPadding * 2) - cardSpacing) / 2;
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi,',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: Constant.SIZE_05),
                            Text(
                              loginResponse?.fullName ?? "",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Utils.navigateToPushScreen(
                                    context,
                                    SearchRestaurantScreen(),
                                  );
                                },
                                child: CircleCardWidget(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white70,
                                    size: Constant.CONTAINER_SIZE_20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Utils.navigateToPushScreen(
                                    context,
                                    NotificationScreen(),
                                  );
                                },
                                child: CircleCardWidget(
                                  child: Icon(
                                    Icons.notifications_none,
                                    color: Colors.white70,
                                    size: Constant.CONTAINER_SIZE_20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_15),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: cardSpacing,
                          runSpacing: Constant.CONTAINER_SIZE_12,
                          children: [
                            _buildDashboardCard(
                              context,
                              width: cardWidth,
                              icon: Icons.rice_bowl_outlined,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsScreen(),
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
                              icon: Icons.qr_code_scanner_rounded,
                              onTap: () {
                                _showFilterPopup(context);
                              },
                              label: 'Scan',
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
                        SizedBox(height: Constant.SIZE_15),
                        Text(
                          'Container Status',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_10),
                        GlassSummaryCard(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildDropdown(
                                      context,
                                      value: selectedDateRange,
                                      items: dateOptions,
                                      onChanged: (v) => setState(
                                        () => selectedDateRange = v!,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Constant.SIZE_10),
                                  Expanded(
                                    flex: 1,
                                    child: _buildDropdown(
                                      context,
                                      value: selectedContainer,
                                      items: containerOptions,
                                      onChanged: (v) => setState(
                                        () => selectedContainer = v!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Constant.SIZE_15),
                              _buildLegendRow(context),
                              SizedBox(height: Constant.CONTAINER_SIZE_20),
                              _buildChartRings(context, width, theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
      child: SizedBox(
        width: width,
        height: cardHeight,
        child: GlassSummaryCard(
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
    return SizedBox(
      height: Constant.CONTAINER_WIDTH_SIZE,
      child: GlassSummaryCard(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            isDense: true,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
            selectedItemBuilder: (BuildContext context) {
              return items.map((String item) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    style: theme.textTheme.titleSmall?.copyWith(
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
                    child: Text(
                      e,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendRow(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _legendItem('Lease', Color(0xffCD4400), theme),
          SizedBox(width: Constant.SIZE_10),
          _legendItem('Receive',  Color(0xff9C1A00), theme),
          SizedBox(width: Constant.SIZE_10),
          _legendItem('Available', Color(0xffF79F00), theme),
          SizedBox(width: Constant.SIZE_10),
          _legendItem('Damage', Color(0xff7B8D73), theme),
        ],
      ),
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
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  final List<ChartData> chartData = [
    ChartData('Available', 800, Color(0xffF79F00)),
    ChartData('Lease', 300, Color(0xffCD4400)),
    ChartData('Receive', 100, Color(0xff9C1A00)),
    ChartData('Damage', 20, Color(0xff7B8D73)),
  ];

  Widget _buildChartRings(
    BuildContext context,
    double screenWidth,
    ThemeData theme,
  ) {
    double chartSize = screenWidth * 0.65;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: SfCircularChart(
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    format: 'point.x : point.y',
                  ),
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${10000}',
                            style: theme.textTheme.titleMedium!.copyWith(color: Colors.green)
                          ),
                        ],
                      ),
                    ),
                  ],
                  series: <DoughnutSeries<ChartData, String>>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.label,
                      yValueMapper: (ChartData data, _) => data.value,
                      pointColorMapper: (ChartData data, _) => data.color,
                      innerRadius: '55%',
                      radius: '100%',
                      strokeWidth: 4,
                      explodeOffset: '4%',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: false,
                      ),
                    ),
                  ],
                ),
              ),

              _chartLabel(
                left: 10,
                top: 0,
                right: 10,
                title: 'Lease',
                value: '300',
                color: Colors.yellowAccent,
              ),

              _chartLabel(
                right: 0,
                top: 10,
                title: 'Receive',
                value: '100',
                color: const Color(0xFF9CCBFF),
                alignEnd: true,
              ),

              _chartLabel(
                right: 0,
                bottom: 10,
                title: 'Available',
                value: '800',
                color: const Color(0xFFFFD88A),
              ),

              _chartLabel(
                top: -20,
                title: 'Damage',
                value: '20',
                color: Colors.redAccent,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${months[DateTime.now().month - 1]}-${DateTime.now().year}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _chartLabel({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required String title,
    required String value,
    required Color color,
    bool alignEnd = false,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      builder: (_) {
        return const _FilterPopupWidget();
      },
    );
  }
}

class _FilterPopupWidget extends StatefulWidget {
  const _FilterPopupWidget();

  @override
  State<_FilterPopupWidget> createState() => _FilterPopupWidgetState();
}

class _FilterPopupWidgetState extends State<_FilterPopupWidget> {
  String? selectedType;
  String? selectedValue;
  List<String> valueList = ["Customer Return", "Restaurant Damage"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.clear, color: Colors.black, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xff0C794E), Color(0xff0F3727)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Row(
                    children: [
                      Expanded(
                        child: _OptionTile(
                          title: 'Lease',
                          icon: Icons.north_east,
                          isSelected: selectedType == 'LEASE',
                          onTap: () {
                            setState(() {
                              selectedType = 'LEASE';
                            });
                          },
                        ),
                      ),
                       SizedBox(width: Constant.CONTAINER_SIZE_12),
                      Expanded(
                        child: _OptionTile(
                          title: 'Receive',
                          icon: Icons.south_west,
                          isSelected: selectedType == 'RECEIVE',
                          onTap: () {
                            setState(() {
                              selectedType = 'RECEIVE';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedType == null
                          ? null
                          : () {
                                Navigator.pop(context);
                                Utils.navigateToPushScreen(
                                  context,
                                  LeaseScanScreen(
                                    type: selectedType ?? "",
                                    damage: selectedValue,
                                  ),
                                );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == null
                            ? Colors.grey.shade300
                            : Theme.of(context).secondaryHeaderColor,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: selectedType == null
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                      ),
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

class _OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).secondaryHeaderColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color:isSelected?Colors.white: Theme.of(context).secondaryHeaderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.black : Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}
