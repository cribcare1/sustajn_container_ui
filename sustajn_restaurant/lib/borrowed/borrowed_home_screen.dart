import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';

import '../common_widgets/filter_Screen.dart';
import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';
import 'borrowed_details_screen.dart';
import 'borrowed_scan_screen.dart';

class BorrowedHomeScreen extends StatefulWidget {
  const BorrowedHomeScreen({super.key});

  @override
  State<BorrowedHomeScreen> createState() => _BorrowedHomeScreenState();
}

class _BorrowedHomeScreenState extends State<BorrowedHomeScreen> {
  final List<Map<String, dynamic>> borrowedList = [
    {
      "monthYear": "November-2025",
      "data": [
        {"name": "Jackson", "date": "22/11/2025", "count": 3},
        {"name": "Wade Warren", "date": "22/11/2025", "count": 3},
        {"name": "Cameron Williamson", "date": "22/11/2025", "count": 2},
        {"name": "Brooklyn Simmons", "date": "22/11/2025", "count": 3},
        {"name": "Guy Hawkins", "date": "22/11/2025", "count": 5},
        {"name": "Kristin Watson", "date": "21/11/2025", "count": 2},
        {"name": "Arlene McCoy", "date": "21/11/2025", "count": 3},
        {"name": "Kathryn Murphy", "date": "21/11/2025", "count": 3},
      ],
    },
    {
      "monthYear": "December-2025",
      "data": [
        {"name": "Dianne Russell", "date": "20/12/2025", "count": 1},
      ],
    },
  ];

  List<Map<String, String>> filteredItems = [];
  TextEditingController searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.getTheme(true);
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme!.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Borrowed',
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
                icon: Icon(Icons.filter_list,
                color: Colors.white,))
          ],
          leading: CustomBackButton()).getAppBar(context),
      body:

      Padding(
        padding:  EdgeInsets.all(Constant.SIZE_08),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search containers",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: borrowedList.length,
                itemBuilder: (context, index) {
                  final monthBlock = borrowedList[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0xffe8eee7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                monthBlock["monthYear"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.rice_bowl_outlined, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    monthBlock["data"].length.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: monthBlock["data"].length,
                        separatorBuilder: (context, _) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(height: 1, color: Colors.grey.shade700),
                        ),
                        itemBuilder: (context, i) {
                          final item = monthBlock["data"][i];
                          return Flexible(
                            child: ListTile(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => BorrowedDetailsScreen()));
                              },
                              title: Text(
                                item["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                                ),
                              ),
                              subtitle: Text(
                                item["date"],
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item["count"].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_ios, size: 16,
                                  color: Colors.white,),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => QrScannerScreen()));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Constant.gold,
            shape: BoxShape.circle,
          ),
          child:  Icon(Icons.qr_code_scanner, color: theme.scaffoldBackgroundColor, size: 30),
        ),
      ),
    );
  }
}
