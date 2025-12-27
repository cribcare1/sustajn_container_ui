import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sustajn_restaurant/auth/screens/profile_screen.dart';
import 'package:sustajn_restaurant/utils/global_utils.dart';

import '../../common_widgets/card_widget.dart';
import '../../constants/number_constants.dart';
import '../../models/login_model.dart';
import '../../order_screen/order_home_screen.dart';
import '../../product_screen/product_home_screen.dart';
import '../../utils/utility.dart';

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
  LoginData? loginResponse;
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
                      Container(
                        width: Constant.CONTAINER_SIZE_35,
                        height: Constant.CONTAINER_SIZE_35,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Constant.grey, width: 0.3),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white70,
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => SearchRestaurantScreen(),
                                //   ),
                                // );
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
                          'Container Status Overview',
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
    return Container(
      height: Constant.TEXT_FIELD_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Constant.grey, width: 0.3),
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
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
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
                    titleSunbeamLayout: true,
                    sections: _buildChartSections(ringThickness, theme),
                    pieTouchData: PieTouchData(enabled: true),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${months[DateTime.now().month - 1]}-${DateTime.now().year}',
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
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 40,
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
                      const SizedBox(width: 12),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(valueList.length, (index) {
                        final value = valueList[index];
                        return Expanded(flex: 1,
                          child: Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  radioTheme: RadioThemeData(
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                        return Theme.of(context).secondaryHeaderColor;
                                      },
                                    ),
                                  ),
                                ),
                                child: Radio<String>(
                                  value: value,
                                  groupValue: selectedValue,
                                  activeColor: Theme.of(
                                    context,
                                  ).secondaryHeaderColor,
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),

                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedValue = val;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  value,overflow: TextOverflow.ellipsis,maxLines:1,
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        );
                      }),
                    ),

                  SizedBox(height: Constant.CONTAINER_SIZE_12),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: selectedType == null
                          ? null
                          : () {
                              if (selectedValue == null) {
                                Fluttertoast.showToast(msg: "Select Type");
                              } else {
                                Navigator.pop(context, selectedType);
                              }
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
          border: Border.all(color: Theme.of(context).secondaryHeaderColor),
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
