import 'package:flutter/material.dart';
import '../models/damage_user_data.dart';


class DamageDetailsPopup extends StatelessWidget {
  final DamageContainers damageContainer;
  final Products product;

  const DamageDetailsPopup({
    super.key,
    required this.damageContainer,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.tryParse(
      damageContainer.localDateTime ?? "",
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0E3B2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Damage Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "User ID: ${product.customerId ?? ""}",
                  style: const TextStyle(color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/bowl_img.png"),
                          const SizedBox(width: 5),
                          Text(
                            "${damageContainer.dateWiseTotalDamageContainers ?? 0}",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        dateTime == null
                            ? ""
                            : "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                        style: const TextStyle(color: Colors.white70),
                      ),

                      Text(
                        dateTime == null
                            ? ""
                            : "${TimeOfDay.fromDateTime(dateTime).format(context)}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Containers",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.productImageUrl ?? "",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.productUniqueId ?? "",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "${product.capacity ?? 0} ml",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: -15,
            right: -15,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}