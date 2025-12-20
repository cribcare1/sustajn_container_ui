import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.transparent,
                  cutOutSize: w * 0.7,
                ),
              ),
            ),

            Container(
              color: Colors.black.withOpacity(0.9),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                height: w * 0.11,
                width: w * 0.11,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.black)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.06),
                Center(
                  child: Container(
                    height: w * 0.7,
                    width: w * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomPaint(
                      painter: QrCornerPainter(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Scan customer QR to barrow products.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.white.withOpacity(0.7),
                        endIndent: 8,
                      ),
                    ),
                    const Text("or",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.white.withOpacity(0.7),
                        indent: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter Customer ID",
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withOpacity(0.9),
                    border: const Border(top: BorderSide(color: Colors.white24)),
                  ),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      Navigator.pop(context, scanData.code); // return scanned value
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class QrCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    double corner = 50;

    // Top Left
    canvas.drawLine(const Offset(0, 0), Offset(corner, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, corner), paint);

    // Top Right
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width - corner, 0), paint);
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width, corner), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height),
        Offset(corner, size.height), paint);
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - corner), paint);

    // Bottom Right
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - corner, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - corner), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
