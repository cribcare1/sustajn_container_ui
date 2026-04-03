import 'package:flutter/material.dart';

class DemoScreenn extends StatelessWidget {
  const DemoScreenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: ElevatedButton(
          onPressed: () => showMoreDetails(context),
          child: const Text("Open More Details"),
        ),
      ),
    );
  }
}

void showMoreDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Stack(
        children: [


          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF0F3727),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [


                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 12),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "More Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.edit_outlined,
                        color: Colors.white70, size: 18),
                  ],
                ),

                const SizedBox(height: 14),


                Expanded(
                  child: ListView(
                    children: const [

                      DetailItem(
                        title: "Container Description",
                        value:
                        "Lorem ipsum dolor sit amet consectetur. Arcu enim consectetur porttitor gravida ut a viverra sit mattis. Sed consequat quisque in urna ullamcorper.",
                        isLongText: true,
                      ),

                      DetailItem(title: "Container Material", value: "Lorem Ipsum"),
                      DetailItem(title: "Container Color", value: "Silver"),
                      DetailItem(title: "Dimension Length cm", value: "15cm"),
                      DetailItem(title: "Dimension Height cm", value: "7cm"),
                      DetailItem(title: "Weight Grams", value: "100grams"),
                      DetailItem(title: "Food Safe", value: "-"),
                      DetailItem(title: "Dish wash Safe", value: "-"),
                      DetailItem(title: "Microwave Safe", value: "-"),
                      DetailItem(title: "Max Temperature", value: "-"),
                      DetailItem(title: "Min Temperature", value: "-"),
                      DetailItem(title: "Lifespan Cycle", value: "-"),
                      DetailItem(title: "Cost Per Unit", value: "-"),
                    ],
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            right: 16,
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18),
              ),
            ),
          ),
        ],
      );
    },
  );
}


class DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isLongText;

  const DetailItem({
    super.key,
    required this.title,
    required this.value,
    this.isLongText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 4),


          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isLongText ? 12 : 13,
              height: isLongText ? 1.4 : 1.2,
            ),
          ),

          const SizedBox(height: 10),


          Container(
            height: 1,
            color: Colors.white12,
          ),
        ],
      ),
    );
  }
}