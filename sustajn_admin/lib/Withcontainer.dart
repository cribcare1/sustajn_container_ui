import 'package:flutter/material.dart';

class DamagedScreen extends StatelessWidget {
  const DamagedScreen({super.key});

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
                  CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Damaged",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 20),


              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [

                    Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/plastic.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dip Cup",
                              style: TextStyle(color: Colors.white)),
                          Text("SDC-50",
                              style: TextStyle(color: Colors.white70)),
                          Text("50 ml",
                              style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ),

                    const Text("10",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const SizedBox(height: 20),


              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: const Text("User",
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: const Text("Partner",
                            style: TextStyle(color: Colors.amber)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),


              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white54),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search by Partner Name",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.tune, color: Colors.white54),
                  ],
                ),
              ),

              const SizedBox(height: 20),


              Expanded(
                child: ListView(
                  children: [
                    sectionTitle("November-2025", "2"),
                    listItem("ROKA Business Bay", "01.11.2025 | 10:12", "2"),

                    sectionTitle("October-2025", "7"),
                    listItem("Sfumato Gastro Atelier",
                        "10.10.2025 | 14:23", "4"),
                    listItem("ROKA Business Bay",
                        "09.10.2025 | 12:23", "3"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70)),
          Row(
            children: [
              Image.asset("assets/bowl.png", height:13.15, width: 13.33),

              const SizedBox(width: 4),
              Text(count,
                  style: const TextStyle(color: Colors.amber)),
            ],
          )
        ],
      ),
    );
  }

  Widget listItem(String name, String date, String qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          Text(qty,
              style: const TextStyle(color: Colors.amber)),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}