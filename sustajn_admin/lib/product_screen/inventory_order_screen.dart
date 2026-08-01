// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../common_widgets/custom_app_bar.dart';
// import '../common_widgets/custom_back_button.dart';
// import '../constants/network_urls.dart';
// import '../constants/number_constants.dart';
// import '../constants/string_utils.dart';
// import '../provider/order_provider.dart';
// import '../utils/utility.dart';
// import 'models/inventory_order_data.dart';
//
// class InventoryOrderScreen extends ConsumerStatefulWidget {
//   const InventoryOrderScreen({super.key});
//
//   @override
//   ConsumerState<InventoryOrderScreen> createState() =>
//       _InventoryOrderScreenState();
// }
//
// class _InventoryOrderScreenState extends ConsumerState<InventoryOrderScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _getInventoryOrderNetworkCall();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final orderState = ref.watch(orderProvider);
//     final InventoryOrderData? data = orderState.getInventoryOrderData;
//
//     return Scaffold(
//       backgroundColor: Constant.PrimaryColor,
//       appBar: CustomAppBar(
//         title: Strings.ORDERED,
//         leading: CustomBackButton(
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//       ).getAppBar(context),
//       body: orderState.isLoading
//           ? const Center(
//         child: CircularProgressIndicator(color: Constant.gold),
//       )
//           : orderState.getInventoryOrderData == null
//           ? Center(
//         child: Utils.getErrorText("No Data Found"),
//       )
//           : ListView.builder(
//         padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_12),
//         itemCount: 1,
//         itemBuilder: (context, index) {
//           final data = orderState.getInventoryOrderData!;
//
//           return MonthSection(
//             month: data.monthYear ?? "",
//             total: "${data.monthTotal ?? 0}",
//             dates: (data.dailyOrders ?? [])
//                 .map((e) => [
//               e.date ?? "",
//               "${e.quantity ?? 0}",
//             ])
//                 .toList(),
//           );
//         },
//       ),
//     );
//   }
//   _getInventoryOrderNetworkCall() async {
//     try {
//       await ref.read(networkProvider.notifier).isNetworkAvailable().then((
//           isNetworkAvailable,
//           ) {
//         Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
//         final orderState = ref.read(orderProvider);
//         if (isNetworkAvailable) {
//           orderState.setIsLoading(true);
//           final url = '${NetworkUrls.PRODUCT_INCIRCULATION}';
//           ref.read(getInCirculationProvider(url));
//         } else {
//           orderState.setIsLoading(false);
//           Utils.showToast(Strings.NO_INTERNET_CONNECTION);
//         }
//       });
//     } catch (e) {
//       Utils.printLog('Error in visitor button onPressed: $e');
//     }
//   }
// }
//
// class MonthSection extends StatelessWidget {
//   final String month;
//   final String total;
//   final List<List<String>> dates;
//
//   const MonthSection({
//     super.key,
//     required this.month,
//     required this.total,
//     required this.dates,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Constant.PrimaryColor,
//       margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_10),
//       padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12, vertical: Constant.CONTAINER_SIZE_10),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 month,
//                 style: TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_15),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.rice_bowl,
//                     color: Constant.gold2,
//                     size: Constant.CONTAINER_SIZE_15,
//                   ),
//                   Text(
//                     "1,000",
//                     style: TextStyle(color: Constant.gold2, fontSize: Constant.CONTAINER_SIZE_15),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           SizedBox(height: Constant.CONTAINER_SIZE_12),
//
//           ...dates.map(
//             (e) => Padding(
//               padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_10),
//               child: Container(
//                 height: Constant.CONTAINER_SIZE_45,
//                 padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
//                 decoration: BoxDecoration(
//                   color: Constant.green4,
//                   borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
//                   border: Border.all(color: Colors.white24),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       e[0],
//                       style: TextStyle(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_15),
//                     ),
//
//                     Row(
//                       children: [
//                         // Icon(
//                         //   Icons.currency_rupee,
//                         //   color: Constant.gold2,
//                         //   size: Constant.CONTAINER_SIZE_16,
//                         // ),
//                         Text(
//                           e[1],
//                           style: TextStyle(
//                             color: Constant.gold2,
//                             fontWeight: FontWeight.w600,
//                             fontSize: Constant.CONTAINER_SIZE_16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
