import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/lease_receive/screens/receive_product_list_screen.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../utils/global_utils.dart';
import 'lease_product_scan_screen.dart';

class LeaseScanScreen extends StatefulWidget {
  final String type;
  final String? damage;
  final String customerId;

  const LeaseScanScreen({super.key, required this.type, this.damage, required this.customerId});

  @override
  State<LeaseScanScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<LeaseScanScreen> {
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
    if (_isScanned) return;

    final Barcode? barcode = capture.barcodes.firstWhere(
      (b) => b.rawValue != null && b.rawValue!.isNotEmpty,
      orElse: () => Barcode(
        rawValue: null,
        displayValue: null,
        format: BarcodeFormat.unknown,
      ),
    );

    if (barcode!.rawValue != null && barcode.rawValue!.isNotEmpty) {
      final value = barcode.rawValue!;
      if (mounted) {
        setState(() {
          _isScanned = true;
          scannedValue = value;
          textController.text = scannedValue!;
        });
      }
      await Future.delayed(const Duration(milliseconds: 300));
      await controller.stop();
    }
  }


  Future<void> _toggleFlash() async {
    await controller.toggleTorch();
    setState(() {
      _torchOn = !_torchOn;
    });
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
                            widget.type.contains(Strings.LEASE_UC)
                                ? Strings.SCAN_FOR_LEASE
                                : Strings.SCAN_FOR_RECEIVE,
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
                    hintText: Strings.ENTER_CUSTOMER_ID,
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
                      scannedId = textController.text;
                            if (widget.type.contains(Strings.LEASE_UC)) {
                              NavUtil.navigateToPushScreen(
                                context,
                                LeaseProductScanScreen(
                                  type: widget.type,
                                  damage: widget.damage,
                                  customerId: widget.customerId,
                                ),
                              );
                            } else if (widget.type.contains(Strings.RECEIVE_UC)) {
                              NavUtil.navigateToPushScreen(
                                context,
                                ReceiveProductListScreen(
                                  type: widget.type,
                                  damage: widget.damage,
                                  customerId: widget.customerId,
                                ),
                              );
                            }
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
