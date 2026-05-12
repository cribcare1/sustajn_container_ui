import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/utils/qr_crypto_helper.dart';

import '../../common_widgets/submit_button.dart';
import '../../common_widgets/submit_clear_button.dart';
import '../../constants/network_urls.dart';
import '../../network_provider/network_provider.dart';
import '../../utils/utility.dart';
import '../lease_receive_notifier.dart';
import '../lease_receive_provider.dart';
import '../model/container_return_list_model.dart';

class ReceiveScanScreen extends ConsumerStatefulWidget {
  final String type;
  final String? damage;
  final String? previous;

  const ReceiveScanScreen({
    super.key,
    required this.type,
    this.damage,
    this.previous,
  });

  @override
  ConsumerState<ReceiveScanScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<ReceiveScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // ensures single scan
    torchEnabled: false,
    autoZoom: true,
  );
  bool _isScanned = false;
  String? scannedValue;
  bool _torchOn = false;
  final textController = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final leaseNotifier = ref.read(leaseReceiveNotifier);
    if (_isScanned) return;
    final Barcode? barcode = capture.barcodes.firstWhere(
      (b) => b.rawValue != null && b.rawValue!.isNotEmpty,
      orElse: () => Barcode(
        rawValue: null,
        displayValue: null,
        format: BarcodeFormat.unknown,
      ),
    );
    if (barcode?.rawValue == null || barcode!.rawValue!.isEmpty) return;
    final encryptedValue = barcode.rawValue!;
    if (!QrCryptoHelper.isBase64(encryptedValue)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Strings.INVALID_QR_CODE),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final decrypted = QrCryptoHelper.decrypt(encryptedValue);
      if (mounted) {
        setState(() {
          _isScanned = true;
          scannedValue = decrypted;
          textController.text = scannedValue!;
        });
      }
      _handleContainerId(decrypted);
      await Future.delayed(const Duration(milliseconds: 300));
      await controller.stop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.INVALID_QR_CODE),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleFlash() async {
    await controller.toggleTorch();
    setState(() {
      _torchOn = !_torchOn;
    });
  }


  void _handleContainerId(String id) {
    final leaseNotifier = ref.read(leaseReceiveNotifier);
    final matchedList = leaseNotifier.containerReturnList
        .where((e) => e.productUniqueId == id)
        .toList();
    if (matchedList.isEmpty) {
      showCustomSnackBar(
        context: context,
        message: "No container available to return",
        color: Colors.red,
      );
      return;
    }

    final maxLimit =
        leaseNotifier.totalCount[id] ?? 0;
    leaseNotifier.setCustomerUserId(matchedList.first.userId);
    final index = leaseNotifier.containerReturnListAdded
        .indexWhere((e) => e.productUniqueId == id);

    if (index != -1) {
      final item = leaseNotifier.containerReturnListAdded[index];

      if (item.containerCount >= maxLimit) {
        showCustomSnackBar(
          context: context,
          message: "Maximum limit reached ($maxLimit)",
          color: Colors.red,
        );
        return;
      }
      item.containerCount += 1;
      showCustomSnackBar(
        context: context,
        message:
        "Added: ${item.containerCount}/$maxLimit",
        color: Colors.white,
      );

      return;
    }
    final newItem = matchedList.first;
    newItem.containerCount = 1;
    leaseNotifier.setContainerReturnList(newItem);
    showCustomSnackBar(
      context: context,
      message: "Added: 1/$maxLimit",
      color: Colors.white,
    );
  }

  Future<void> _scanAgain() async {
    setState(() {
      scannedValue = null;
      textController.clear();
      _isScanned = false;
    });
    await controller.start();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaseReceiveNotifier).setContext(context);
      ref.read(leaseReceiveNotifier).containerReturnListAdded.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final leaseNotifier = ref.watch(leaseReceiveNotifier);

    return SafeArea(
      bottom: true,
      top: false,

      child: Scaffold(
        appBar: CustomAppBar(
          title: Strings.SCAN_RECEIVE_QR,

          leading: CustomBackButton(),

          action: [
            IconButton(
              onPressed: _toggleFlash,

              icon: Icon(
                _torchOn ? Icons.flash_on : Icons.flash_off,

                color: Colors.white,
              ),
            ),
          ],
        ).getAppBar(context),

        body: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_20,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      SizedBox(
                        height: Constant.CONTAINER_SIZE_200,

                        width: Constant.CONTAINER_SIZE_200,

                        child: GlassSummaryCard(
                          child: MobileScanner(
                            controller: controller,

                            onDetect: _onDetect,

                            fit: BoxFit.fill,

                            tapToFocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),

                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.amber, thickness: 1.2),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.SIZE_08,
                      ),

                      child: Text(
                        Strings.OR,

                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(color: Colors.amber, thickness: 1.2),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),

                TextField(
                  autofocus: false,

                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.white),

                  controller: textController,

                  onChanged: (_) {
                    setState(() {});
                  },

                  decoration: InputDecoration(
                    hintText: Strings.ENTER_CONTAINER_ID,

                    hintStyle: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.grey),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_10,
                      ),

                      borderSide: const BorderSide(color: Colors.white),
                    ),

                    filled: true,

                    fillColor: Theme.of(context).primaryColor,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: textController.text.isEmpty
                        ? null
                        : () {
                            _handleContainerId(textController.text.trim());
                            },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: textController.text.isEmpty
                          ? Colors.grey.shade300
                          : Theme.of(context).secondaryHeaderColor,

                      foregroundColor: Colors.black,

                      disabledBackgroundColor: Colors.grey.shade300,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_12,
                        ),

                        side: const BorderSide(color: Colors.white),
                      ),
                    ),

                    child: Text(
                      Strings.VERIFY,

                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: textController.text.isEmpty
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
                /// LIST
                (leaseNotifier.containerReturnListAdded.isEmpty)
                    ? const SizedBox()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            leaseNotifier.containerReturnListAdded.length,
                        itemBuilder: (context, index) {
                          return _containerCard(
                            item: leaseNotifier.containerReturnListAdded[index],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: Constant.CONTAINER_SIZE_10),
                      ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                (leaseNotifier.containerReturnListAdded.isEmpty)
                    ? const SizedBox()
                    : leaseNotifier.isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        child: SubmitButton(
                          onRightTap: () {
                            showConfirmIssuePopup(context, leaseNotifier);
                          },
                          rightText: "Confirm Receive",
                        ),
                      ),
                SizedBox(height: Constant.CONTAINER_SIZE_30),
              ],
            ),
          ),
        ),

        floatingActionButton: InkWell(
          onTap: () => _scanAgain(),

          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Theme.of(context).secondaryHeaderColor,
            ),

            padding: EdgeInsetsGeometry.all(Constant.CONTAINER_SIZE_10),

            child: Icon(
              Icons.flip_camera_android,

              size: Constant.CONTAINER_SIZE_20,
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
              errorBuilder: (c, o, s) =>
                  Image.asset("assets/images/no_image_container.png"),
              fit: BoxFit.fill,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.productUniqueId,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${item.containerQuantity} ml",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              InkWell(
                onTap: () {

                  final list = ref
                      .read(leaseReceiveNotifier)
                      .containerReturnListAdded;

                  final currentTotal = list
                      .where((e) =>
                  e.productUniqueId ==
                      item.productUniqueId)
                      .fold<int>(
                      0,
                          (sum, e) =>
                      sum + e.containerCount);

                  if (currentTotal <= 1) {
                    showCustomSnackBar(
                      context: context,
                      message: "Minimum is 1",
                      color: Colors.red,
                    );
                    return;
                  }

                  setState(() {
                    for (var e in list) {
                      if (e.productUniqueId ==
                          item.productUniqueId) {
                        e.containerCount--;
                      }
                    }
                  });
                },
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                ),
              ),
              Text(
                " ${item.containerCount} ",
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {

                  final list = ref
                      .read(leaseReceiveNotifier)
                      .containerReturnListAdded;

                  final maxLimit = ref
                      .read(leaseReceiveNotifier)
                      .totalCount[item.productUniqueId] ??
                      0;

                  final currentTotal = list
                      .where((e) =>
                  e.productUniqueId == item.productUniqueId)
                      .fold<int>(
                      0,
                          (sum, e) =>
                      sum + e.containerCount);

                  if (currentTotal >= maxLimit) {
                    showCustomSnackBar(
                      context: context,
                      message:
                      "Max limit reached ($maxLimit)",
                      color: Colors.red,
                    );
                    return;
                  }

                  setState(() {
                    for (var e in list) {
                      if (e.productUniqueId ==
                          item.productUniqueId) {
                        e.containerCount++;
                      }
                    }
                  });
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
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
