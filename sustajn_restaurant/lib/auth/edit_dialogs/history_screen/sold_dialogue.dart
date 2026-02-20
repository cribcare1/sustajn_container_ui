import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../models/sold_container_data.dart';
import '../../../utils/utility.dart';

class SoldDialog extends ConsumerStatefulWidget {
  final DateWiseSoldContainers soldItem;

  const SoldDialog({super.key, required this.soldItem});

  @override
  ConsumerState<SoldDialog> createState() => _SoldDialogState();
}

class _SoldDialogState extends ConsumerState<SoldDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = widget.soldItem.products ?? [];

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(theme, context, widget.soldItem),
              SizedBox(height: Constant.SIZE_15),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_10),
                itemBuilder: (context, index) =>
                    _containerCard(products[index], theme),
              ),
            ],
          ),
          Utils.buildFloatingHeader(context),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme, BuildContext context, DateWiseSoldContainers item) {
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
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        Text(
          "${Strings.TOTAL_DAMAGED}: ${item.dateWiseTotalDamageContainers}",
          style: theme.textTheme.titleMedium?.copyWith(color: Constant.gold),
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
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
        border: Border.all(color: Constant.grey.withOpacity(0.2)),
      ),
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
            product.productImageUrl != null &&
                product.productImageUrl!.isNotEmpty
                ? Image.network(
              product.productImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Strings.bowlImg,
                  fit: BoxFit.contain,
                );
              },
            )
                : Image.asset(Strings.bowlImg, fit: BoxFit.contain),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? "",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),

                if (product.productDescription?.isNotEmpty == true)
                  Text(
                    product.productDescription!,
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

          Text(
            "1",
            style: theme.textTheme.titleLarge?.copyWith(color: Constant.gold),
          ),
        ],
      ),
    );
  }
}
