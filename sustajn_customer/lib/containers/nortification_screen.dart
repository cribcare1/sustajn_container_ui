// import 'dart:ui';
// import 'package:flutter/material.dart';
//TODO this class will be used later
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: NotificationScreen(),
//   ));
// }
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//
//   static const Color bgColor = Color(0xFF0F3727);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// HEADER
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: GlassCircle(
//                       child: const Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 14),
//                   const Text(
//                     "Notifications",
//                     style: TextStyle(
//                       fontFamily: 'DMSans',
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Spacer(),
//                   const Text(
//                     "Mark all as read",
//                     style: TextStyle(
//                       fontFamily: 'DMSans',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFFE1B94B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             /// LIST
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 children: const [
//                   GlassNotificationCard(
//                     iconBg: Color(0xFF1EC36B),
//                     icon: Icons.check,
//                     title: "Order Confirmed",
//                     subtitle:
//                     "Sahara Sizzle\nRound Bowl - 1 | Dip Cups - 1 | Rectangular Contai..",
//                     date: "01/12/2024 | 10:00am",
//                   ),
//                   GlassNotificationCard(
//                     iconBg: Color(0xFFF4C430),
//                     icon: Icons.warning_amber_rounded,
//                     title:
//                     "Your borrowed product is due for return in 1 days.\nPlease return it by 01/12/2025.",
//                     date: "30/11/2025 | 09:00am",
//                   ),
//                   GlassNotificationCard(
//                     iconBg: Color(0xFFE04A4A),
//                     icon: Icons.notifications_active_outlined,
//                     title:
//                     "As the 7-day limit has been crossed, we have initiated the process to charge the replacement fee of [Amount]",
//                     date: "30/11/2025 | 09:00am",
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// 🔮 GLASS CIRCLE (Back Button)
// class GlassCircle extends StatelessWidget {
//   final Widget child;
//
//   const GlassCircle({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(40),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           height: 42,
//           width: 42,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.15),
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.white.withOpacity(0.25),
//             ),
//           ),
//           child: Center(child: child),
//         ),
//       ),
//     );
//   }
// }
//
// /// 🔮 GLASS NOTIFICATION CARD
// class GlassNotificationCard extends StatelessWidget {
//   final Color iconBg;
//   final IconData icon;
//   final String title;
//   final String? subtitle;
//   final String date;
//
//   const GlassNotificationCard({
//     super.key,
//     required this.iconBg,
//     required this.icon,
//     required this.title,
//     this.subtitle,
//     required this.date,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.25),
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// ICON
//                 Container(
//                   height: 44,
//                   width: 44,
//                   decoration: BoxDecoration(
//                     color: iconBg,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, color: Colors.white, size: 22),
//                 ),
//                 const SizedBox(width: 14),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontFamily: 'DMSans',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           height: 1.4,
//                         ),
//                       ),
//                       if (subtitle != null) ...[
//                         const SizedBox(height: 6),
//                         Text(
//                           subtitle!,
//                           style: const TextStyle(
//                             fontFamily: 'DMSans',
//                             fontSize: 13,
//                             color: Colors.white70,
//                             height: 1.4,
//                           ),
//                         ),
//                       ],
//                       const SizedBox(height: 10),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           date,
//                           style: const TextStyle(
//                             fontFamily: 'DMSans',
//                             fontSize: 12,
//                             color: Colors.white54,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }