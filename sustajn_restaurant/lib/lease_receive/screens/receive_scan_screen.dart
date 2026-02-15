import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/utils/qr_crypto_helper.dart';

import '../../utils/utility.dart';
import '../lease_receive_notifier.dart';
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
      if(!mounted) return;
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
    final matchedContainer = leaseNotifier.containerReturnList.firstWhere(
          (e) => e.productUniqueId == id,
      orElse: () => ProductOrderListResponseList(
      productId: 0, productName: '', containerCount: 0, productImageUrl: '', productUniqueId: '', containerQuantity: 0,
      ),
    );
    final alreadyAdded = leaseNotifier.containersList.any(
          (e) => e.containerUniqueId == id,
    );

    if (alreadyAdded) {
      final container = leaseNotifier.containersList.firstWhere(
            (e) => e.containerUniqueId == id,
      );

      container.quantity += 1;
    }
    leaseNotifier.setContainerReturnList(matchedContainer);
    leaseNotifier.setCustomerUserId(leaseNotifier.containerReturnList[0].userId!);
    showCustomSnackBar(
      context: context,
      message: "Container added. Total: ${leaseNotifier.containersList.length}",
      color: Colors.green,
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Strings.SCAN,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: Constant.CONTAINER_SIZE_300,
                        width: Constant.CONTAINER_SIZE_300,
                        child: GlassSummaryCard(
                          child: MobileScanner(
                            controller: controller,
                            onDetect: _onDetect,
                            fit: BoxFit.fill,
                            tapToFocus: true,
                          ),
                        ),
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_16),
                      SizedBox(
                        width: Constant.CONTAINER_SIZE_300,
                        child: GlassSummaryCard(
                          child: Text(
                            Strings.SCAN_FOR_RECEIVE,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
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
                      child: Divider(
                        color: Colors.amber, // line color
                        thickness: 1.2,
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Constant.SIZE_08),
                      child: Text(
                        Strings.OR,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.amber, // line color
                        thickness: 1.2,
                      ),
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
                  decoration: InputDecoration(
                    hintText: Strings.ENTER_CONTAINER_ID,
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
                      borderSide: BorderSide(color: Colors.white),
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
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textController.text.isEmpty
                          ? Colors.grey.shade300
                          : Theme.of(context).secondaryHeaderColor,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                        side: BorderSide(color: Colors.white),
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
            child: Icon(Icons.flip_camera_android, size: Constant.CONTAINER_SIZE_20),
          ),
        ),
      ),
    );
  }
}
