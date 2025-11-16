import 'package:container_tracking/auth/screens/orders/return.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              // Time
              const SizedBox(height: 30),

              // Menu Cards
              Expanded(
                child: ListView(
                  children: [
                    MenuCard(
                      title: 'Orders',
                      description: 'Track and manage all your recent and past orders with ease',
                      cardColor: const Color(0xffb3dbff),
                      buttonColor: const Color(0xff6eac9e),
                      hasIcon: false,
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> OrdersScreen()));
                      },
                    ),
                    const SizedBox(height: 16),
                     MenuCard(
                      title: 'Tour',
                      description: 'Explore a quick tour of all features to help you get started',
                      cardColor: Color(0xffe9f2ff),
                      buttonColor: Color(0xff6eac9e),
                      hasIcon: true,
                      onTap: (){},
                    ),
                    const SizedBox(height: 16),
                     MenuCard(
                      title: 'Sustain Product Guide',
                      description: 'Learn about sustainable products',
                      // cardColor: Color(0xFFFFF8E1),
                      cardColor: Color(0xffe9f2ff),
                      buttonColor: Color(0xff6eac9e),
                      hasIcon: true,
                       onTap: (){},
                    ),
                    const SizedBox(height: 16),
                     MenuCard(
                      title: 'FAQ and Instructions',
                      description: 'As you need to know.',
                      cardColor: Color(0xffe9f2ff),
                      buttonColor: Color(0xff6eac9e),
                      hasIcon: false,
                      onTap: (){},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final Color cardColor;
  final Color buttonColor;
  final bool hasIcon;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.cardColor,
    required this.buttonColor,
    required this.hasIcon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          // Description
          Row(
            children: [
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ),
              if (hasIcon)
                const Icon(
                  Icons.image,
                  size: 23,
                  // color: Color(0xffb2d9ff),
                  color: Color(0xFF6B7280),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Select Button
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 80,
              height: 36,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Select',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}