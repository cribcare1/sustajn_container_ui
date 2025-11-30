import 'package:container_tracking/constants/string_utils.dart';
import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../models/transaction_record.dart';


class TransactionItemCard extends StatelessWidget {
  final TransactionRecord data;

  const TransactionItemCard({super.key, required this.data});

  Color _statusColor(BuildContext context) {
    if (data.status == Strings.APPROVED_STATUS) {
      return Color(0xFF75c487);
    } else if (data.status == Strings.REJECTED_STATUS) {
      return Color(0xFFe26571);
    } else {
      return Color(0xFFfadb7f);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constant.CONTAINER_SIZE_10,
        horizontal: Constant.CONTAINER_SIZE_15,
      ),
      decoration: BoxDecoration(
        // todo this may needed
        // gradient: LinearGradient(
        //   colors: [
        //     Colors.white,
        //     Colors.green.withOpacity(0.05),
        //   ],
        // ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.status} on",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  "${data.date.day}/${data.date.month}/${data.date.year}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Constant.SIZE_04),
              Text(
                data.status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _statusColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Icon(
          //   Icons.arrow_forward_ios_rounded,
          //   size: Constant.CONTAINER_SIZE_16,
          // )
        ],
      ),
    );
  }
}
