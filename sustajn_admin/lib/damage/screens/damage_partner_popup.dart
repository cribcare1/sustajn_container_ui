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
                    Text(
                      Strings.DAMAGE_DETAILS,
                      style: TextStyle(
                        color: Constant.BeigeColor,
                        fontSize: Constant.CONTAINER_SIZE_18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_18),

                    Text(
                      "Product Name : ${product.restaurantName ?? ""}",
                      style: TextStyle(
                        color: Constant.BeigeColor,
                        fontSize: Constant.CONTAINER_SIZE_15,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_25),

                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Strings.BOWL_IMG,
                                width: Constant.CONTAINER_SIZE_35,
                                height: Constant.CONTAINER_SIZE_35,
                              ),
                              SizedBox(width: Constant.CONTAINER_SIZE_10),
                              Text(
                                "${damageContainer.dateWiseTotalDamageContainers ?? 0}",
                                style: TextStyle(
                                  color: Constant.PrimaryAssentColor,
                                  fontSize: Constant.CONTAINER_SIZE_32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: Constant.SIZE_08),

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

                    SizedBox(height: Constant.CONTAINER_SIZE_25),

                    Text(
                      Strings.CONTAINER,
                      style: TextStyle(
                        color: Constant.BeigeColor,
                        fontSize: Constant.SIZE_17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_12),

                    Container(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                      decoration: BoxDecoration(
                        color: Constant.BeigeColor.withOpacity(.05),
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                        border: Border.all(color: Constant.BeigeColor.withOpacity(.1)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Constant.SIZE_08),
                            child: Image.asset(
                              "assets/images/dipcup.png",
                              width: Constant.CONTAINER_SIZE_35,
                              height: Constant.CONTAINER_SIZE_35,
                              fit: BoxFit.cover,
                            )
                          ),

                          SizedBox(width: Constant.CONTAINER_SIZE_14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName ?? "",
                                  style: TextStyle(
                                    color: Constant.BeigeColor,
                                    fontSize: Constant.CONTAINER_SIZE_16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: Constant.SIZE_05),

                                Text(
                                  product.productUniqueId ?? "",
                                  style: TextStyle(color: Constant.BeigeColor),
                                ),

                                SizedBox(height: Constant.SIZE_05),

                                Text(
                                  "${product.capacity ?? 0} ml",
                                  style: TextStyle(color: Constant.BeigeColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),
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
                decoration: BoxDecoration(
                  color: Constant.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(Constant.SIZE_07),
                child: Icon(Icons.close, color: Constant.black, size: Constant.CONTAINER_SIZE_22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
