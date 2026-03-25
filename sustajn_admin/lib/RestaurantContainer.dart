import 'package:flutter/material.dart';

class HomeScr extends StatelessWidget {
  const HomeScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) => const DamageDetailsPopup(),
            );
          },
          child: const Text("Open Popup"),
        ),
      ),
    );
  }
}

class DamageDetailsPopup extends StatelessWidget {
  const DamageDetailsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2E24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Damage Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white24,
                child: Icon(Icons.close, size: 16, color: Colors.white),
              )
            ],
          ),

          const SizedBox(height: 16),


          Row(
            children: [
              Image.asset("assets/images/Vector.png",
                  width: 24,
                  height: 24),
              SizedBox(width: 8),
              Text(
                "Container ID: ST-DC-50",
                style: TextStyle(color: Colors.white70),
              )
            ],
          ),

          const SizedBox(height: 8),


          Row(
            children: [
              Image.asset("assets/images/Group (1).png",
                  width: 24,
                  height: 24),
              SizedBox(width: 8),
              Text(
                "User ID: DSD-1542",
                style: TextStyle(color: Colors.white70),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// Center Icon + Date
          Column(
            children: [
              Image.asset("assets/images/Frame 3267.png",
                  width: 59,
                  height: 44),
              SizedBox(height: 6),
              Text(
                "21.11.2025 | 09:00",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// Containers Title
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Containers",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// Card Item
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF114D3C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                /// Image
                Image.asset(
                  "assets/images/plastic.png",
                  width: 40,
                  height: 40,
                ),

                const SizedBox(width: 12),

                /// Text Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Dip Cups",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "ST-DC-50",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      "50ml",
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}