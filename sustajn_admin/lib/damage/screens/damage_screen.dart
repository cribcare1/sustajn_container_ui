import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'damage_partner_screen.dart';
import 'damage_user_screen.dart';

class DamageHomeScreen extends ConsumerStatefulWidget {
  final int? userId;

  const DamageHomeScreen({super.key, required this.userId});

  @override
  ConsumerState<DamageHomeScreen> createState() => _DamageHomeScreenState();
}

class _DamageHomeScreenState extends ConsumerState<DamageHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor: theme!.primaryColor,
      appBar: CustomAppBar(
        title: Strings.DAMAGE,
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Column(
        children: [
          Material(
            color: theme.primaryColor,
            child: TabBar(
              controller: _tabController,
              dividerColor: Constant.grey.withOpacity(0.3),
              indicatorColor: Constant.PrimaryAssentColor,
              indicatorWeight: 2,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: Constant.PrimaryAssentColor,
              unselectedLabelColor: Constant.white,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Constant.CONTAINER_SIZE_55,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Strings.DAMAGE_USER,
                          height: Constant.SIZE_HEIGHT_10,
                          width: Constant.CONTAINER_SIZE_75,
                        ),
                        const SizedBox(width: 1.8),
                        Text(Strings.USER),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Strings.DAMAGE_PARTNER,
                        height: Constant.SIZE_HEIGHT_10,
                        width: Constant.CONTAINER_SIZE_75,
                      ),
                      const SizedBox(width: 1.8),
                      Text(Strings.PARTNER),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DamageUserScreen(userId: widget.userId!),
                DamagePartnerScreen(userId: widget.userId!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
