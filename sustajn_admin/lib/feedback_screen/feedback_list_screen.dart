import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../common_widgets/filter_screen_2.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import 'feedback_details_screen.dart';
import 'model/feedback_details_model.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({
    super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  int selectedTab = 0;


  final List<Map<String, dynamic>> customerItems = [
    {
      "name": "Sultan",
      "address": "2345678965 | Container Damage",
      "date": "28/11/2025",
      "status": "New / Unread",
      "statusColor": Colors.black,
    },
    {
      "name": " Cooper",
      "address": "7663526332 | Container Damage",
      "date": "28/11/2025",
      "status": "New / Unread",
      "statusColor": Colors.black,
    },
    {
      "name": "Harsh",
      "address": "7663526373 | Container Damage",
      "date": "26/11/2025",
      "status": "In progress",
      "statusColor": Colors.orange,
    },
    {
      "name": "Lili",
      "address": "2345678934 | Container Damage",
      "date": "25/11/2025",
      "status": "Resolved",
      "statusColor": Colors.green,
    },
    {
      "name": "Cookies",
      "address": "2345678934 | Container Damage",
      "date": "25/11/2025",
      "status": "Rejected",
      "statusColor": Colors.red,
    },
    {
      "name": "Rohit",
      "address": "7663526373 | Container Damage",
      "date": "25/11/2025",
      "status": "Resolved",
      "statusColor": Colors.green,
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
        title: Strings.FEEDBACK_TITLE,
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: Column(
        children: [
          _buildSegmentedToggle(themeData!),
          _buildSearchBar(context, themeData),
          _buildMonthHeader(context, themeData),
          Expanded(child: _buildList(context, themeData, items)),
        ],
      ),
    );
  }


  Widget _buildSegmentedToggle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: Constant.CONTAINER_SIZE_42,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_40),
        ),
        child: Row(
          children: [
            _buildTabButton(Strings.CUSTOMER, 0),
            _buildTabButton(Strings.RESTURANT, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_40),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: Constant.LABEL_TEXT_SIZE_15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_CUSTOMERNAME,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
            color: Colors.grey.shade600,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search, color: theme.primaryColor),
          suffixIcon: GestureDetector(
            onTap: (){
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
              child: Icon(Icons.filter_list, color: theme.primaryColor)),
          contentPadding: EdgeInsets.symmetric(
            vertical: Constant.CONTAINER_SIZE_14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
        ),
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
      color: Theme.of(context).secondaryHeaderColor,
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
          final model = FeedbackModel(
            status: _convertStatus(item["status"]),
            name: item["name"],
            reportId: item["address"].split("|").first.trim(),
            dateTime: item["date"],
            subject: item["address"].split("|").last.trim(),
            description: "Sample description here",
            images: [],
            remarks: "No remarks",
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackDetailsScreen(data: model),
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
