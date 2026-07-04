import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/constants/imports.util.dart';

import '../../common_widgets/custom_back_button.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';

class PendingDetailsScreen extends StatefulWidget {
  const PendingDetailsScreen({super.key});

  @override
  State<PendingDetailsScreen> createState() => _PendingDetailsScreenState();
}

class _PendingDetailsScreenState extends State<PendingDetailsScreen> {
  final List<Map<String, String>> containerList = [
    {
      "image": "assets/images/dipcup.png",
      "title": "Dip Cups",
      "code": "ST-DC-50",
      "size": "50ml",
      "qty": "550",
    },
    {
      "image": "assets/images/round_container.png",
      "title": "Round Container",
      "code": "ST-RDC-500",
      "size": "500ml",
      "qty": "450",
    },
    {
      "image": "assets/images/dipcup.png",
      "title": "Rectangle Container",
      "code": "ST-RC-750",
      "size": "750ml",
      "qty": "300",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(false);

    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.ORDER_DETAILS,
        leading: const CustomBackButton(),
      ).getAppBar(context),

      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _restaurantDetails(
              themeData!,
              "Bravo Avocado",
              "Various Locations - Business Bay Branch",
            ),

            SizedBox(height: Constant.SIZE_18),

            _orderDetails(themeData),

            SizedBox(height: Constant.SIZE_18),

            _sectionTitle(themeData),

            SizedBox(height: Constant.SIZE_18),

            Expanded(
              child: ListView.separated(
                itemCount: containerList.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: Constant.CONTAINER_SIZE_14),
                itemBuilder: (context, index) {
                  final item = containerList[index];

                  return _containerItem(
                    themeData,
                    image: item["image"]!,
                    title: item["title"]!,
                    code: item["code"]!,
                    size: item["size"]!,
                    qty: item["qty"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomButtons(themeData!),
    );
  }


  Widget _restaurantDetails(
      ThemeData themeData,
      String restaurantName,
      String address,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            restaurantName,
            style: themeData.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: Constant.SIZE_10),

          Row(
            children: [

              Image.asset(
                "assets/icons/location.png",
                width: 16,
                height: 16,
              ),

              SizedBox(width: Constant.SIZE_08),

              Expanded(
                child: Text(
                  address,
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white54,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _orderDetails(ThemeData themeData) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Image.asset(
              "assets/icons/order.png",
              width: 18,
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Order ID",
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white60,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "#ORD-00234",
                  style: themeData.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),

                Center(
                    child:Container(
                      padding: const EdgeInsets.only(bottom: 0.1),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffD9A91F),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        "Partner Remarks",
                        style: themeData.textTheme.bodySmall!.copyWith(
                          color: const Color(0xffD9A91F),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),

          Image.asset(
            "assets/icons/dropdown.png",
            width: 18,
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData themeData) {
    return Row(
      children: [

        Text(
          "Ordered Containers",
          style: themeData.textTheme.titleMedium,
        ),

        SizedBox(width: Constant.CONTAINER_SIZE_12),

        Expanded(
          child: Divider(
            color: const Color(0xffD9A91F),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _containerItem(
      ThemeData themeData, {
        required String image,
        required String title,
        required String code,
        required String size,
        required String qty,
      }) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(image),
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: themeData.textTheme.titleMedium,
                ),

                SizedBox(height: Constant.SIZE_04),

                Text(
                  code,
                  style: themeData.textTheme.bodySmall!
                      .copyWith(color: Colors.white60),
                ),

                SizedBox(height: Constant.SIZE_02),

                Text(
                  size,
                  style: themeData.textTheme.bodySmall!
                      .copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                "Ordered Qty.",
                style: themeData.textTheme.bodySmall!
                    .copyWith(color: Colors.white60),
              ),

              SizedBox(height: Constant.SIZE_04),

              Text(
                qty,
                style: themeData.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: const Color(0xffD9A91F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons(ThemeData themeData) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Row(
          children: [

            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    Strings.REJECT_ORDER,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(width: Constant.CONTAINER_SIZE_12),

            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD9A91F),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    Strings.CONFIRM_ORDER,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// _getPendingOrderNetworkCall() async {
//   try {
//     await ref.read(networkProvider.notifier).isNetworkAvailable().then((
//         isNetworkAvailable,
//         ) {
//       Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
//       final orderState = ref.read(orderRequestProvider);
//       if (isNetworkAvailable) {
//         orderState.setIsLoading(true);
//         // final userId = Utils.userId;
//         final url = '${NetworkUrls.PENDING_ORDER_DATA}';
//         ref.read(getPendingOrderProvider(url));
//       } else {
//         orderState.setIsLoading(false);
//         Utils.showToast(Strings.NO_INTERNET_CONNECTION);
//       }
//     });
//   } catch (e) {
//     Utils.printLog('Error in visitor button onPressed: $e');
//   }
// }
}