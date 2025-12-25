import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';


void showTransactionDetailsBottomSheet(
  BuildContext context, {
  required String status,
  required String requestedDate,
  required String approvedDate,
  required int large,
  required int medium,
  required int small,
  required int count,
}) {
  Color statusColor = status == Strings.APPROVED_STATUS
      ? Colors.blue
      : status == Strings.PENDING_STATUS
      ? Colors.orange
      : Colors.red;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) {
          final theme = Theme.of(context);
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_20,
              vertical: Constant.CONTAINER_SIZE_18,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constant.CONTAINER_SIZE_26),
              ),
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: Constant.CONTAINER_SIZE_45,
                      height: Constant.SIZE_04,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(Constant.SIZE_08),
                      ),
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_18),

                  Stack(
                    children: [
                      Center(
                        child: Text(
                          Strings.TRANSACTION_DETAILS_TITLE,
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,color: Colors.white,
                              size: Constant.CONTAINER_SIZE_20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_16),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  count.toString(),
                                  style: theme.textTheme.titleLarge
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Constant.CONTAINER_SIZE_10,
                                    vertical: Constant.SIZE_04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      Constant.SIZE_06,
                                    ),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: Constant.CONTAINER_SIZE_12,
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_20),

                          _rowTitle(Strings.REQUESTED_CONTAINER_TYPES,context),
                          Text(
                            "${Strings.LARGE} - $large  |  ${Strings.MEDIUM} - $medium  |  ${Strings.SMALL} - $small",
                            style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Divider(color: Colors.grey.shade300),

                          _rowTitle(Strings.REQUESTED_ON,context),
                          Text(
                            requestedDate,
                            style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400)
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Divider(color: Colors.grey.shade300),

                          if (status != Strings.PENDING_STATUS) ...[
                            _rowTitle(Strings.APPROVED_CONTAINER,context),
                            Text(
                              "${Strings.LARGE} - $large  |  ${Strings.MEDIUM} - $medium  |  ${Strings.SMALL} - $small",
                              style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400)
                            ),
                            SizedBox(height: Constant.CONTAINER_SIZE_16),

                            _rowTitle(Strings.APPROVED_ON,context),
                            Text(
                              approvedDate,
                              style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400)
                            ),
                            SizedBox(height: Constant.CONTAINER_SIZE_16),
                          ],

                          SizedBox(height: Constant.SIZE_10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _rowTitle(String title, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: Constant.SIZE_04),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)
    ),
  );
}