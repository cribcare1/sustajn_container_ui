import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_provider/network_provider.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../provider/order_provider.dart';
import '../utils/utility.dart';
import 'delete_bottomsheet.dart';

class ContainerDetailedScreen extends ConsumerStatefulWidget {
  const ContainerDetailedScreen({super.key});

  @override
  ConsumerState<ContainerDetailedScreen> createState() =>
      _ContainerDetailedScreenState();
}

class _ContainerDetailedScreenState
    extends ConsumerState<ContainerDetailedScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInventoryDetailsNetworkCall(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final inventory = orderState.getInventoryDetailsData;
    const bg = Constant.PrimaryColor;
    const gold = Constant.PrimaryAssentColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: CustomAppBar(
      title: Strings.CONTAINER_DETAILS,
      leading: CustomBackButton(
        onTap: () => Navigator.pop(context),
      ),
      action: [
        PopupMenuButton<String>(
          constraints: BoxConstraints(
            minWidth: Constant.CONTAINER_SIZE_120,
            maxWidth: Constant.CONTAINER_SIZE_120,
          ),
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          ),
          onSelected: (value) {
            if (value == 'edit') {
              // Edit action
            } else if (value == 'delete') {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const DeleteBottomSheet(),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Image.asset(Strings.EDIT_ICON),
                  SizedBox(width: Constant.CONTAINER_SIZE_10),
                   Text(
                    Strings.EDIT,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: Constant.CONTAINER_SIZE_16,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Image.asset(Strings.DELETE_ICON),
                  SizedBox(width: Constant.CONTAINER_SIZE_10),
                  Text(
                    Strings.DELETE,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: Constant.CONTAINER_SIZE_16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).getAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            Center(
              child: Container(
                width: Constant.CONTAINER_SIZE_278,
                height: Constant.CONTAINER_SIZE_272,
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Constant.green5, Constant.green6],
                  ),
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_18,
                  ),
                  border: Border.all(color: gold),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_10,
                      ),
                      child: Image.network(
                        "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${inventory?.imageUrl ?? ""}",
                        height: Constant.CONTAINER_SIZE_100,
                        width: Constant.CONTAINER_SIZE_100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Strings.NO_IMG,
                            height: Constant.CONTAINER_SIZE_90,
                            width: Constant.CONTAINER_SIZE_90,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    Text(
                      inventory?.name ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Constant.CONTAINER_SIZE_18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Constant.SIZE_04),
                    Text(
                      inventory?.productCode ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Constant.CONTAINER_SIZE_14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Constant.SIZE_02),
                    Text(
                      inventory?.capacity ?? "",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: Constant.CONTAINER_SIZE_16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: Constant.SIZE_02),
                    Text(
                      Strings.VIEW_MORE,
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: Constant.CONTAINER_SIZE_14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: Constant.CONTAINER_SIZE_12,
              mainAxisSpacing: Constant.CONTAINER_SIZE_12,
              childAspectRatio: 1.25,
              children: [
                _Summary(
                  Strings.ORDERED,
                  "${inventory?.orderedCount ?? 0}",
                  true,
                ),
                _Summary(
                  Strings.ISSUED_PARTNER,
                  "${inventory?.issuedToPartnerCount ?? 0}",
                  true,
                ),
                _Summary(
                  Strings.IN_CIRCULATION,
                  "${inventory?.inCirculationCount ?? 0}",
                  true,
                ),
                _Summary(
                  Strings.WITH_PARTNER,
                  "${inventory?.withPartnerCount ?? 0}",
                  true,
                ),
                _Summary(Strings.SOLD, "${inventory?.soldCount ?? 0}", true),
                _Summary(
                  Strings.DAMAGED,
                  "${inventory?.damagedCount ?? 0}",
                  true,
                ),
                _Summary(
                  Strings.IN_STOCK,
                  "${inventory?.inStockCount ?? 0}",
                  true,
                ),
                _Summary(
                  Strings.RETURNED,
                  "${inventory?.returnedCount ?? 0}",
                  true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final String title;
  final String value;
  final bool arrow;

  const _Summary(this.title, this.value, this.arrow);

  @override
  Widget build(BuildContext context) {
    const gold = Constant.gold2;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_14,
                  ),
                ),
              ),
              if (arrow)
                CircleAvatar(
                  radius: Constant.CONTAINER_SIZE_20,
                  backgroundColor: gold,
                  child: Padding(
                    padding: EdgeInsets.all(Constant.SIZE_03),
                    child: Image.asset(
                      Strings.CORNER_ARROW,
                      width: Constant.CONTAINER_SIZE_28,
                      height: Constant.CONTAINER_SIZE_28,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _getInventoryDetailsNetworkCall(WidgetRef ref) async {
  try {
    await ref.read(networkProvider.notifier).isNetworkAvailable().then((
      isNetworkAvailable,
    ) {
      Utils.printLog("isNetworkAvailable::$isNetworkAvailable");

      final orderState = ref.read(orderProvider);

      if (isNetworkAvailable) {
        orderState.setIsLoading(true);
        final url = '${NetworkUrls.INVENTORY_DETAILS}';

        ref.read(getInventoryDetailProvider(url));
      } else {
        orderState.setIsLoading(false);
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      }
    });
  } catch (e) {
    Utils.printLog('Error: $e');
  }
}
