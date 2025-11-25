import 'package:flutter/material.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

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
      ? Colors.green
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
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_20,
              vertical: Constant.CONTAINER_SIZE_18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
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
                          style: TextStyle(
                            fontSize: Constant.CONTAINER_SIZE_18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: Constant.CONTAINER_SIZE_22,
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
                                Icon(
                                  Icons.dinner_dining,
                                  size: Constant.CONTAINER_SIZE_36,
                                  color: Colors.green,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                                Text(
                                  count.toString(),
                                  style: TextStyle(
                                    fontSize: Constant.CONTAINER_SIZE_26,
                                    fontWeight: FontWeight.bold,
                                  ),
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

                          _rowTitle(Strings.REQUESTED_CONTAINER_TYPES),
                          Text(
                            "${Strings.LARGE} - $large  |  ${Strings.MEDIUM} - $medium  |  ${Strings.SMALL} - $small",
                            style: TextStyle(
                              fontSize: Constant.CONTAINER_SIZE_14,
                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Divider(color: Colors.grey.shade300),

                          _rowTitle(Strings.REQUESTED_ON),
                          Text(
                            requestedDate,
                            style: TextStyle(
                              fontSize: Constant.CONTAINER_SIZE_14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Divider(color: Colors.grey.shade300),

                          if (status != Strings.PENDING_STATUS) ...[
                            _rowTitle(Strings.APPROVED_CONTAINER),
                            Text(
                              "${Strings.LARGE} - $large  |  ${Strings.MEDIUM} - $medium  |  ${Strings.SMALL} - $small",
                              style: TextStyle(
                                fontSize: Constant.CONTAINER_SIZE_14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: Constant.CONTAINER_SIZE_16),

                            _rowTitle(Strings.APPROVED_ON),
                            Text(
                              approvedDate,
                              style: TextStyle(
                                fontSize: Constant.CONTAINER_SIZE_14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: Constant.CONTAINER_SIZE_16),
                            Divider(color: Colors.grey.shade300),
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

Widget _rowTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: Constant.SIZE_04),
    child: Text(
      title,
      style: TextStyle(
        fontSize: Constant.CONTAINER_SIZE_14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );
}
