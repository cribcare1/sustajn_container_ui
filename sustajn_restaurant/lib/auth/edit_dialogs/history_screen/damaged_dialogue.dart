import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';

import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../models/damaged_container_data.dart';
import '../../../utils/utility.dart';

class DamagedDialog extends ConsumerStatefulWidget {
  final DamageContainers damageItem;

  const DamagedDialog({super.key, required this.damageItem});

  @override
  ConsumerState<DamagedDialog> createState() => _DamagedDialogState();
}

class _DamagedDialogState extends ConsumerState<DamagedDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = widget.damageItem.products ?? [];

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constant.CONTAINER_SIZE_30),
              ),
            ),
            child: Column(
              children: [
                _header(theme, context, widget.damageItem),
                SizedBox(height: Constant.SIZE_15),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: products.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: Constant.SIZE_10),
                    itemBuilder: (context, index) =>
                        _containerCard(products[index], theme),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header(ThemeData theme, BuildContext context, DamageContainers item) {
    return Column(
      children: [
        Container(
          width: Constant.CONTAINER_SIZE_60,
          height: Constant.SIZE_05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.SIZE_05),
            color: Colors.white,
          ),
        ),

        SizedBox(height: Constant.SIZE_15),

        Row(
          children: [
            Text(
              Strings.DAMAGED_DTLS,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Strings.BOWL_IMG,
              height: Constant.CONTAINER_SIZE_30,
              width: Constant.CONTAINER_SIZE_30,
            ),
            SizedBox(width: Constant.SIZE_06),
            Text(
              "${item.dateWiseTotalDamageContainers}",
              style: theme.textTheme.titleLarge?.copyWith(color: Constant.gold,fontWeight: FontWeight.w700),
            ),
          ],
        ),

        SizedBox(height: Constant.SIZE_06),

        Text(
          item.localDateTime ?? "",
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _containerCard(Products product, ThemeData theme) {
    return GlassSummaryCard(
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_50,
            height: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              color: Constant.grey,
            ),
            clipBehavior: Clip.antiAlias,
            child:
                product.damageImagesUrls != null &&
                    product.damageImagesUrls!.isNotEmpty
                ? Image.network(
                    product.damageImagesUrls!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Strings.BOWL_IMG,
                        fit: BoxFit.contain,
                      );
                    },
                  )
                : Image.asset(Strings.BOWL_IMG, fit: BoxFit.contain),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),

                  Text(
                    product.productUniqueId??"",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  "${product.capacity} ml",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
