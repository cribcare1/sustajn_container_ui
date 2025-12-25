import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // ensures single scan
    torchEnabled: false,
    autoZoom: true,
  );

  bool _isScanned = false;
  String? scannedValue;
  bool _torchOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return;

    final Barcode? barcode = capture.barcodes.firstWhere(
          (b) => b.rawValue != null && b.rawValue!.isNotEmpty,
      orElse: () => Barcode(rawValue: null, displayValue: null, format: BarcodeFormat.unknown),
    );

    if (barcode!.rawValue != null && barcode.rawValue!.isNotEmpty) {
      final value = barcode.rawValue!;
      print("✅ QR Code Detected: $value");

      // update UI first before stopping camera
      if (mounted) {
        setState(() {
          _isScanned = true;
          scannedValue = value;
        });
      }

      // Give UI a chance to rebuild before stopping
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
      _isScanned = false;
    });
    await controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}
            , icon: Icon(Icons.arrow_back,color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _torchOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: !_isScanned
              ? SizedBox(
            key: const ValueKey("scanner"),
            height: 400,
            width: 400,
            child: MobileScanner(
              controller: controller,
              onDetect: _onDetect,
            ),
          )
              : Column(
            key: const ValueKey("result"),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "QR Code Scanned Successfully!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SelectableText(
                  scannedValue ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _scanAgain,
                child: const Text(
                  "Scan Again",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => controller.switchCamera(),
        child: const Icon(Icons.flip_camera_android,color: Colors.white,),
      ),
    );
  }
}