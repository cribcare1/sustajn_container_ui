import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({Key? key}) : super(key: key);


  Widget _statusCircle({
    required BuildContext context,
    required String label,
    required String count,
    required Color circleColor,
    required Color textColor,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_72,
            height: Constant.CONTAINER_SIZE_72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: circleColor.withOpacity(0.18),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count,
                    style: textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontSize: Constant.LABEL_TEXT_SIZE_20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: Constant.subtitleText,
                      fontSize: Constant.LABEL_TEXT_SIZE_14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical: Constant.SIZE_08),
      child: Row(
        children: [
          _statusCircle(
            context: context,
            label: 'Critical',
            count: '2',
            circleColor: Constant.statusCritical,
            textColor: Constant.statusCritical,
          ),
           SizedBox(width: Constant.SIZE_08),
          _statusCircle(
            context: context,
            label: 'Urgent',
            count: '2',
            circleColor: Constant.statusUrgent,
            textColor: Constant.statusUrgent,
          ),
           SizedBox(width: Constant.SIZE_08),
          _statusCircle(
            context: context,
            label: 'Upcoming',
            count: '3',
            circleColor: Constant.statusUpcoming,
            textColor: Constant.statusUpcoming,
          ),
        ],
      ),
    );
  }
}
