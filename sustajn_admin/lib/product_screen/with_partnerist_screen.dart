import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

class WithPartnerListScreen extends ConsumerStatefulWidget {
  const WithPartnerListScreen({super.key});

  @override
  ConsumerState<WithPartnerListScreen> createState() =>
      _InCirculationScreenState();
}

class _InCirculationScreenState extends ConsumerState<WithPartnerListScreen> {
  final TextEditingController searchController = TextEditingController();

  /// Replace with API list
  final List<Map<String, dynamic>> users = [
    {
      "name": "The Oberoi Hotel",
      "address": "Al A'amal Street, Business Bay, Dubai",
      "qty": 2,
    },
    {"name": "Hilton Dubai Palm", "address": "Palm Jumeirah, Dubai", "qty": 10},
    {"name": "Sheraton Mall", "address": "Mall of Emirates, Dubai", "qty": 6},
    {"name": "Atlantis", "address": "Palm Jumeirah", "qty": 12},
    {"name": "Rove Downtown", "address": "Downtown Dubai", "qty": 4},
    {"name": "JW Marriott", "address": "Business Bay", "qty": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.PrimaryColor,

      appBar: CustomAppBar(
        title: Strings.INCRICULATION,
        leading: CustomBackButton(onTap: () => Navigator.pop(context)),
      ).getAppBar(context),

      body: Column(
        children: [
          SizedBox(height: Constant.CONTAINER_SIZE_12),

          /// PRODUCT CARD
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
            child: Container(
              height: Constant.CONTAINER_SIZE_80,
              padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Container(
                    width: Constant.CONTAINER_SIZE_55,
                    height: Constant.CONTAINER_SIZE_55,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(Constant.SIZE_08),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Constant.SIZE_08),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1615485290382-441e4d049cb5",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_12),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dip Cup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constant.CONTAINER_SIZE_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: Constant.SIZE_02),

                        Text(
                          "ST-DC-50",
                          style: TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_13),
                        ),

                        SizedBox(height: Constant.SIZE_03),

                        Text(
                          "50 ml",
                          style: TextStyle(color: Colors.white54, fontSize: Constant.CONTAINER_SIZE_12),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "1500",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: Constant.CONTAINER_SIZE_24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_18),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
            child: Container(
              height: Constant.CONTAINER_SIZE_50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(color: Colors.white24),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search by Partner Name",
                  hintStyle: TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: Constant.SIZE_01, height: Constant.CONTAINER_SIZE_24, color: Colors.white24),

                      SizedBox(width: Constant.SIZE_10),

                      const Icon(Icons.filter_list, color: Colors.white70),

                      SizedBox(width: Constant.SIZE_10),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_16),

          /// LIST START
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
              itemCount: users.length,
              separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_10),
              itemBuilder: (context, index) {
                final item = users[index];

                return Container(
                  height: Constant.CONTAINER_SIZE_70,
                  padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Constant.CONTAINER_SIZE_16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: Constant.SIZE_04),

                            Text(
                              item["address"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.55),
                                fontSize: Constant.CONTAINER_SIZE_13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        item["qty"].toString(),
                        style: TextStyle(
                          color: Constant.PrimaryAssentColor,
                          fontSize: Constant.CONTAINER_SIZE_24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
