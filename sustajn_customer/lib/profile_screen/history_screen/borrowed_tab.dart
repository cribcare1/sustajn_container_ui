import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import 'details_dialog.dart';
import 'model/detail_model.dart';

class BorrowedTabScreen extends StatelessWidget {
  BorrowedTabScreen({super.key});

  final searchController = TextEditingController();

  final List<BorrowedDetails> containers = [
    BorrowedDetails(
      resturantName: "Sfumato Gastro Atelier",
      containerName: "Dip Cups",
      code: "ST-DC-50",
      volume: "50ml",
      qty: 3,
      image: "assets/images/cups.png",
      date: "22/11/2025 | 10:00am",
    ),
    BorrowedDetails(
      resturantName: "Ancora Mediterranean",
      containerName: "Round Container",
      code: "ST-RDC-500",
      volume: "500ml",
      qty: 5,
      image: "assets/images/cups.png",
      date: "01/12/2025 | 10:00am",
    ),
    BorrowedDetails(
      resturantName: "Ancora Mediterranean",
      containerName: 'Rectangular Container',
      code: "ST-RC-600",
      volume: "900ml",
      qty: 2,
      image: "assets/images/cups.png",
      date: "27/11/2025 | 04:11pm",
    ),
    BorrowedDetails(
      resturantName: " Kimura-ya Authentic Japanese Resta",
      containerName: "Dip Cup | Round container",
      code: "ST-RC-600",
      volume: '600kl',
      qty: 5,
      image: 'assets/images/cups.png',
      date: "27/11/2025 | 04:11pm",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search by Resturant Name",
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                borderSide: BorderSide(color: Constant.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                borderSide: BorderSide(color: Constant.grey),
              ),
              fillColor: Constant.grey.withOpacity(0.1),
              filled: true,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list, color: Colors.white),
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: _groupByMonth().entries.map((entry) {
              final month = entry.key;
              final items = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _monthHeader(month, items.length),
                  const SizedBox(height: 6),

                  ...items.map(
                        (item) => _historyCard(
                      item: item,
                      context: context,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

      ],
    );
  }

  String _getMonthYear(String date) {
    final parts = date.split('|').first.trim(); // 22/11/2025
    final dateParts = parts.split('/'); // [22, 11, 2025]

    final month = int.parse(dateParts[1]);
    final year = dateParts[2];

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return '${months[month - 1]} $year';
  }

  Map<String, List<BorrowedDetails>> _groupByMonth() {
    final Map<String, List<BorrowedDetails>> grouped = {};

    for (final item in containers) {
      final monthKey = _getMonthYear(item.date);

      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(item);
    }

    return grouped;
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
              Image.asset(
                'assets/images/img.png',
                height: Constant.CONTAINER_SIZE_16,
                width: Constant.CONTAINER_SIZE_16,
              ),
              const SizedBox(width: 6),
              Text("$count", style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard({
    required BorrowedDetails item,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        _openDetailDialog(context, item.date, item);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constant.grey.withOpacity(0.2)),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    item.resturantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.containerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Text(
                        item.qty.toString(),
                        style: const TextStyle(
                          color: Color(0xFFFFC727),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 6),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white70,
                      ),
                    ],
                  ),

                  Text(
                    item.date,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetailDialog(BuildContext context, String dateTime, BorrowedDetails item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ReceiveDetailsDialog(dateTime: dateTime, title: 'Borrowed Details',
            item:[item]),
    );
  }
}
