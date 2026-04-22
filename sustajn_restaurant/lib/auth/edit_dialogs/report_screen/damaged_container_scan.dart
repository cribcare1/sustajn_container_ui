import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/report_screen/demage_container_list.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../../common_widgets/card_widget.dart';
import '../../../common_widgets/submit_button.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import 'add_damage_container.dart';

class DamagedContainerScannerWidget extends StatefulWidget {
  final String? customer;

  const DamagedContainerScannerWidget({super.key, this.customer = ''});

  @override
  State<DamagedContainerScannerWidget> createState() =>
      _DamagedContainerScannerWidgetState();
}

class _DamagedContainerScannerWidgetState
    extends State<DamagedContainerScannerWidget> {
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
    return Scaffold(
      backgroundColor: Color(0xFF0F3727),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => NavUtil.popScreen(context, 2),
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_20,
                      ),
                      child: Container(
                        height: Constant.CONTAINER_SIZE_36,
                        width: Constant.CONTAINER_SIZE_36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.7),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: Constant.CONTAINER_SIZE_20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: Constant.CONTAINER_SIZE_36,
                    width: Constant.CONTAINER_SIZE_36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      onPressed: _toggleFlash,
                      icon: Icon(
                        _torchOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_40),

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

              SizedBox(height: Constant.CONTAINER_SIZE_24),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                  vertical: Constant.SIZE_06,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_10,
                  ),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  (widget.customer == 'customer')
                      ? 'Scan Customer QR'
                      : 'Scan damaged container',
                  style: TextStyle(
                    color: Color(0xFFE4C45A),
                    fontSize: Constant.CONTAINER_SIZE_14,
                  ),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_30),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Color(0xFFD1AE31), thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_12,
                    ),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: Constant.CONTAINER_SIZE_14,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFD1AE31))),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_24),
              (widget.customer == 'customer')
                  ? TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: "Enter Customer ID",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_14,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Constant.CONTAINER_SIZE_16,
                          vertical: Constant.SIZE_06,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_10,
                          ),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_14,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFFE4C45A),
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    )
                  : OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddDamagedContainerSheet(),
                        );
                      },
                      icon: const Icon(Icons.add, color: Color(0xFFE4C45A)),
                      label: Text(
                        'Add Damage Manually',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Constant.CONTAINER_SIZE_14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE4C45A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_14,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Constant.CONTAINER_SIZE_16,
                          vertical: Constant.SIZE_06,
                        ),
                      ),
                    ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),
              (widget.customer == 'customer')
                  ? SizedBox(
                      width: double.infinity,
                      child: SubmitButton(
                        onRightTap: () {
                          NavUtil.navigateToPushScreen(
                            context,
                            DamageContainerListScreen(
                              customerId: textController.text,
                              damage: widget.customer,
                            ),
                          );
                        },
                        rightText: Strings.VERIFY,
                      ),
                    )
                  : const SizedBox.shrink(),
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
    );
  }

  /// Scanner corner borders
  Widget _cornerBorder({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: Constant.CONTAINER_SIZE_26,
        height: Constant.CONTAINER_SIZE_26,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? BorderSide(color: Color(0xFFE4C45A), width: Constant.SIZE_04)
                : BorderSide.none,
            left: left != null
                ? BorderSide(color: Color(0xFFE4C45A), width: Constant.SIZE_04)
                : BorderSide.none,
            right: right != null
                ? BorderSide(color: Color(0xFFE4C45A), width: Constant.SIZE_04)
                : BorderSide.none,
            bottom: bottom != null
                ? BorderSide(color: Color(0xFFE4C45A), width: Constant.SIZE_04)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
