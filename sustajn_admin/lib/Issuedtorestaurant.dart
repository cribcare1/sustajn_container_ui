import 'package:flutter/material.dart';

class IssuedDetailsScreen extends StatelessWidget {
  const IssuedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F3727),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const Text(
                        "Issued Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),


                      Row(
                        children: [
                          Image.asset(
                            "assets/Vector.png",
                            width: 20,
                            height: 11,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Container ID ST-DC-50",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/bowl.png", height: 28),
                          const SizedBox(width: 10),
                          const Text(
                            "350",
                            style: TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),


                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Kimura-ya Authentic Japanese Restaurant",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 14, color: Colors.white70),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "The Oberoi Hotel, Al A'amal Street, Business Bay, Dubai",
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),


                      Row(
                        children: [
                          Image.asset("assets/Group.png", height: 16),
                          const SizedBox(width: 8),
                          const Text(
                            "Ordered on: 24.11.2025",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),


                      Row(
                        children: [
                          Image.asset("assets/Group.png", height: 16),
                          const SizedBox(width: 8),
                          const Text(
                            "Delivered on: 25.11.2025",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3727),
                      shape: BoxShape.circle,

                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}