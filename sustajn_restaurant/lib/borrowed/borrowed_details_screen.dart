import 'package:flutter/material.dart';

class BorrowedDetailsScreen extends StatelessWidget {
  const BorrowedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    /// Sample container list
    final List<Map<String, dynamic>> containers = [
      {
        "image": "https://cdn-icons-png.flaticon.com/512/2929/2929290.png",
        "title": "Dip Cups",
        "code": "ST-DC-50",
        "size": "50ml",
        "count": 1
      },
      {
        "image": "https://cdn-icons-png.flaticon.com/512/3014/3014095.png",
        "title": "Round Bowl",
        "code": "ST-RB-450",
        "size": "450ml",
        "count": 1
      },
      {
        "image": "https://cdn-icons-png.flaticon.com/512/1046/1046857.png",
        "title": "Rectangular Container",
        "code": "ST-RC-600",
        "size": "900ml",
        "count": 1
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: size.height * 0.06,
              left: 16,
              right: 16,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              color: Color(0xffE6F3EB), // light mint green
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Borrowed  Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),

                SizedBox(height: size.height * 0.03),

                CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/40.jpg",
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Jackson",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                /// Icon + Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 34, color: Colors.green[800]),
                    const SizedBox(width: 6),
                    const Text(
                      "3",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Date & Time
                const Text(
                  "22/11/2025  |  10:00am",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
            child: Row(
              children: const [
                Text(
                  "Containers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: containers.length,
              separatorBuilder: (_, __) => const Divider(thickness: 0.4),
              itemBuilder: (_, index) {
                final item = containers[index];
                return Row(
                  children: [
                    /// Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item["image"],
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Title + Code + Size
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              item["title"],
                              style: const TextStyle(
                                fontSize: 16,overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            item["code"],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            item["size"],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Count Right Side
                    Text(
                      item["count"].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
