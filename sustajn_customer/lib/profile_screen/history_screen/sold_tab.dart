import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import 'model/detail_model.dart';

class SoldTab extends StatelessWidget {
   SoldTab({super.key});

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
       price: "120"
     ),
     BorrowedDetails(
       resturantName: "Ancora Mediterranean",
       containerName: "Round Container",
       code: "ST-RDC-500",
       volume: "500ml",
       qty: 5,
       image: "assets/images/cups.png",
       date: "01/12/2025 | 10:00am",
         price: "120"
     ),
     BorrowedDetails(
       resturantName: "Ancora Mediterranean",
       containerName: 'Rectangular Container',
       code: "ST-RC-600",
       volume: "900ml",
       qty: 2,
       image: "assets/images/cups.png",
       date: "27/11/2025 | 04:11pm",
         price: "120"
     ),
     BorrowedDetails(
       resturantName: " Kimura-ya Authentic Japanese Resta",
       containerName: "Dip Cup | Round container",
       code: "ST-RC-600",
       volume: '600kl',
       qty: 5,
       image: 'assets/images/cups.png',
       date: "27/11/2025 | 04:11pm",
         price: "120"
     ),
   ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_12),
            children: _groupByMonth().entries.map((entry) {
              final month = entry.key;
              final items = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _monthHeader(month, items.length),
                   SizedBox(height: Constant.SIZE_06),

                  ...items.map(
                        (item) => _soldItemCard(
                      item: item,
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

  _soldItemCard({
    required BorrowedDetails item,
    }) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: Constant.SIZE_08),
      padding:  EdgeInsets.all(Constant.SIZE_10),

      decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(
              color: Constant.grey.withOpacity(0.2)
          )
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            item.date,
            style:  TextStyle(
              color: Colors.white70,
              fontSize: Constant.CONTAINER_SIZE_12,
            ),
          ),

           SizedBox(height: Constant.SIZE_10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                child: Image.asset(
                  item.image,
                  height: Constant.CONTAINER_SIZE_60,
                  width: Constant.CONTAINER_SIZE_60,
                  fit: BoxFit.cover,
                ),
              ),

               SizedBox(width: Constant.CONTAINER_SIZE_14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.containerName,
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: Constant.CONTAINER_SIZE_15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),


                    Text(
                      item.code,
                      style:  TextStyle(
                        color: Colors.white70,
                        fontSize: Constant.CONTAINER_SIZE_13,
                      ),
                    ),


                    Text(
                      item.qty.toString(),
                      style:  TextStyle(
                        color: Colors.white60,
                        fontSize: Constant.CONTAINER_SIZE_12,
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
                      Image.asset('assets/images/img.png',
                        height: Constant.CONTAINER_SIZE_16,
                        width: Constant.CONTAINER_SIZE_16,),
                       SizedBox(width: Constant.SIZE_04),

                      Text(
                       item.qty.toString(),
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, size: Constant.CONTAINER_SIZE_18, color: Colors.white,),
                      Text(
                        item.price!,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthHeader(String title, int count) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: Constant.SIZE_06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(

            children: [
              Image.asset('assets/images/img.png',
                height: Constant.CONTAINER_SIZE_16,
                width: Constant.CONTAINER_SIZE_16,),
               SizedBox(width: Constant.SIZE_06),
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
}