import '../../../constants/imports.util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../model/user_borrowed_data.dart';

class DamageDetailsDialog extends StatelessWidget {
  final bool isReturned;
  final String title;
  final String? borrowedOn;
  final String? returnedOn;
  final List<BorrowedUiItem> items;

  DamageDetailsDialog({
    super.key,
    required this.title,
    required this.items,
    this.isReturned = false,
    this.borrowedOn,
    this.returnedOn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstItem = items.first;

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_60,
              height: Constant.SIZE_05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.SIZE_05),
                color: Constant.white,
              ),
            ),
            SizedBox(height: Constant.SIZE_15),

            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Constant.white,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Constant.white),
                ),
              ],
            ),

            SizedBox(height: Constant.SIZE_15),

            _damageHeader(theme, firstItem),

            SizedBox(height: Constant.CONTAINER_SIZE_25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Strings.CONTAINERS_TITLE,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Constant.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: Constant.SIZE_15),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_10),
              itemBuilder: (context, index) =>
                  _containerCard(items[index], theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _damageHeader(ThemeData theme, BorrowedUiItem item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Strings.BOWL_IMG,
              height: Constant.CONTAINER_SIZE_35,
              width: Constant.CONTAINER_SIZE_35,
              color: Constant.gold,
            ),
            SizedBox(width: Constant.SIZE_06),
            Text(
              item.containerCount.toString(),
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Constant.gold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "${item.date} | ${item.time}",
          style: theme.textTheme.bodySmall?.copyWith(color: Constant.white3),
        ),
      ],
    );
  }

  Widget _containerCard(BorrowedUiItem item, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
        border: Border.all(color: Constant.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          item.imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    NetworkUrls.IMAGE_BASE_URL + item.imageUrl,
                    width: Constant.CONTAINER_SIZE_60,
                    height: Constant.CONTAINER_SIZE_60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        Strings.CUP_IMG,
                        width: Constant.CONTAINER_SIZE_60,
                        height: Constant.CONTAINER_SIZE_60,
                      );
                    },
                  ),
                )
              : Image.asset(
                  Strings.CUP_IMG,
                  width: Constant.CONTAINER_SIZE_60,
                  height: Constant.CONTAINER_SIZE_60,
                ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Constant.white,
                  ),
                ),
                Text(
                  item.productId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Constant.white3,
                  ),
                ),
                Text(
                  '${item.capacity}ml',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Constant.white3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewResturantDetails(ThemeData theme, BorrowedUiItem item) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.restaurantName,
            style: theme.textTheme.titleMedium?.copyWith(color: Constant.white),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Constant.white,
                size: Constant.CONTAINER_SIZE_14,
              ),
              SizedBox(width: Constant.SIZE_06),
              Expanded(
                child: Text(
                  item.resturantAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Constant.white3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
