import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ContainerScreen(),
    );
  }
}

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  String selectedSort = "";
  List<String> selectedContainers = [];

  final List<Map<String, String>> allContainers = [
    {"name": "Dip Cups", "sku": "ST-DC-50"},
    {"name": "Dip Cups", "sku": "ST-DC-70"},
    {"name": "Dip Cups", "sku": "ST-DC-85"},
    {"name": "Round Bowl", "sku": "ST-RB-450"},
    {"name": "Round Bowl", "sku": "ST-RB-900"},
    {"name": "Rectangular Container", "sku": "ST-RC-600"},
    {"name": "Rectangular Container", "sku": "ST-RC-1000"},
    {"name": "Rectangular Container", "sku": "ST-RC-1200"},
    {"name": "Rectangular Container", "sku": "ST-RC-1800"},
    {"name": "Rectangular Container", "sku": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3928),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3928),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.20),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        title: const Text(
          "Container(s)",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openContainersSheet(context),
                    child: _dropdown("Containers"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openSortSheet(context),
                    child: _dropdown("Sort By"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: const [

                  ContainerItem(
                    date: "20/11/2025",
                    title: "Dip Cups",
                    sku: "ST-DC-50",
                    size: "50ml",
                    qty: 2,
                    daysLeft: "0 Days Left",
                    color: Color(0xFFFF8A9A),
                    image: "assets/images/dip_cup.png",
                  ),
                  ContainerItem(
                    date: "25/11/2025",
                    title: "Rectangular Container",
                    sku: "ST-RC-600",
                    size: "600ml",
                    qty: 4,
                    daysLeft: "1 Days Left",
                    color: Color(0xFFFF8A9A),
                    image: "assets/images/rectangular_container.png",
                  ),
                  ContainerItem(
                    date: "27/11/2025",
                    title: "Round Bowl",
                    sku: "ST-RB-450",
                    size: "450ml",
                    qty: 2,
                    daysLeft: "3 Days Left",
                    color: Color(0xFFFEDB62),
                    image: "assets/images/round_bowls.png",
                  ),
                  ContainerItem(
                    date: "29/11/2025",
                    title: "Dip Cups",
                    sku: "ST-DC-50",
                    size: "50ml",
                    qty: 1,
                    daysLeft: "5 Days Left",
                    color: Color(0xFFFEDB62),
                    image: "assets/images/dip_cup.png",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
        ],
      ),
    );
  }

  void _openSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0E3928),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sort by",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                _sortOption("Borrow date — Newest first", setModalState),
                const SizedBox(height: 15),
                _sortOption("Borrow date — Oldest first", setModalState),

                const SizedBox(height:  30),

                Row(
                  children: [
                    Expanded(
                      child: _clearApplyBtn("Clear", false, () {
                        setState(() => selectedSort = "");
                        Navigator.pop(context);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _clearApplyBtn("Apply", true, () {
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _sortOption(String text, StateSetter setModalState) {
    return GestureDetector(
      onTap: () {
        setModalState(() => selectedSort = text);
        setState(() {});
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.yellow, width: 2),
            ),
            child: selectedSort == text
                ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                    color: Colors.yellow, shape: BoxShape.circle),
              ),
            )
                : null,
          )
        ],
      ),
    );
  }

  Widget _clearApplyBtn(String text, bool filled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFF2C94C) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF2C94C)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: filled ? Colors.black : const Color(0xFFF2C94C),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------
  // CONTAINERS BOTTOM SHEET
  // ------------------------
  void _openContainersSheet(BuildContext context) {
    List<Map<String, String>> filteredList = List.from(allContainers);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: const Color(0xFF0E3928),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          void search(String query) {
            filteredList = allContainers
                .where((item) => item["name"]!
                .toLowerCase()
                .contains(query.toLowerCase()))
                .toList();
            setModalState(() {});
          }

          return Padding(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.88,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(height: 5, width: 45, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),

                  const SizedBox(height: 20),
                  const Text("Containers",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: search,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.white70),
                        border: InputBorder.none,
                        hintText: "Search by container name",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        final id = "${item['name']}|${item['sku']}";
                        final isSelected = selectedContainers.contains(id);

                        return ListTile(
                          title: Text(
                            item["name"]!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            item["sku"]!,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  selectedContainers.remove(id);
                                } else {
                                  selectedContainers.add(id);
                                }
                              });
                              setState(() {});
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.yellow, width: 2),
                                borderRadius: BorderRadius.circular(6),
                                color:
                                isSelected ? Colors.yellow : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: _clearApplyBtn("Clear", false, () {
                            setState(() => selectedContainers.clear());
                            Navigator.pop(context);
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _clearApplyBtn("Apply", true, () {
                            Navigator.pop(context);
                          }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

// ------------------------
// ITEM CARD WIDGET
// ------------------------
class ContainerItem extends StatelessWidget {
  final String date, title, sku, size, daysLeft, image;
  final int qty;
  final Color color;

  const ContainerItem({
    super.key,
    required this.date,
    required this.title,
    required this.sku,
    required this.size,
    required this.qty,
    required this.daysLeft,
    required this.color,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(image),
                  ),
                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600)),
                      Text(sku,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13)),
                      Text(size,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13)),
                    ],
                  ),

                  const Spacer(),

                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            "$qty",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          daysLeft,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const Text(
                "Al-Aman",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Al Marsa Street 57, Dubai Marina, PO Box 32923, Dubai",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}