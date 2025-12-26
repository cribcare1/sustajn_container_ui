import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';


class FreemiumCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1B3B2D), // outer dark green
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade700, width: 1),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1B3B2D), // inner same as outer for contrast
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFFFD700), // gold border
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.percent,
                size: Constant.CONTAINER_SIZE_50,
                color: Colors.white,
              ),
              SizedBox(height: Constant.SIZE_10),
              Text(
                'Freemium',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: Constant.LABEL_TEXT_SIZE_20,
                ),
              ),
              SizedBox(height: Constant.SIZE_05),
              Text(
                '₹ 0.00',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.amber,
                  fontSize: Constant.LABEL_TEXT_SIZE_24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Constant.SIZE_10),
              _featureItem('Lorem ipsum dolor sit amet consectetur. Vel ac nunc tempus ornare neque odio massa in quis.'),
              _featureItem('Lorem ipsum dolor sit amet consectetur.'),
              _featureItem('Lorem ipsum dolor sit amet consectetur.'),
              SizedBox(height: Constant.SIZE_10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.amber),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: Text(
                  'Learn More',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.amber),
                ),
              ),
              SizedBox(height: Constant.SIZE_10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Upgrade',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.amber, size: Constant.CONTAINER_SIZE_20),
          SizedBox(width: Constant.SIZE_08),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: Constant.LABEL_TEXT_SIZE_14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
