import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
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
    final dateTime = DateTime.tryParse(damageContainer.localDateTime ?? "");

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Wrap(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: Constant.CONTAINER_SIZE_25),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: BoxDecoration(
                  color: Constant.PrimaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constant.CONTAINER_SIZE_24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      Strings.DAMAGE_DETAILS,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "Product Name : ${product.restaurantName ?? ""}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Strings.BOWL_IMG,
                                width: 34,
                                height: 34,
                              ),
                              const SizedBox(width: 10),
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

                          const SizedBox(height: 8),

                          SizedBox(height: Constant.CONTAINER_SIZE_12),

                          Text(
                            damageContainer.localDateTime ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Constant.BeigeColor,
                              fontSize: Constant.CONTAINER_SIZE_14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      Strings.CONTAINER,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(.1)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "assets/images/dipcup.png",
                              width: Constant.CONTAINER_SIZE_35,
                              height: Constant.CONTAINER_SIZE_35,
                              fit: BoxFit.cover,
                            )
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  product.productUniqueId ?? "",
                                  style: const TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "${product.capacity ?? 0} ml",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            right: 18,
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(7),
                child: const Icon(Icons.close, color: Colors.black, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
