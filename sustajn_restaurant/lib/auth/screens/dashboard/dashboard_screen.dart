import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/profile_screen.dart';
import 'package:sustajn_restaurant/notification/notification_screen.dart';
import 'package:sustajn_restaurant/search_screen/serarch_restaurant_screen.dart';
import 'package:sustajn_restaurant/utils/global_utils.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../common_widgets/card_widget.dart';
import '../../../common_widgets/circle_card_widget.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../models/login_model.dart';
import '../../../network_provider/network_provider.dart';
import '../../../order_screen/order_home_screen.dart';
import '../../../product_screen/product_home_screen.dart';
import '../../../provider/profile_provider.dart';
import '../../../utils/utility.dart';
import 'pi_chart.dart';

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
    _init();
  }

  Future<void> _init() async {
    await _loadProfile();

    if (loginResponse == null) {
      await _getProfileNetworkCall();
    }
  }


  Future<void> _loadProfile() async {

    await Utils.getProfile();

    if (!mounted) return;

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
    if (profileState.loginResponse != null) {
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
                                  NavUtil.navigateToPushScreen(
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
                                  NavUtil.navigateToPushScreen(
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
                              assetPath: 'assets/images/product.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsScreen(),
                                  ),
                                );
                              },
                              label: Strings.PRODUCTS,
                            ),
                            _buildDashboardCard(
                              context,
                              width: cardWidth,
                              assetPath: 'assets/images/orders.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderHomeScreen(),
                                  ),
                                );
                              },
                              label: Strings.ORDERS,
                            ),
                            _buildDashboardCard(
                              context,
                              width: cardWidth,
                              assetPath: 'assets/images/scan.png',
                              onTap: () {
                                _showFilterPopup(context);
                              },
                              label: Strings.SCAN,
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
                              assetPath: 'assets/images/profile.png',
                              label: Strings.PROFILE,
                            ),
                          ],
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_30),
                        Text(
                          Strings.CONTAINER_STATUS,
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
                              SizedBox(height: Constant.CONTAINER_SIZE_35),
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
    required String assetPath,
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
                    child: Padding(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        // color: theme.scaffoldBackgroundColor,
                      // size: Constant.CONTAINER_SIZE_22,
                    ),
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
          _legendItem(Strings.LEASE_UC, Color(0xFFCD4400), theme),
          SizedBox(width: Constant.SIZE_10),
          _legendItem(Strings.RECEIVE_UC, Color(0xFF9C1A00), theme),
          SizedBox(width: Constant.SIZE_10),
          _legendItem(Strings.AVAILABLE, Color(0xFFF79F00), theme),
          SizedBox(width: Constant.SIZE_10),
          _legendItem(Strings.DAMAGE, Color(0xFF7B8D73), theme),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: Constant.CONTAINER_SIZE_10,
          height: Constant.CONTAINER_SIZE_10,
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
    ChartData(Strings.AVAILABLE, 600, const Color(0xFFF79F00)),
    ChartData(Strings.RECEIVE, 280, const Color(0xFFCD4400)),
    ChartData(Strings.LEASE, 100, const Color(0xFF9C1A00)),
    ChartData(Strings.DAMAGE, 10, const Color(0xFF7B8D73)),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfCircularChart(
                      margin: EdgeInsets.zero,
                      series: <DoughnutSeries<ChartData, String>>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.value,
                          pointColorMapper: (d, _) => d.color,
                          radius: '100%',
                          innerRadius: '65%',
                          strokeWidth: 3,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Strings.TOTAL,
                          style: TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_14),
                        ),
                        SizedBox(height: Constant.SIZE_04),
                        Text(
                          Strings.THOUSAND,
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: Constant.CONTAINER_SIZE_24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _chartLabel(
                left: 45,
                top: -20,
                title: Strings.RECEIVE,
                value: '${getChartItem('Lease').value.toInt()}',
                color: getChartItem('Lease').color,
              ),

              _chartLabel(
                left: -30,
                top: 35,
                title: Strings.LEASE,
                value: '${getChartItem('Receive').value.toInt()}',
                color: getChartItem('Receive').color,
                alignEnd: true,
              ),

              _chartLabel(
                right: -15,
                top: 200,
                bottom: 0,
                title: Strings.AVAILABLE,
                value: '${getChartItem('Available').value.toInt()}',
                color: getChartItem('Available').color,
              ),
              _chartLabel(
                top: -30,
                title: Strings.DAMAGE,
                value: '${getChartItem('Damage').value.toInt()}',
                color: getChartItem('Damage').color,
                alignEnd: true,
              ),
            ],
          ),
          SizedBox(height: Constant.SIZE_08),
          Text(
            '${months[DateTime.now().month - 1]}-${DateTime.now().year}',
            style: TextStyle(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_12),
          ),
        ],
      ),
    );
  }

  ChartData getChartItem(String label) {
    return chartData.firstWhere((e) => e.label == label);
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
              fontSize: Constant.CONTAINER_SIZE_12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: Constant.CONTAINER_SIZE_13,
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
        return const FilterPopupWidget();
      },
    );
  }
}



class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}
