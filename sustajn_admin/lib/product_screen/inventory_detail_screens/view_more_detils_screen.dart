import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';

class MoreDetailsBottomSheet extends StatelessWidget {
  const MoreDetailsBottomSheet({
    super.key,
    this.onEdit,
  });

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Constant.backgroundColor;
    const labelColor = Color(0xFF9AADA5);
    const valueColor = Colors.white;
    const dividerColor = Color(0xFF3A5F53);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_10),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(Constant.CONTAINER_SIZE_11, Constant.CONTAINER_SIZE_14, Constant.CONTAINER_SIZE_11, Constant.CONTAINER_SIZE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Strings.VIEW_MORE,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constant.CONTAINER_SIZE_14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: onEdit,
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white70,
                          size: Constant.CONTAINER_SIZE_16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_12),

                  _detailItem(
                    label: 'Container Description',
                    value:
                    'Lorem ipsum dolor sit amet consectetur. Arcu enim '
                        'consectetur porttitor gravida ut a viverra sit mattis. '
                        'Sed consequat quisque in urna ullamcorper.',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Container Material',
                    value: 'Lorem Ipsum',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Container Color',
                    value: 'Silver',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Dimension Length cm',
                    value: '15cm',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Dimension Height cm',
                    value: '7cm',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Weight Grams',
                    value: '100grams',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Food Safe',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Dish wash Safe',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Microwave Safe',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Max Temperature',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Min Temperature',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Lifespan Cycle',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                  ),

                  _detailItem(
                    label: 'Cost Per Unit',
                    value: '-',
                    labelColor: labelColor,
                    valueColor: valueColor,
                    dividerColor: dividerColor,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Close button
        Positioned(
          right: 8,
          top: -35,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: Constant.CONTAINER_SIZE_30,
              width: Constant.CONTAINER_SIZE_30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Color(0xFF555555),
                size: Constant.CONTAINER_SIZE_20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _detailItem({
    required String label,
    required String value,
    required Color labelColor,
    required Color valueColor,
    required Color dividerColor,
    bool showDivider = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: Constant.CONTAINER_SIZE_10,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: Constant.SIZE_02),

        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: Constant.CONTAINER_SIZE_10,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),

        if (showDivider) ...[
          SizedBox(height: Constant.SIZE_08),
          Divider(
            color: dividerColor,
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: Constant.SIZE_08),
        ],
      ],
    );
  }
}