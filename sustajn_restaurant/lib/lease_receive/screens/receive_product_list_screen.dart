import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/lease_receive/screens/receive_scan_screen.dart';
import 'package:sustajn_restaurant/utils/global_utils.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../lease_receive_notifier.dart';
import '../lease_receive_provider.dart';
import '../model/container_return_list_model.dart';

class ReceiveProductListScreen extends ConsumerStatefulWidget {
  final String type;
  final String? damage;
  final String customerId;

  const ReceiveProductListScreen({
    super.key,
    required this.type,
    this.damage,
    required this.customerId,
  });

  @override
  ConsumerState<ReceiveProductListScreen> createState() =>
      _ReceiveProductListScreenState();
}

class _ReceiveProductListScreenState
    extends ConsumerState<ReceiveProductListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaseReceiveNotifier).containerReturnList.clear();
      ref.read(leaseReceiveNotifier).containerReturnListAdded.clear();
      ref.read(leaseReceiveNotifier).setContext(context);
      _getContainerList(
        customerId: widget.customerId,
      );
    });

    super.initState();
  }

  _getContainerList(
     {
    required String customerId,
  }) async {
    final leasState = ref.read(leaseReceiveNotifier);
    try {
      leasState.setLoading(true);
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            ref.read(returnContainerListProvider(customerId));
          } else {
            leasState.setLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          leasState.setLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      leasState.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaseNotifier = ref.watch(leaseReceiveNotifier);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Receive product",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: leaseNotifier.isLoading
            ? const Center(child: CircularProgressIndicator())
            : leaseNotifier.containerReturnList.isEmpty
            ? Center(
                child: Text(
                  "There are no return containers available for this user.",
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.badge, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Customer ID: ${widget.customerId}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/img.png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(width: Constant.SIZE_08),
                                Text(
                                  leaseNotifier.containerCount
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_20),
                          Text(
                            "Available Containers",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_16,
                      ),
                      itemCount: leaseNotifier.containerReturnList.length,
                      itemBuilder: (context, index) {
                        return _containerCard(
                          item: leaseNotifier.containerReturnList[index],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: Constant.CONTAINER_SIZE_10),
                    ),
                  ),
                  // SizedBox(height: Constant.LABEL_TEXT_SIZE_20),
                  // (leaseNotifier.containerReturnList.isEmpty)
                  //     ? const SizedBox()
                  //     : leaseNotifier.isSaving
                  //     ? Center(child: CircularProgressIndicator())
                  //     : SizedBox(
                  //         width: MediaQuery.sizeOf(context).width * 0.6,
                  //         child: SubmitButton(
                  //           onRightTap: () {
                  //             showConfirmIssuePopup(context, leaseNotifier);
                  //           },
                  //           rightText: "Confirm Receive",
                  //         ),
                  //       ),
                  SizedBox(height: Constant.CONTAINER_SIZE_40),
                ],
              ),
        floatingActionButton: InkWell(
          onTap: () {
            NavUtil.navigateToPushScreen(
              context,
              ReceiveScanScreen(type: widget.type, previous: "list"),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
              color: Theme.of(context).secondaryHeaderColor,
            ),
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerCard({required ProductOrderListResponseList item}) {
    return GlassSummaryCard(
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.network(
              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.productImageUrl}",
              errorBuilder: (context, obj, stack) {
                return Image.asset("assets/images/no_image_container.png");
              },
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.productUniqueId,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${item.containerQuantity}ml",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.quantity.toString(),
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showConfirmIssuePopup(
    BuildContext context,
    LeaseReceiveNotifier leaseState,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      isDismissible: false,
      useSafeArea: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            left: Constant.CONTAINER_SIZE_16,
            right: Constant.CONTAINER_SIZE_16,
            top: Constant.CONTAINER_SIZE_16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD4AF37),
                  size: 32,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              const Text(
                'Confirm receive Containers?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                'Have you received the containers from the user?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              leaseState.isSaving
                  ? Center(child: CircularProgressIndicator())
                  : SubmitClearButton(
                      onLeftTap: () {
                        Navigator.pop(context);
                      },
                      leftText: "Cancel",
                      onRightTap: () {
                        Navigator.pop(context);
                        final List<Map<String, dynamic>> items = leaseState
                            .containerReturnListAdded
                            .map(
                              (i) => {
                                "productId": i.productId,
                                "quantity": i.containerCount,
                              },
                            )
                            .toList();

                        Map<String, dynamic> data = {
                          "userId": leaseState.customerUserId,
                          "restaurantId": Utils.userId,
                          "items": items,
                        };
                        _leaseContainer(leaseState, data);
                      },
                      rightText: "Confirm",
                    ),
            ],
          ),
        );
      },
    );
  }

  _leaseContainer(
    LeaseReceiveNotifier leasState,
    Map<String, dynamic> body,
  ) async {
    try {
      print("API calll");
      leasState.setIsSaving(true);
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          print("isNetworkAvailable :- $isNetworkAvailable");
          if (isNetworkAvailable) {
            ref.read(receiveContainer(body).future);
          } else {
            leasState.setIsSaving(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          leasState.setIsSaving(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      leasState.setIsSaving(false);
    }
  }
}
