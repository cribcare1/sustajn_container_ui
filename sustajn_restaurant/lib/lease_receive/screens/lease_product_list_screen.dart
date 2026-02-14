import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/utils/global_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../lease_receive_notifier.dart';
import '../lease_receive_provider.dart';
import '../model/container_list_model.dart';

class LeaseProductListScreen extends ConsumerStatefulWidget {
  final String customerId;
  const LeaseProductListScreen({super.key, required this.customerId});

  @override
  ConsumerState<LeaseProductListScreen> createState() =>
      _LeaseProductListScreenState();
}

class _LeaseProductListScreenState
    extends ConsumerState<LeaseProductListScreen> {
  @override
  void initState() {
    Utils.getUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaseReceiveNotifier).setContext(context);
      _getContainerList(
        ref.read(leaseReceiveNotifier),
        restaurantId: Utils.userId.toString(),
      );
    });

    super.initState();
  }

  _getContainerList(
    LeaseReceiveNotifier leasState, {
    required String restaurantId,
  }) async {
    try {
      leasState.setLoading(true);
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            ref.read(containerListProvider(restaurantId));
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
    print("Containers count: ${leaseNotifier.containersList.length}");

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Assigned Containers",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: leaseNotifier.isLoading
            ? const Center(child: CircularProgressIndicator())
            : leaseNotifier.containersList.isEmpty
            ? Center(
                child: Text(
                  "No Containers found",
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
                                leaseNotifier.containersList.length
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
                          "Containers",
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
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: leaseNotifier.containersList.length,
                      itemBuilder: (context, index) {
                        return _containerCard(
                          item: leaseNotifier.containersList[index],
                          onRemove: () {
                            setState(() {
                              leaseNotifier.containersList.removeAt(index);
                            });
                          },
                          leaseNotifier: leaseNotifier
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: Constant.CONTAINER_SIZE_10),
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_100,)
                ],
              ),
        bottomSheet: Container(
          width: double.infinity,
          color: theme.primaryColor,
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: leaseNotifier.containersList.isEmpty
              ? SizedBox.shrink()
              : leaseNotifier.isSaving
              ? Center(child: CircularProgressIndicator())
              : SubmitButton(
                  onRightTap: () {
                    showConfirmIssuePopup(context, leaseNotifier);
                  },
                  rightText: "Issue Container",
                ),
        ),
      ),
    );
  }

  Widget _containerCard({
    required ContainerDetails item,
    required VoidCallback onRemove,
    var leaseNotifier
  }) {
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
              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.containerImageUrl}",
              errorBuilder: (context, obj, stack){
                return Image.asset("assets/images/cups.png");
              },
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.containerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  " ${item.containerUniqueId}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),

                Text(
                  "${item.capacity} ml",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
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
                item.quantityAvailable.toString(),
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
                'Confirm issue Containers?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                'You are about to issue the assigned containers to this '
                'customer. Once issued, the containers will be added '
                'to the customer’s active borrowing list.',
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
                            .containersList
                            .where((i) => i.containerId != 0)
                            .map(
                              (i) => {
                            "productId": i.containerId,
                            "quantity": 1,
                          },
                        )
                            .toList();


                        Map<String, dynamic> data = {
                          "userId": widget.customerId,
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
            ref.read(leaseContainer(body).future);
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
