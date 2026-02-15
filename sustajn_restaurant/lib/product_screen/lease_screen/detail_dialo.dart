import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../models/container_history_data.dart';

class LeaseDetailsDialog extends StatelessWidget {
  final LeasedResponses data;

  const LeaseDetailsDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
              padding: EdgeInsets.all(Constant.SIZE_08),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: Constant.CONTAINER_SIZE_20,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_20,
              vertical: Constant.CONTAINER_SIZE_16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constant.CONTAINER_SIZE_30),
              ),
            ),
            child: Column(
              children: [
                _header(theme, context),
                SizedBox(height: Constant.CONTAINER_SIZE_24),
                Expanded(child: _buildContainersList(theme)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: Constant.CONTAINER_SIZE_60,
            height: Constant.SIZE_05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.SIZE_05),
              color: Colors.white30,
            ),
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_20),
        Text(
          "Lease Details",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: Constant.LABEL_TEXT_SIZE_20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_16),
        Row(
          children: [
            Icon(
              Icons.receipt_outlined,
              size: Constant.CONTAINER_SIZE_18,
              color: Colors.white70,
            ),
            SizedBox(width: Constant.SIZE_08),
            Text(
              "Order ID: #${data.orderId.toString().padLeft(8, '0')}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontSize: Constant.LABEL_TEXT_SIZE_14,
              ),
            ),
          ],
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_12),

        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/img.png",
                    height: Constant.CONTAINER_SIZE_40,
                    width: Constant.CONTAINER_SIZE_40,
                  ),
                  SizedBox(width: Constant.SIZE_08),
                  Text(
                    "${data.leasedQuantity}",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Color(0xFFFBBF24),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Constant.SIZE_08),
              Text(
                _formatDateTime(data.leasedStartDateTime ?? ''),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_12),

      ],
    );
  }

  Widget _buildContainersList(ThemeData theme) {
    if (data.productOrderListResponses == null ||
        data.productOrderListResponses!.isEmpty) {
      return Center(
        child: Text(
          "No containers found",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white54,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_12),
      itemCount: data.productOrderListResponses!.length,
      separatorBuilder: (_, __) => SizedBox(height: Constant.CONTAINER_SIZE_12),
      itemBuilder: (context, index) {
        final product = data.productOrderListResponses![index];
        return _containerCard(product, theme);
      },
    );
  }

  Widget _containerCard(ProductOrderListResponses product, ThemeData theme) {
    return GlassSummaryCard(
      child: Row(
        children: [
          (product.productImageUrl != null && product.productImageUrl!.isNotEmpty)
              ? Container(
            height: Constant.CONTAINER_SIZE_70,
            width: Constant.CONTAINER_SIZE_70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
            ),
            padding: EdgeInsets.all(Constant.SIZE_06),
            child: Image.network(
              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${product.productImageUrl}",
              errorBuilder: (context, obj, stack) {
                return Image.asset(
                  "assets/images/no_image_container.png",
                  fit: BoxFit.contain,
                );
              },
              fit: BoxFit.contain,
            ),
          )
              : Container(
            width: Constant.CONTAINER_SIZE_70,
            height: Constant.CONTAINER_SIZE_70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
            ),
            child: Center(
              child: Icon(
                Icons.inbox_outlined,
                size: Constant.CONTAINER_SIZE_30,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  product.productUniqueId ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  '${product.capacity ?? 0}ml',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${product.containerCount ?? 0}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Color(0xFFFBBF24),
              fontSize: Constant.LABEL_TEXT_SIZE_18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    return dateTimeStr.replaceAll('|', ' | ');
  }
}