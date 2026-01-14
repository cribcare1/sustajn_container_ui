import 'package:flutter/material.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';
import 'edit_address.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final List<Map<String, String>> addressList = [
    {
      "title": "Home",
      "address":
      "Unit 1402, Al Marsa Tower Sheikh Mohammed bin Rashid Blvd Downtown Dubai "
          "Dubai, United Arab Emirates P.O. Box 112233"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: CustomAppBar(
        title: "Address",
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addressList.length,
                itemBuilder: (context, index) {
                  return _addressCard(
                    context,
                    theme,
                    addressList[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: SizedBox(
            width: double.infinity,
            height: Constant.CONTAINER_SIZE_50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.gold,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(Constant.CONTAINER_SIZE_30),
                ),
              ),
              child: Text(
                "Add New Address",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addressCard(
      BuildContext context,
      ThemeData theme,
      Map<String, String> data,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_16),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        border: Border.all(color: Colors.white24, width: 0.4),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: Constant.CONTAINER_SIZE_22,
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"] ?? "",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: Constant.SIZE_06),

                Text(
                  data["address"] ?? "",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_10),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddressOptionsDialog(),
              );
            },
          child:Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          ),
        ],
      ),
    );
  }
}