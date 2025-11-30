import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/custom_buttons.dart';
import 'customer_details_screen.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  bool isTabChange = true;

  final List<Map<String, dynamic>> users = [
    {
      "name": "Jackson",
      "image": "assets/images/user.png",
      "borrowed": 10,
      "returned": 20,
      "pending": 0,
    },
    {
      "name": "Liam Anderson",
      "image": null, // no image → show placeholder circle icon
      "borrowed": 5,
      "returned": 10,
      "pending": 0,
    },
    {
      "name": "Noah Carter",
      "image": "assets/images/user.png",
      "borrowed": 0,
      "returned": 0,
      "pending": 2,
    },
    {
      "name": "Mason Walker",
      "image": "assets/images/user.png",
      "borrowed": 3,
      "returned": 15,
      "pending": 0,
    },
    {
      "name": "Jackson Hayes",
      "image": null,
      "borrowed": 7,
      "returned": 6,
      "pending": 4,
    },
    {
      "name": "Aiden Cooper",
      "image": null,
      "borrowed": 12,
      "returned": 6,
      "pending": 5,
    },
    {
      "name": "Kiran Kumar",
      "image": "assets/images/user.png",
      "borrowed": 4,
      "returned": 0,
      "pending": 0,
    },
  ];
  List<String> statusList = ["Active Customer","In Active Customer"];
String? selectedStatus;
List<String> subscriptionType = ["Monthly-Popular","Monthly-Pay-Per-Use","Yearly-Popular","Yearly-Pay-Per-Use"];
String? selectedSubscriptionType;
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false,bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Customers",
          leading: const SizedBox.shrink(),
          action: [
            IconButton(onPressed: (){}, icon: Icon(Icons.search)),
            IconButton(onPressed: (){_filterBottomSheet(context);}, icon: Icon(Icons.filter_alt_outlined)),

          ]
        ).getAppBar(context),
        body: ListView.separated(
          padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          itemCount: users.length,
          separatorBuilder: (_, __) =>  SizedBox(height: Constant.CONTAINER_SIZE_10),

          itemBuilder: (context, index) {
            final user = users[index];

            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerDetailsScreen()));
              },
              child: Container(
                padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12, horizontal: Constant.SIZE_008),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ],
                ),
              
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      // USER IMAGE or ICON
                      user["image"] == null
                          ? const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xffE6F7EC),
                        child: Icon(Icons.person_outline, color: Colors.green),
                      )
                          : CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(user["image"]),
                      ),
                       SizedBox(width:Constant.SIZE_08),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _statusDot(Colors.orange),
                                Text(" Borrowed – ${user["borrowed"]}",
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 12),
              
                                _statusDot(Colors.green),
                                Text(" Returned – ${user["returned"]}",
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 12),
              
                                _statusDot(Colors.red),
                                Text(" Pending – ${user["pending"]}",
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _statusDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
  void _filterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [

                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.close, size: 22),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Filters",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [

                        // Left Tabs
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              _selectorTab(
                                label: "Status",
                                isSelected: isTabChange,
                                onTap: () {
                                  setSheetState(() {
                                    isTabChange = true;
                                  });
                                },
                              ),

                              const SizedBox(height: 25),

                              _selectorTab(
                                label: "Subscription Type",
                                isSelected: !isTabChange,
                                onTap: () {
                                  setSheetState(() {
                                    isTabChange = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const VerticalDivider(width: 20, thickness: 1),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isTabChange
                                ? _buildStatusView(setSheetState)
                                : _buildSubscriptionView(setSheetState),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setSheetState(() {
                                  selectedStatus = null;
                                  selectedSubscriptionType = null;
                                });
                              },
                              child: const Text("Clear"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Apply"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Status View
  Widget _buildStatusView(Function(void Function()) setSheetState) {
    return ListView.builder(
      itemCount: statusList.length,
      itemBuilder: (context, index) {
        final item = statusList[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item, style: const TextStyle(fontSize: 15)),

            Checkbox(
              value: selectedStatus == item,
              onChanged: (value) {
                setSheetState(() {
                  selectedStatus = value == true ? item : null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Subscription View
  Widget _buildSubscriptionView(Function(void Function()) setSheetState) {
    return ListView.builder(
      itemCount: subscriptionType.length,
      itemBuilder: (context, index) {
        final item = subscriptionType[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item, style: const TextStyle(fontSize: 15)),

            Checkbox(
              value: selectedSubscriptionType == item,
              visualDensity: VisualDensity(vertical: 0,horizontal: 0),
              onChanged: (value) {
                setSheetState(() {
                  selectedSubscriptionType = value == true ? item : null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Tab Widget
  Widget _selectorTab({
    required String label,
    required bool isSelected,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 80,
              height: 2,
              color: Colors.green,
            ),
        ],
      ),
    );
  }

}
