import 'package:flutter/material.dart';
import '../models/damage_partner_data.dart';

class DamagePartnerPopup extends StatelessWidget {
  final DamageContainers damageContainer;
  final Products product;

  const DamagePartnerPopup({
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

                const SizedBox(height: 15),


                Text(
                  "Product ID : ${product.productUniqueId ?? ""}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),


                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory_2,
                            color: Colors.amber,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${damageContainer.dateWiseTotalDamageContainers ?? 0}",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        dateTime == null
                            ? ""
                            : "${dateTime.day}.${dateTime.month}.${dateTime.year}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      Text(
                        dateTime == null
                            ? ""
                            : TimeOfDay.fromDateTime(dateTime).format(context),
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Container",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(.1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.productImageUrl ?? "",
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 55,
                          ),
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
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              product.productUniqueId ?? "",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${product.capacity ?? 0} ml",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Remark : ${product.damageRemark ?? "-"}",
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