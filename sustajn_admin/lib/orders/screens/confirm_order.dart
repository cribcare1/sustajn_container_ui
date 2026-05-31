import 'package:flutter/material.dart';

import 'order_rejection.dart';


class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: const Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Customer Name
              Center(
                child: const Text(
                  'Mr.John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pickup Address and Time Section
              _buildSection(
                title: 'Pickup Adress and Time',
                content: 'Placeholder',
              ),
              const SizedBox(height: 40),

              // Delivery Address and Time Section
              _buildSection(
                title: 'Delivery Adress and Time',
                content: 'Placeholder',
              ),
              const SizedBox(height: 40),

              // Order Details Section
              _buildSection(
                title: 'Order Details',
                content: 'Placeholder',
              ),
              const SizedBox(height: 120),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      text: 'Confirm Order',
                      backgroundColor: Color(0xff6eac9e),
                      textColor: Colors.white,
                      onTap: (){}
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildButton(
                      text: 'Reject Order',
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ConfirmRejectionScreen() ));
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Large Content Box
        Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required void Function() onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}