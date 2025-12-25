import 'package:flutter/material.dart';

import '../common_widgets/filter_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3B2E),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0E3B2E),
        leading: const BackButton(color: Colors.white),

        title: const Text(
          "History",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),

          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFFFC727),
            indicatorWeight: 3,
            labelColor: const Color(0xFFFFC727),
            unselectedLabelColor: Colors.white,

            tabs: const [
              Tab(text: "Borrowed"),
              Tab(text: "Returned"),
              Tab(text: "Sold"),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 4),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BorrowedTab(),
                ReturnedTab(),
                SoldTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 8),

      decoration: BoxDecoration(
        color: const Color(0xFF124F3B),
        borderRadius: BorderRadius.circular(14),
      ),

      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),

        decoration:  InputDecoration(
          hintText: "Search by Restaurant Name",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          suffixIcon: IconButton(onPressed: (){
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ReusableFilterBottomSheet(
                title: "Filters",
                leftTabTitle: "Month",
                options: [
                  "December–2024",
                  "January–2025",
                  "February–2024",
                  "March–2024",
                  "Apiral–2024",
                  "May–2024",
                  "June–2024",
                  "July–2024",
                  "August–2024",
                  "September–2025",
                  "October–2025",
                  "November–2025",
                ],
                selectedValue: "January–2025",
                onApply: (value) {
                  print("Selected Month = $value");
                },
              ),
            );
          }, icon: Icon(Icons.filter_list, color: Colors.white))
        ),
      ),
    );
  }
}

class BorrowedTab extends StatelessWidget {
  const BorrowedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),

      children: [

        _monthHeader("December–2025", 3),
        _historyCard(
          title: "Kimura-ya Authentic Japanese Restau…",
          subtitle: "Dip Cup | Round container",
          date: "01/12/2025 | 10:00am",
          count: 3,
        ),

        const SizedBox(height: 10),
        _monthHeader("November–2025", 34),

        _historyCard(
          title: "Sfumato Gastro Atelier",
          subtitle: "Round container | Rectangle Containers",
          date: "29/11/2025 | 07:12pm",
          count: 2,
        ),

        _historyCard(
          title: "Dragonfly Dubai",
          subtitle: "Dip Cup | Round container | Rectangle Contai…",
          date: "27/11/2025 | 04:11pm",
          count: 4,
        ),

        _historyCard(
          title: "BASTA! Italian Restaurant",
          subtitle: "Round container",
          date: "26/11/2025 | 11:00am",
          count: 1,
        ),

        _historyCard(
          title: "Ancora Mediterranean",
          subtitle: "Dip Cup | Round Bow | Rectangle",
          date: "22/11/2025 | 10:00am",
          count: 3,
        ),
      ],
    );
  }
}

class ReturnedTab extends StatelessWidget {
  const ReturnedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [

        _monthHeader("November-2025", 34),

        _historyCard(
          title: "ROKA Business Bay",
          subtitle: "Dip Cup | Round Container | Rectangle Contai...",
          date: "27/11/2025 | 09:00am",
          count: 4,
        ),
        _historyCard(
          title: "Cloud(Healthy Wraps)",
          subtitle: "Dip Cup | Round Container",
          date: "26/11/2025 | 10:14am",
          count: 4,
        ),
        _historyCard(
          title: "Alphorn Restaurant",
          subtitle: "Dip Cup | Round Container | Rectangle Contai...",
          date: "26/11/2025 | 09:42am",
          count: 1,
        ),
        _historyCard(
          title: "Brothaus Bakery & Bistro",
          subtitle: "Dip Cup | Round Container",
          date: "18/11/2025 | 11:50am",
          count: 4,
        ),
        _historyCard(
          title: "Bravo Avocado",
          subtitle: "Dip Cup | Round Container | Rectangle Contai...",
          date: "20/11/2025 | 08:00am",
          count: 3,
        ),
        _historyCard(
          title:"Mama Zonia",
          subtitle: "Dip Cup | Round Container | Rectangle",
          date: "12/11/2025",
          count: 4,
        ),
      ],
    );
  }
}

class SoldTab extends StatelessWidget {
  const SoldTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [

        _monthHeader("November-2025",150),

        _soldItemCard(
          date:"20/11/2025 | 10:00pm",
          imagePath:"assets/images/dip_cup.png",
          title:"Dip Cup",
          code:"ST-DC-50",
          qtyText:"50ml",
          qty:2,
          price:"₹100",
        ),

        _soldItemCard(
          date:"20/11/2025 | 10:00pm",
          imagePath:"assets/images/round_container.png",
          title:"Round Container",
          code:"ST-RDC-500",
          qtyText:"50ml",
          qty:2,  
          price:"₹150",
        ),

        const SizedBox(height: 8),

        _monthHeader("October-2025",150),

        _soldItemCard(
          date:"20/11/2025 | 10:00pm",
          imagePath:"assets/images/round_container.png",
          title:"Round Container",
          code:"ST-RDC-500",
          qtyText:"50ml",
          qty:1,
          price:"₹150",
        ),
      ],
    );
  }

  _soldItemCard({required String date, required String imagePath, required String title, required String code, required String qtyText, required int qty, required String price}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFF124F3B),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            date,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      code,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      qtyText,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.rice_bowl,
                          color: Colors.white70, size: 18),
                      const SizedBox(width: 4),

                      Text(
                        "$qty",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFFFC727),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Widget _monthHeader(String title, int count) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.rice_bowl, color: Colors.white70, size: 18),
            const SizedBox(width: 6),
            Text(
              "$count",
              style: const TextStyle(color: Colors.white),
            )
          ],
        )
      ],
    ),
  );
}

Widget _historyCard({
  required String title,
  required String subtitle,
  required String date,
  required int count,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),

    padding: const EdgeInsets.all(14),

    decoration: BoxDecoration(
      color: const Color(0xFF124F3B),
      borderRadius: BorderRadius.circular(18),
    ),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                date,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Text(
          "$count",
          style: const TextStyle(
            color: Color(0xFFFFC727),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

