import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as ref;

import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/history_provider.dart';
import '../../utils/utils.dart';
import 'model/detail_model.dart';

class SoldTab extends ConsumerStatefulWidget {
  const SoldTab({super.key});

  @override
  ConsumerState<SoldTab> createState() => _SoldTabState();
}
class _SoldTabState extends ConsumerState<SoldTab> {


  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSoldNetworkCall();
  }

   final List<BorrowedDetails> containers = [
     BorrowedDetails(
       resturantName: Strings.RESTAURANT_1,
       containerName: Strings.CONTAINER_1,
       code: Strings.CODE_1,
       volume: Strings.VOLUME_1,
       qty: 3,
       image: "assets/images/cups.png",
       date: Strings.DATE_1,
       price: "120"
     ),
     BorrowedDetails(
       resturantName: Strings.RESTAURANT_2,
       containerName: Strings.CONTAINER_2,
       code: Strings.CODE_2,
       volume: Strings.VOLUME_2,
       qty: 5,
       image: "assets/images/cups.png",
       date: Strings.DATE_2,
         price: "120"
     ),
     BorrowedDetails(
       resturantName: Strings.RESTAURANT_2,
       containerName: Strings.CONTAINER_3,
       code: Strings.CODE_3,
       volume: Strings.VOLUME_3,
       qty: 2,
       image: "assets/images/cups.png",
       date: Strings.DATE_3,
         price: "120"
     ),
     BorrowedDetails(
       resturantName: Strings.RESTAURANT_3,
       containerName: Strings.CONTAINER_4,
       code: Strings.CODE_3,
       volume: Strings.VOLUME_4,
       qty: 5,
       image: 'assets/images/cups.png',
       date: Strings.DATE_3,
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
   _getSoldNetworkCall() async {
     try {
       await ref.read(networkProvider.notifier as Uri).isNetworkAvailable().then((
           isNetworkAvailable,
           ) {
         Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
         final orderState = ref.read(historyProvider as Uri);
         if (isNetworkAvailable) {
           orderState.setIsLoading(true);
           final userId = Utils.userId;
           final url = '${NetworkUrls.GET_SOLD_CONTAINER}$userId';
           ref.read(getSoldContainerProvider(url) as Uri);
         } else {
           orderState.setIsLoading(false);
           Utils.showToast(Strings.NO_INTERNET_CONNECTION);
         }
       });
     } catch (e) {
       Utils.printLog('Error in visitor button onPressed: $e');
     }
   }
}

extension on Future<String> {
  isNetworkAvailable() {}

  void setIsLoading(bool bool) {}
}
