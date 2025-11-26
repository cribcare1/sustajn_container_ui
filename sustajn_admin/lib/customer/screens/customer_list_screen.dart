import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Customers",
        leading: const SizedBox.shrink(),
        action: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt_outlined)),

        ]
      ).getAppBar(context),
      body: ListView.separated(
        padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        itemCount: users.length,
        separatorBuilder: (_, __) =>  SizedBox(height: Constant.CONTAINER_SIZE_10),

        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
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
          );
        },
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
}
