import 'package:flutter/material.dart';

class InCirculationScreen extends StatelessWidget {
  const InCirculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3727),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [


              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "In Circulation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),


              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white54),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search by User ID",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.tune, color: Colors.white54)
                  ],
                ),
              ),

              const SizedBox(height: 20),


              Expanded(
                child: ListView(
                  children: const [
                    ItemCard("ROBE-2323", 2),
                    ItemCard("BESS-1323", 10),
                    ItemCard("KATH-2312", 1),
                    ItemCard("DEVO-2123", 4),
                    ItemCard("CAME-1232", 2),
                    ItemCard("JACO-3222", 5),
                    ItemCard("ARLE-2123", 9),
                    ItemCard("ALBE-2123", 6),
                    ItemCard("AJAY-ABC", 7),
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


class ItemCard extends StatelessWidget {
  final String title;
  final int count;

  const ItemCard(this.title, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}