import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
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
    final dateTime = DateTime.tryParse(damageContainer.localDateTime ?? "");

    return SafeArea(
      child: Wrap(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_18),
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
                        color: Constant.white,
                        fontSize: Constant.CONTAINER_SIZE_18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_12),

                    Text(
                      "User ID : ${product.customerId ?? ""}",
                      style: TextStyle(
                        color: Constant.BeigeColor,
                        fontSize: Constant.CONTAINER_SIZE_16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),

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
                              SizedBox(width: Constant.SIZE_08),
                              Text(
                                "${damageContainer.dateWiseTotalDamageContainers ?? 0}",
                                style: TextStyle(
                                  color: Constant.PrimaryAssentColor,
                                  fontSize: Constant.CONTAINER_SIZE_30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

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

                    SizedBox(height: Constant.CONTAINER_SIZE_20),

                    Text(
                      Strings.CONTAINER,
                      style: TextStyle(
                        color: Constant.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_10),

                    Container(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                      decoration: BoxDecoration(
                        color: Constant.white.withOpacity(.05),
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                        border: Border.all(
                          color: Constant.white.withOpacity(.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Constant.SIZE_08),
                            child: Image.asset(
                              "assets/images/dipcup.png",
                              width: Constant.CONTAINER_SIZE_35,
                              height: Constant.CONTAINER_SIZE_35,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(width: Constant.CONTAINER_SIZE_12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName ?? "",
                                  style: TextStyle(
                                    color: Constant.BeigeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: Constant.SIZE_04),

                                Text(
                                  product.productUniqueId ?? "",
                                  style: TextStyle(
                                    color: Constant.BeigeColor,
                                  ),
                                ),

                                SizedBox(height: Constant.SIZE_04),

                                Text(
                                  "${product.capacity ?? 0} ml",
                                  style: TextStyle(
                                    color: Constant.BeigeColor,
                                  ),
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

              Positioned(
                top: Constant.CONTAINER_SIZE_10,
                right: Constant.CONTAINER_SIZE_10,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    radius: Constant.CONTAINER_SIZE_16,
                    backgroundColor: Constant.white,
                    child: Icon(
                      Icons.close,
                      size: Constant.SIZE_18,
                      color: Constant.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }}