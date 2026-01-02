import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/lease_receive/screens/receive_scan_screen.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../model/assign_container_model.dart';

class ReceiveProductListScreen extends StatefulWidget {
  final String type;
  final String? damage;
  const ReceiveProductListScreen({super.key, required this.type,this.damage});

  @override
  State<ReceiveProductListScreen> createState() => _ReceiveProductListScreenState();
}

class _ReceiveProductListScreenState extends State<ReceiveProductListScreen> {
  List<AssignedContainerModel> assignedContainers = [
    AssignedContainerModel(
      image: 'assets/images/cups.png',
      name: 'Dip Cups',
      id: 'ST-DC-50',
      volume: '50ml',
      quantity: 2,
    ),
    AssignedContainerModel(
      image: 'assets/images/cups.png',
      name: 'Round Container',
      id: 'ST-RB-450',
      volume: '450ml',
      quantity: 1,
    ),
    AssignedContainerModel(
      image: 'assets/images/cups.png',
      name: 'Rectangular Container',
      id: 'ST-RC-600',
      volume: '900ml',
      quantity: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Receive product",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.badge, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Customer ID: ABC-1234',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/img.png",
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(width: Constant.SIZE_08),
                        Text(
                          assignedContainers.length.toString(),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_20),
                  Text(
                    "Available Containers",
                    textAlign: TextAlign.start,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                ),
                itemCount: assignedContainers.length,
                itemBuilder: (context, index) {
                  return _containerCard(
                    item: assignedContainers[index],
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: Constant.CONTAINER_SIZE_10),
              ),
            ),
          ],
        ),
        floatingActionButton: InkWell(onTap: (){
          Utils.navigateToPushScreen(context, ReceiveScanScreen(type: widget.type,previous: "list",));
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white),
            color: Theme.of(context).secondaryHeaderColor,
          ),
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
          child: Icon(Icons.qr_code_scanner_rounded,color: Theme.of(context).primaryColor,),
        ),
        ),
        bottomSheet: Container(
          // width: double.infinity,
          color: theme.primaryColor,
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: SubmitButton(
            onRightTap: () {
            },
            rightText: "Confirm Receive",
          ),
        ),
      ),
    );
  }

  Widget _containerCard({
    required AssignedContainerModel item,
  }) {
    return GlassSummaryCard(
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(item.image, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.id,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  item.volume,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.quantity.toString(),
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showConfirmIssuePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      isDismissible: false,
      useSafeArea: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            left: Constant.CONTAINER_SIZE_16,
            right: Constant.CONTAINER_SIZE_16,
            top: Constant.CONTAINER_SIZE_16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD4AF37),
                  size: 32,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              const Text(
                'Confirm receive Containers?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                'You are about to issue the assigned containers to this '
                    'customer. Once issued, the containers will be added '
                    'to the customer’s active borrowing list.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              SubmitClearButton(
                onLeftTap: () {
                  Navigator.pop(context);
                },
                leftText: "Cancel",
                onRightTap: () {},
                rightText: "Confirm",
              ),
            ],
          ),
        );
      },
    );
  }
}
