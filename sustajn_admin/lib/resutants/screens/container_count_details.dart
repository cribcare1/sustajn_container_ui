import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/filter_buttom_sheet.dart';

class ContainerCountDetails extends ConsumerStatefulWidget {
  final String title;
  const ContainerCountDetails({super.key, required this.title});

  @override
  ConsumerState<ContainerCountDetails> createState() => _ContainerCountDetailsState();
}

class _ContainerCountDetailsState extends ConsumerState<ContainerCountDetails> {

  final List<Map<String, String>> items = [
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Dip Cups",
      "code": "ST-DC-50",
      "size": "50ml",
      "qty": "1,000",
    },
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Dip Cups",
      "code": "ST-DC-70",
      "size": "70ml",
      "qty": "500",
    },
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Dip Cups",
      "code": "ST-DC-80",
      "size": "80ml",
      "qty": "400",
    },
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Round Bowl",
      "code": "ST-DC-450",
      "size": "450ml",
      "qty": "300",
    },
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Round Bowl",
      "code": "ST-DC-900",
      "size": "900ml",
      "qty": "200",
    },
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Rectangular Container",
      "code": "ST-RC-600",
      "size": "600ml",
      "qty": "500",
    },
    {
      "image": "assets/images/bowl_image.jpg",
      "name": "Rectangular Container",
      "code": "ST-DC-100",
      "size": "100ml",
      "qty": "500",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: CustomBackButton(),
        title: widget.title,
        action: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){showFilterSheet(context);}, icon: Icon(Icons.filter_alt_outlined)),
        ],
      ).getAppBar(context),

      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_10),
          itemBuilder: (context, index) {
            final item = items[index];
            return _containerTile(
              image: item["image"]!,
              name: item["name"]!,
              code: item["code"]!,
              size: item["size"]!,
              qty: item["qty"]!,
            );
          },
        ),
      ),
    );
  }

  /// Single row tile
  Widget _containerTile({
    required String image,
    required String name,
    required String code,
    required String size,
    required String qty,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 55, height: 55, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(code,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(size,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Text(
            qty,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
void showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const FilterBottomSheet(),
  );
}
