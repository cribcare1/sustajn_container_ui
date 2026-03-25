import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_provider/network_provider.dart';
import '../common_widgets/card_widget.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../container_list/model/container_list_model.dart';
import '../product_screen/containers_list_screen.dart';
import '../provider/order_provider.dart';
import '../utils/utility.dart';

class ContainersDetailsScreen extends ConsumerStatefulWidget {
  final InventoryData details;

  const ContainersDetailsScreen({super.key, required this.details});

  @override
  ConsumerState<ContainersDetailsScreen> createState() =>
      _ContainersDetailsScreenState();
}

class _ContainersDetailsScreenState
    extends ConsumerState<ContainersDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInventoryNetworkCall();
    });
    super.initState();
  }

  _getInventoryNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          ref.read(
            getContainerCount({
              "restaurantId": userId,
              "productId": widget.details.inventoryId ?? 0,
            }),
          );
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Container Details',
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: orderState.isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: ListView(
            children: [
              Center(child: _productCard(theme, context)),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              _statsList(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(ThemeData theme, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: Constant.CONTAINER_SIZE_250,
          width: Constant.CONTAINER_SIZE_210,
          child: SubscriptionCard(
            padding: 4.0,
            child: Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A4D2E), Color(0xFF052F1E)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: Constant.CONTAINER_SIZE_100,
                    width: Constant.CONTAINER_SIZE_100,
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                    ),
                    child: Image.network(
                      "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${widget.details.imageUrl}",
                      errorBuilder: (context, obj, stack) {
                        return Image.asset(
                          "assets/images/no_image_container.png",
                        );
                      },
                      fit: BoxFit.fill,
                    ),
                  ),

                  SizedBox(height: Constant.SIZE_10),

                  Text(
                    widget.details.containerName ?? "",
                    maxLines: Constant.MAX_LINE_1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    widget.details.productId ?? "",
                    maxLines: Constant.MAX_LINE_1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_02),
                  Text(
                    "${widget.details.capacityMl}ml",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statsList(ThemeData theme) {
    final orderState = ref.read(orderProvider);
    final stats = [
      {
        "title": "Leased",
        "value": "${orderState.leasedContainerCount}",
        "arrow": true,
      },
      {
        "title": "Received",
        "value": "${orderState.returnedContainerCount}",
        "arrow": true,
      },
      {
        "title": "In-Stock",
        "value": "${widget.details.availableContainers}",
        "arrow": false,
      },
    ];

    return ListView.separated(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final title = stats[index]["title"] as String;
        return _statCard(
          theme,
          title: stats[index]["title"] as String,
          value: stats[index]["value"] as String,
          showArrow: stats[index]["arrow"] as bool,
          onTap: () {
            if (title == 'Leased') {
              _navigateTotalLeased(context);
            } else if (title == 'Received') {
              _navigateTotalReceived(context);
            }
          },
        );
      },
      separatorBuilder: (context, index) =>
          SizedBox(height: Constant.CONTAINER_SIZE_10),
    );
  }


  void _navigateTotalLeased(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignedContainerListScreen(
          title: "Total Leased", type: 'LEASED', productId: widget.details.inventoryId!,
        ),
      ),
    );
  }

  void _navigateTotalReceived(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignedContainerListScreen(
          title: "Total Received", type: 'RETURNED', productId: widget.details.inventoryId!,
        ),
      ),
    );
  }

  Widget _statCard(
      ThemeData theme, {
        required String title,
        required String value,
        required bool showArrow,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: GlassSummaryCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: Constant.MAX_LINE_2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_06),
                  Text(
                    value,
                    maxLines: Constant.MAX_LINE_1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if (showArrow) ...[
              SizedBox(width: Constant.SIZE_08),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.secondaryHeaderColor,
                ),
                padding: EdgeInsets.all(Constant.SIZE_04),
                child: Icon(
                  Icons.call_made_outlined,
                  size: Constant.CONTAINER_SIZE_16,
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
