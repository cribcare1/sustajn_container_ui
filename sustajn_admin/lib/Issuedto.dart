import 'package:flutter/material.dart';

class PartnerScreen extends StatelessWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3727),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "With Partner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),


              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search by Partner Name",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.white30,
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.tune, color: Colors.white70),
                  ],
                ),
              ),

              const SizedBox(height: 20),


              Expanded(
                child: ListView(
                  children: const [
                    PartnerTile(
                      name: "Kimura-ya Authentic Japanese Rest..",
                      address:
                      "The Oberoi Hotel, Al A'amal Street, Business Bay",
                      count: "200",
                    ),
                    PartnerTile(
                      name: "ROKA Business Bay",
                      address:
                      "The Opus by Omniyat, Level 1, Business Bay",
                      count: "45",
                    ),
                    PartnerTile(
                      name: "Sfumato Gastro Atelier",
                      address:
                      "ME Dubai Hotel, The Opus Tower, 4th Al A'amal",
                      count: "23",
                    ),
                    PartnerTile(
                      name: "Dragonfly Dubai",
                      address:
                      "The Lana Promenade, Dorchester Collection",
                      count: "200",
                    ),
                    PartnerTile(
                      name: "BASTA! Italian Restaurant",
                      address:
                      "St. Regis Downtown Dubai, Marasi Drive",
                      count: "134",
                    ),
                    PartnerTile(
                      name: "Ancora Mediterranean",
                      address:
                      "InterContinental Residences Dubai, Marasi",
                      count: "156",
                    ),
                    PartnerTile(
                      name: "Couqley French Brasserie",
                      address:
                      "Pullman Downtown Dubai, Marasi Drive",
                      count: "198",
                    ),
                    PartnerTile(
                      name: "Indikaya - Shangri-La",
                      address:
                      "Shangri-La Hotel, Level 2, Sheikh Zayed Road",
                      count: "122",
                    ),
                    PartnerTile(
                      name: "Hakoora Dubai",
                      address:
                      "Oberoi Hotel, Al A'amal Street, Business Bay",
                      count: "122",
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


class PartnerTile extends StatelessWidget {
  final String name;
  final String address;
  final String count;

  const PartnerTile({
    super.key,
    required this.name,
    required this.address,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),


          Text(
            count,
            style: const TextStyle(
              color: Color(0xFFFFC107),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}