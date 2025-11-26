import 'package:flutter/material.dart';

import 'confirm_order.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0;

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
              const SizedBox(height: 8),

              // Returns Section
              Center(
                child: const Text(
                  '2 Returns announced',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time and Status Tabs
              _buildTabHeader(),
              const SizedBox(height: 16),

              // Returns List
              Expanded(
                child: ListView(
                  children: [
                    _buildReturnItem('John Doe', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfirmOrderScreen()),
                      );
                    }),
                    const SizedBox(height: 12),
                    _buildReturnItem('John Doe', () {}),
                    const SizedBox(height: 24),

                    // Active Orders
                    const Text(
                      'Active orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderItem('John Docsy'),
                    const SizedBox(height: 24),

                    // Past Orders
                    const Text(
                      'Past orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderItem('John Doem'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabHeader() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Time Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ?  Color(0xff6eac9e) : Color(0xffe9f2ff),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Status Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ?  Color(0xff6eac9e) : Color(0xffe9f2ff),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnItem(String name, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfff7f8fd),
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 90,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xffe9f2ff),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Icon(
                Icons.image,
                color: Color(0xffb3daff),
                size: 30,
              ),
            ),

            // Text Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Pickup Time
                    _buildInfoRow('Pickup Time: xxxx'),
                    const SizedBox(height: 2),

                    // Pickup Distance
                    _buildInfoRow('Pickup Distance: xxxx'),
                    const SizedBox(height: 2),

                    // Order Valid
                    _buildInfoRow('Order valid for xxxx'),
                  ],
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff7f8fd),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 90,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffe9f2ff),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: const Icon(
              Icons.image,
              color: Color(0xffb3daff),
              size: 30,
            ),
          ),

          // Text Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Pickup Time
                  _buildInfoRow('Pickup Time: xxxx'),
                  const SizedBox(height: 2),

                  // Pickup Distance
                  _buildInfoRow('Pickup Distance: xxxx'),
                  const SizedBox(height: 2),

                  // Order Valid
                  _buildInfoRow('Order valid for xxxx'),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}