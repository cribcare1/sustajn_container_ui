import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../common_widgets/filter_screen.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import 'borrowed_details_screen.dart';
import 'models/model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Container tracking',
        theme: CustomTheme.getTheme(true),
        home: const BorrowReturnScreen(),
      ),
    );
  }
}
class BorrowReturnScreen extends StatefulWidget {
  const BorrowReturnScreen({
    super.key});

  @override
  State<BorrowReturnScreen> createState() => _BorrowReturnScreenState();
}

class _BorrowReturnScreenState extends State<BorrowReturnScreen> {
  int selectedTab = 0;


  final List<Map<String, dynamic>> customerItems = [
    {
      "name": "FlavourFusion Bistro",
      "date": "28/11/2025",
      "count": "23",
      "statusColor": Colors.black,
    },
    {
      "name": " Marbel Mist Manor",
      "date": "28/11/2025",
      "count": "3",
      "statusColor": Colors.black,
    },
    {
      "name": "The Crystal Fork",
      "date": "26/11/2025",
      "count": "3",
      "statusColor": Colors.orange,
    },
    {
      "name": "Velvet Vineyar",
      "date": "25/11/2025",
      "count": "54",
      "statusColor": Colors.green,
    },
    {
      "name": "Cookies",
      "date": "25/11/2025",
      "count": "23",
      "statusColor": Colors.red,
    },
    {
      "name": "The Silver Flame",
      "date": "25/11/2025",
      "count": "21",
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
        title: Strings.BORROW_RETURN_TITLE,
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
            _buildTabButton(Strings.BORROWED, 0),
            _buildTabButton(Strings.RETURNED, 1),
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
          color: Color(0xFFd5e9e1),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFfff2cc) : Color(0xFFd5e9e1),
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_40),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: Constant.LABEL_TEXT_SIZE_15,
              fontWeight: FontWeight.w500,
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
          hintText: Strings.SEARCH_RESTURANTS,
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

  Widget _buildListTile(
      BuildContext context, Map<String, dynamic> item, ThemeData theme) {
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowedDetailsScreen(),
          ),
        );
      },

      child: Container(
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
                  item["count"],
                  style: TextStyle(
                    fontSize: Constant.CONTAINER_SIZE_13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: Constant.SIZE_06),
                Icon(Icons.arrow_forward_ios, size: Constant.LABEL_TEXT_SIZE_14, color: Colors.grey),
              ],
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