import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f4),
      appBar: AppBar(
        backgroundColor: const Color(0xffdfeeea),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          "Borrowed",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)),
        ],
      ),
      body: ListView.builder(
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
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                itemBuilder: (context, i) {
                  final item = monthBlock["data"][i];
                  return Flexible(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BorrowedDetailsScreen()));
                      },
                      title: Text(
                        item["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        item["date"],
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item["count"].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
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
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => QrScannerScreen()));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Color(0xff0E3A2F),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
