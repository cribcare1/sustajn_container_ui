import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/report_screen/report_details_screen.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/reports_model/report_mode;.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/filter_Screen.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int selectedTab = 0;


  final List<Map<String, dynamic>> customerItems = [
    {
      "name": "Golden Spoon",
      "address": "2345678965 ",
      "date": "28/11/2025",
      "status": "New ",
      "statusColor": Colors.black,
    },
    {
      "name": " Al-Aman Restaurant",
      "address": "7663526332 ",
      "date": "28/11/2025",
      "status": "New",
      "statusColor": Colors.black,
    },
    {
      "name": "Royal Biryani House",
      "address": "7663526373",
      "date": "26/11/2025",
      "status": "In progress",
      "statusColor": Colors.orange,
    },
    {
      "name": "The Royal Haveli",
      "address": "2345678934 ",
      "date": "25/11/2025",
      "status": "Resolved",
      "statusColor": Colors.green,
    },
    {
      "name": "Heritage Tandoor",
      "address": "2345678934 ",
      "date": "25/11/2025",
      "status": "Rejected",
      "statusColor": Colors.red,
    },
  ];


  final List<Map<String, dynamic>> restaurantItems = [
    {
      "name": "Al-Aman Restaurant",
      "address": "Al Marsa Street 57, Dubai Marina",
      "date": "22/11/2025",
      "status": "Active",
      "statusColor": Colors.green,
    },
    {
      "name": "Golden Spoon",
      "address": "Sheikh Zayed Road 301, Dubai",
      "date": "20/11/2025",
      "status": "Inactive",
      "statusColor": Colors.red,
    },
    {
      "name": "Royal Biryani House",
      "address": "Bur Dubai, Street 11",
      "date": "19/11/2025",
      "status": "Active",
      "statusColor": Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);

    final items = selectedTab == 0 ? customerItems : restaurantItems;

    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Strings.REPORTS,
        leading: CustomBackButton(),
        action: [
          IconButton(onPressed: (){
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ReusableFilterBottomSheet(
                title: "Filters",
                leftTabTitle: "Month",
                options: [
                  "December–2024",
                  "January–2025",
                  "February–2024",
                  "March–2024",
                  "Apiral–2024",
                  "May–2024",
                  "June–2024",
                  "July–2024",
                  "August–2024",
                  "September–2025",
                  "October–2025",
                  "November–2025",
                ],
                selectedValue: "January–2025",
                onApply: (value) {
                  print("Selected Month = $value");
                },
              ),
            );
          },
              icon: Icon(Icons.filter_list))
        ]
      ).getAppBar(context),
      body: Column(
        children: [
          // _buildSegmentedToggle(themeData!),
          // _buildSearchBar(context, themeData!),
          _buildMonthHeader(context, themeData!),
          Expanded(child: _buildList(context, themeData, items)),
        ],
      ),
    );
  }
  Widget _buildMonthHeader(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      color: Colors.grey.shade200,
      child: Text(
        'December - 2025',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: Constant.LABEL_TEXT_SIZE_16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  Widget _buildList(
      BuildContext context, ThemeData theme, List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildListTile(context, items[index], theme);
      },
    );
  }

  FeedbackStatus _convertStatus(String status) {
    switch (status.toLowerCase()) {
      case Strings.NEW_UNREAD:
        return FeedbackStatus.newUnread;
      case Strings.INPROGRESS_TXT:
        return FeedbackStatus.inProgress;
      case Strings.RESOLVED_TXT:
        return FeedbackStatus.resolved;
      case Strings.REJECT_TXT:
        return FeedbackStatus.rejected;
      default:
        return FeedbackStatus.newUnread;
    }
  }


  Widget _buildListTile(
      BuildContext context, Map<String, dynamic> item, ThemeData theme) {
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailsScreen(
              status: item["status"],
              statusColor: item["statusColor"],
            ),
          ),
        );

      },

      child: Container(
        padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  child: Text(
                    item["name"],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.CONTAINER_SIZE_16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  item["status"],
                  style: TextStyle(
                    fontSize: Constant.CONTAINER_SIZE_13,
                    color: item["statusColor"],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: Constant.SIZE_06),
                Icon(Icons.arrow_forward_ios, size: Constant.LABEL_TEXT_SIZE_14, color: Colors.grey),
              ],
            ),

            SizedBox(height: Constant.SIZE_04),


            Text(
              item["address"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_14,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: Constant.SIZE_04),


            Text(
              item["date"],
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_14,
                color: Colors.grey.shade700,
              ),
            ),

            Divider(color: Colors.grey.shade300, height: Constant.CONTAINER_SIZE_20),
          ],
        ),
      ),
    );
  }
}