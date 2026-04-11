import 'package:flutter/material.dart';

class SoldScreen extends StatelessWidget {
  const SoldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3727),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Sold",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "User",
                          style: TextStyle(
                            color: Color(0xFFFFD54F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Partner",
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white54),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Search by User ID",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    Icon(Icons.tune, color: Colors.white54),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),


            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  SectionHeader("November-2025", "4"),

                  ItemCard("SIDD-1542", "22.11.2025 | 09:00", "1"),
                  ItemCard("KIRA-1542", "22.11.2025 | 09:00", "3"),

                  SizedBox(height: 18),

                  SectionHeader("October-2025", "18"),

                  ItemCard("RAGA-1542", "26.10.2025 | 09:00", "12"),
                  ItemCard("AFRI-1232", "25.10.2025 | 09:00", "3"),
                  ItemCard("SMIT-1232", "25.10.2025 | 09:00", "3"),

                  SizedBox(height: 18),

                  SectionHeader("September-2025", "20"),

                  ItemCard("RAGA-1542", "20.09.2025 | 09:00", "12",
                      showArrow: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SectionHeader extends StatelessWidget {
  final String title;
  final String count;

  const SectionHeader(this.title, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              Row(
                  children: [
                    Image.asset(
                      "assets/bowl.png",
                      height: 14,
                      width: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(count,
                        style: const TextStyle(color: Color(0xFFFFC107))),

                  ]
              ),
            ]
        )
    );
  }
}


class ItemCard extends StatelessWidget {
  final String title;
  final String date;
  final String count;
  final bool showArrow;

  const ItemCard(
      this.title,
      this.date,
      this.count, {
        this.showArrow = false,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.03),
          ],
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              color: Color(0xFFFFC107),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showArrow)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.chevron_right, color: Colors.white54),
            )
        ],
      ),
    );
  }
}