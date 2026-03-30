import 'package:flutter/material.dart';

class ContainerDetailsScreen extends StatelessWidget {
  const ContainerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D2E),
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const Text(
                    "Containers Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),


                  CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF167A4A), Color(0xFF0E5A3A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFBFAE3C), width: 1),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/plastic.png",
                    width:190,
                    height: 90,

                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Dip Cup",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "ST-DC-50",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "50ml",
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "View more Details",
                    style: TextStyle(
                      color: Color(0xFFD4AE37),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: const [
                    StatCard(title: "Ordered", value: "3,000"),
                    StatCard(title: "Issued to Partner", value: "2,200"),
                    StatCard(title: "In Circulation", value: "400"),
                    StatCard(title: "With Partner", value: "1,500"),
                    StatCard(title: "Sold", value: "90"),
                    StatCard(title: "Damaged", value: "10"),
                    StatCard(title: "In-Stock", value: "1,100"),
                    StatCard(title: "Returned", value: "100"),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}


class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4D3A), Color(0xFF143F32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Container(
                height: 22,
                width: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4AE37),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.north_east,
                  size: 14,
                  color: Colors.black,
                ),
              )
            ],
          ),

          const Spacer(),


          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}