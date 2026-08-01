// import 'package:flutter/material.dart';
//
// import '../../constants/number_constants.dart';
// import '../constants/string_utils.dart';
//
// class LeaseDetailsUI extends StatelessWidget {
//   const LeaseDetailsUI({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Align(
//           alignment: Alignment.topRight,
//           child: InkWell(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               margin: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
//               padding: EdgeInsets.all(Constant.SIZE_08),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.close,
//                 color: Colors.black,
//                 size: Constant.CONTAINER_SIZE_20,
//               ),
//             ),
//           ),
//         ),
//
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: Constant.CONTAINER_SIZE_20,
//               vertical: Constant.CONTAINER_SIZE_16,
//             ),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(Constant.CONTAINER_SIZE_30),
//               ),
//             ),
//
//             child: Column(
//               children: [
//                 _header(theme),
//
//                 SizedBox(height: Constant.CONTAINER_SIZE_24),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           Strings.CONTAINERS_TITLE,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: Constant.LABEL_TEXT_SIZE_18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: Constant.CONTAINER_SIZE_14),
//
//                       Expanded(
//                         child: ListView.separated(
//                           itemCount: 1,
//                           separatorBuilder: (_, __) =>
//                               SizedBox(height: Constant.CONTAINER_SIZE_12),
//                           itemBuilder: (context, index) {
//                             return _containerCard(theme, index);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _header(ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: Container(
//             width: Constant.CONTAINER_SIZE_60,
//             height: Constant.SIZE_05,
//             decoration: BoxDecoration(
//               color: Colors.white30,
//               borderRadius: BorderRadius.circular(Constant.SIZE_05),
//             ),
//           ),
//         ),
//
//         SizedBox(height: Constant.CONTAINER_SIZE_20),
//
//         Text(
//           Strings.LEASE_DETAILS,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: Constant.LABEL_TEXT_SIZE_20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         SizedBox(height: Constant.CONTAINER_SIZE_16),
//
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       Strings.SMALL_BOWL,
//                       height: Constant.CONTAINER_SIZE_18,
//                       width: Constant.CONTAINER_SIZE_18,
//                       color: Colors.white70,
//                     ),
//
//                     SizedBox(width: Constant.SIZE_08),
//
//                     Text(
//                       "Container ID: ST-DC-50",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: Constant.LABEL_TEXT_SIZE_14,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: Constant.CONTAINER_SIZE_10),
//
//                 Row(
//                   children: [
//                     Image.asset(
//                       Strings.ORDER_ID_ICON,
//                       height: Constant.CONTAINER_SIZE_18,
//                       width: Constant.CONTAINER_SIZE_18,
//                       color: Colors.white70,
//                     ),
//
//                     SizedBox(width: Constant.SIZE_08),
//
//                     Text(
//                       "User ID: SIDD-1542",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: Constant.LABEL_TEXT_SIZE_14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//
//         SizedBox(height: Constant.CONTAINER_SIZE_12),
//
//         Center(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     Strings.BOWL_IMGS,
//                     height: Constant.CONTAINER_SIZE_40,
//                     width: Constant.CONTAINER_SIZE_40,
//                   ),
//
//                   SizedBox(width: Constant.SIZE_08),
//
//                   Text(
//                     "1",
//                     style: TextStyle(
//                       color: Constant.baseColor,
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: Constant.SIZE_08),
//
//               Text(
//                 "21.11.2025 | 09:00",
//                 style: TextStyle(
//                   color: Colors.white60,
//                   fontSize: Constant.LABEL_TEXT_SIZE_14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _containerCard(ThemeData theme, int index) {
//     return Container(
//       padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
//
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.05),
//         borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
//         border: Border.all(color: Colors.white24),
//       ),
//
//       child: Row(
//         children: [
//           Container(
//             height: Constant.CONTAINER_SIZE_70,
//             width: Constant.CONTAINER_SIZE_70,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(.15),
//               borderRadius: BorderRadius.circular(Constant.SIZE_08),
//             ),
//
//             child: Image.asset(
//               Strings.NO_IMG,
//               fit: BoxFit.contain,
//             ),
//           ),
//
//           SizedBox(width: Constant.CONTAINER_SIZE_16),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//
//               children: [
//                 Text(
//                   "Dip Cup",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: Constant.LABEL_TEXT_SIZE_16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//
//                 SizedBox(height: Constant.SIZE_04),
//
//                 Text(
//                   "ST-DC-50",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: Constant.LABEL_TEXT_SIZE_14,
//                   ),
//                 ),
//
//                 SizedBox(height: Constant.SIZE_04),
//
//                 Text(
//                   "50ml",
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontSize: Constant.LABEL_TEXT_SIZE_14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
