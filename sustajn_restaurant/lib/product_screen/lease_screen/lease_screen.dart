import 'package:flutter/material.dart';
import '../../borrowed/borrowed_scan_screen.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';
import '../models/lease_model.dart';
import 'detail_dialo.dart';

class LeaseScreen extends StatelessWidget {

   LeaseScreen({
    super.key,
  });

  final List<LeaseItem> leaseItem = [
    LeaseItem(
      customerId: "ABC-1234",
      containerTypes: "Dip Cup | Round Container",
      quantity: 10,
      dateTime: "21/11/2025 | 09:00pm",
    ),
    LeaseItem(
      customerId: "ABC-1234",
      containerTypes: "Dip Cup | Round Container",
      quantity: 10,
      dateTime: "21/11/2025 | 09:00pm",
    ),
    LeaseItem(
      customerId: "ABC-1234",
      containerTypes: "Dip Cup | Round Container",
      quantity: 10,
      dateTime: "21/11/2025 | 09:00pm",
    ),
    LeaseItem(
      customerId: "ABC-1234",
      containerTypes: "Dip Cup | Round Container",
      quantity: 10,
      dateTime: "21/11/2025 | 09:00pm",
    ),
    LeaseItem(
      customerId: "ABC-1234",
      containerTypes: "Dip Cup | Round Container",
      quantity: 10,
      dateTime: "21/11/2025 | 09:00pm",
    ),
  ];
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: CustomTheme.searchField(searchController, "Search by Customer Name"),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal:  Constant.CONTAINER_SIZE_16),
              itemCount: leaseItem.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: Constant.SIZE_08),
              itemBuilder: (context, index) {
                return _leaseCard(
                  context,
                  leaseItem[index],
                  theme,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => QrCodeScanner()));
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



   Widget _leaseCard(
       BuildContext context, LeaseItem item, ThemeData theme) {
     return InkWell(
       borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
       onTap: () => _openLeaseDialog(context, item),
       child: Container(
         margin: EdgeInsets.only(bottom: Constant.SIZE_08),
         decoration: BoxDecoration(
           color: Constant.grey.withOpacity(0.1),
           borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
           border: Border.all(color: Constant.grey, width: 0.3),
         ),
         child: Padding(
           padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 item.customerId,
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: theme.textTheme.titleMedium?.copyWith(
                   fontSize: Constant.LABEL_TEXT_SIZE_16,
                   fontWeight: FontWeight.w600,
                   color: Colors.white70,
                 ),
               ),
               SizedBox(height: Constant.SIZE_06),
               Row(
                 children: [
                   Expanded(
                     child: Text(
                       item.containerTypes ?? '',
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       style: theme.textTheme.bodySmall?.copyWith(
                         fontSize: Constant.LABEL_TEXT_SIZE_14,
                         color: Colors.white70,
                       ),
                     ),
                   ),
                   SizedBox(width: 8),
                   Text(
                     item.quantity.toString(),
                     style: theme.textTheme.titleMedium?.copyWith(
                       color: Constant.gold,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   SizedBox(width: 6),
                   Icon(
                     Icons.arrow_forward_ios,
                     size: Constant.CONTAINER_SIZE_14,
                     color: Colors.white70,
                   ),
                 ],
               ),
               SizedBox(height: Constant.SIZE_06),
               Text(
                 item.dateTime ?? '',
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: theme.textTheme.bodySmall?.copyWith(
                   fontSize: Constant.LABEL_TEXT_SIZE_14,
                   color: Colors.white70,
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

  void _openLeaseDialog(BuildContext context, LeaseItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LeaseDetailsDialog(customerId: item.customerId, dateTime: item.dateTime,),
    );
  }
}
