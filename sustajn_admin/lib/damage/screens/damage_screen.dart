import 'package:flutter/material.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import 'damage_partner_screen.dart';
import 'damage_user_screen.dart';

class DamageHomeScreen extends StatefulWidget {
  final int? userId;

  const DamageHomeScreen({super.key, required this.userId});

  @override
  State<DamageHomeScreen> createState() => _DamageHomeScreenState();
}

class _DamageHomeScreenState extends State<DamageHomeScreen>
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
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: CustomBackButton(),
        title: Text(
          Strings.DAMAGE,
          style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Constant.grey.withOpacity(0.3),
          indicatorColor: Colors.amber,
          indicatorWeight: 2,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Padding(
                padding: EdgeInsets.only(right: Constant.CONTAINER_SIZE_55),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Strings.DAMAGE_USER,
                      height: Constant.SIZE_HEIGHT_10,
                      width: Constant.CONTAINER_SIZE_75,
                    ),
                    const SizedBox(width: 1.8),
                    const Text(Strings.USER),
                  ],
                ),
              )
              ),

            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Strings.DAMAGE_PARTNER,
                    height:Constant.SIZE_HEIGHT_10,
                    width: Constant.CONTAINER_SIZE_75,
                  ),
                  const SizedBox(width: 1.8),
                  const Text(Strings.PARTNER),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DamageUserScreen(userId: widget.userId!),
                DamagePartnerScreen(userId : widget.userId!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
