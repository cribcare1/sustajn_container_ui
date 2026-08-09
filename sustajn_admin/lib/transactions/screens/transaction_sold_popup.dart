import 'package:container_tracking/constants/imports.util.dart';
import '../../../common_widgets/card_widget.dart';
import '../../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../models/transaction_sold_data.dart';

class TransactionSoldPopup extends StatelessWidget {
  final Transactions transactions;

  const TransactionSoldPopup({super.key, required this.transactions});

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
                color: Constant.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Constant.black,
                size: Constant.CONTAINER_SIZE_20,
              ),
            ),
          ),
        ),
        Container(
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
            ],
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
              color: Constant.ErroColor,
            ),
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_20),
        Text(
          Strings.SOLD_DETAILS,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Constant.white,
            fontSize: Constant.LABEL_TEXT_SIZE_20,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: Constant.CONTAINER_SIZE_16),

        (transactions.type == "USER")
            ? Row(
                children: [
                  Icon(
                    Icons.receipt_outlined,
                    size: Constant.CONTAINER_SIZE_18,
                    color: Constant.PrimaryDarkColor,
                  ),
                  SizedBox(width: Constant.SIZE_08),

                  Text(
                    "Customer ID ${transactions.customerId}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Constant.white,
                      fontSize: Constant.LABEL_TEXT_SIZE_20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1F5A44),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transactions.name ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      transactions.address ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: Constant.CONTAINER_SIZE_24),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  Strings.DIRHAM_IMG,
                  height: Constant.CONTAINER_SIZE_16,
                  color: Constant.orange,
                  colorBlendMode: BlendMode.srcIn,
                ),
                SizedBox(width: Constant.SIZE_02),
                Text(
                  transactions.totalAmount?.toString() ?? "",
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: Constant.PrimaryAssentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              transactions.formattedDate!,
            style: theme.textTheme.titleMedium!.copyWith(
            color: Constant.BeigeColor,
            fontWeight: FontWeight.w300,
            fontSize: Constant.CONTAINER_SIZE_14,
            )
            )
          ],
        ),

        SizedBox(height: Constant.CONTAINER_SIZE_24),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.containers!.length,
          itemBuilder: (container, i) =>
              _cardItem(transactions.containers![i], context),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_12),
      ],
    );
  }

  Widget _cardItem(Containers item, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Constant.green7, Constant.green8],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Constant.PrimaryDarkColor),
      ),
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_55,
            height: Constant.CONTAINER_SIZE_55,
            decoration: BoxDecoration(
              color: Constant.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
            ),
            child: Padding(
              padding: EdgeInsets.all(Constant.SIZE_08),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  border: Border.all(color: Constant.BeigeColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  child:
                  item!.imageUrl! != null && item.imageUrl!.isNotEmpty
                      ? Image.network(
                    "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.imageUrl}",
                    width: Constant.CONTAINER_SIZE_60,
                    height: Constant.CONTAINER_SIZE_60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Strings.CUP_IMG,
                        width: Constant.CONTAINER_SIZE_60,
                        height: Constant.CONTAINER_SIZE_60,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    Strings.CUP_IMG,
                    width: Constant.CONTAINER_SIZE_60,
                    height: Constant.CONTAINER_SIZE_60,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.containerName!,
                  style: TextStyle(
                    color: Constant.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  item.productCode!,
                  style: TextStyle(
                    color: Constant.BeigeColor,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                Text(
                  item.capacity!,
                  style: TextStyle(
                    color: Constant.BeigeColor,
                    fontSize: Constant.CONTAINER_SIZE_11,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Row(
                children: [
                  Image.asset(
                  Strings.BOWL_IMG,
                  height: Constant.CONTAINER_SIZE_16,
                  color: Constant.orange,
                  colorBlendMode: BlendMode.srcIn,
                ),

                  SizedBox(width: Constant.SIZE_06),

                  Text(
                    '${item.quantity}',
                    style: TextStyle(
                      color: Constant.BeigeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(width: Constant.SIZE_06),

              Row(
                children: [
                  Image.asset(
                    Strings.DIRHAM_IMG,
                    height: Constant.CONTAINER_SIZE_16,
                    color: Constant.PrimaryAssentColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),

                  SizedBox(width: Constant.SIZE_06),

                  Text(
                    '${item.price}',
                    style: TextStyle(
                      color: theme.secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}
