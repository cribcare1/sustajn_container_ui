// import 'package:flutter/material.dart';
//
// class HistoryScreen extends StatefulWidget {
//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }
//
// class _HistoryScreenState extends State<HistoryScreen> {
//   final List<HistoryItem> historyList = [
//     HistoryItem(
//       month: "December-2025",
//       restaurant:"Kimura-ya Authentic Japanese Restaurant",
//       items: "Dip Cup | Round container",
//       dateTime:"01/12/2025 | 10:00am",
//       count: 3,
//     ),
//     HistoryItem(
//       month:"November-2025",
//       restaurant: "Sfumato Gastro Atelier",
//       items: "Round container | Rectangle Container",
//       dateTime: "29/11/2025 | 07:12pm",
//       count: 2,
//     ),
//     HistoryItem(
//       month: "November-2025",
//       restaurant: "Dragonfly Dubai",
//       items: "Dip Cup | Round container | Rectangle Containers",
//       dateTime: "27/11/2025 | 04:11pm",
//       count: 4,
//     ),
//     HistoryItem(
//       month: "November-2025",
//       restaurant: "BASTA! Italian Restaurant",
//       items: "Round container",
//       dateTime: "26/11/2025 | 11:00am",
//       count:1,
//     ),
//     HistoryItem(
//       month: "November-2025",
//       restaurant: "Ancora Mediterranean",
//       items: "Dip Cup | Round Bow | Rectangle",
//       dateTime: "22/11/2025 | 10:00am",
//       count: 3,
//     ),
//     HistoryItem(
//       month:"November-2025",
//       restaurant: "Couqley French Brasserie",
//       items: "Dip Cup | Round Bow | Rectangle",
//       dateTime: "20/11/2025 | 12:20pm",
//       count: 3,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B3A2D),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _appBar(),
//             _tabs(),
//             _searchBar(),
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: historyList.length,
//                 separatorBuilder: (_, __) => const Divider(
//                   color: Colors.white24,
//                   height: 24,
//                 ),
//                 itemBuilder: (context, index) {
//                   final item = historyList[index];
//                   final showMonth = index == 0;
//                   historyList[index - 1].month != item.month;
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (showMonth) _monthHeader(item.month),
//                       _historyTile(item),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _appBar() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//     )
//   }
// }
//
// class HistoryItem {
//   final String month;
//   final String restaurant;
//   final String items;
//   final String dateTime;
//   final int count;
//
//   HistoryItem({
//     required this.month,
//     required this.restaurant,
//     required this.items,
//     required this.dateTime,
//     required this.count,
// });
// }