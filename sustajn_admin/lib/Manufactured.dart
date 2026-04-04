import 'package:flutter/material.dart';

void main() {
  runApp(const MyAp());
}

class MyAp extends StatelessWidget {
  const MyAp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderedScreen(),
    );
  }
}

class OrderedScreen extends StatelessWidget {
  const OrderedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),


              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Ordered",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: const [
                    MonthSection(
                      title: "November–2025",
                      total: "1000",
                      items: [
                        ItemData("25.11.2025", "500"),
                        ItemData("01.11.2025", "500"),
                      ],
                    ),
                    MonthSection(
                      title: "October–2025",
                      total: "500",
                      items: [
                        ItemData("20.10.2025", "500"),
                      ],
                    ),
                    MonthSection(
                      title: "September–2025",
                      total: "500",
                      items: [
                        ItemData("01.09.2025", "500"),
                      ],
                    ),
                    MonthSection(
                      title: "August–2025",
                      total: "1000",
                      items: [
                        ItemData("22.08.2025", "500"),
                        ItemData("10.08.2025", "500"),
                      ],
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


class MonthSection extends StatelessWidget {
  final String title;
  final String total;
  final List<ItemData> items;

  const MonthSection({
    super.key,
    required this.title,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),


            Row(
              children: [
                Image.asset(
                  "assets/bowl1.png",
                  height: 14,
                  width: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  total,
                  style: const TextStyle(
                    color: Color(0xFFD4AE37),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        ...items.map((e) => OrderCard(data: e)).toList(),

        const SizedBox(height: 20),
      ],
    );
  }
}


class ItemData {
  final String date;
  final String amount;

  const ItemData(this.date, this.amount);
}


class OrderCard extends StatelessWidget {
  final ItemData data;

  const OrderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [

          Expanded(
            child: Text(
              data.date,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),





          Text(
            data.amount,
            style: const TextStyle(
              color: Color(0xFFD4AE37),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}