import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/shared_preference_utils.dart';

class QrDialog extends StatelessWidget {
  QrDialog({Key? key}) : super(key: key);

  final GlobalKey _qrKey = GlobalKey();

  Future<int?> _getUserId() async {
    return await SharedPreferenceUtils.getIntValuesSF(Strings.USER_ID);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: FutureBuilder<int?>(
        future: _getUserId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data == -1) {
            return _errorView(theme);
          }

          final userId = snapshot.data.toString();

          return Container(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.MY_QR_CODE,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
              
                  SizedBox(height: Constant.CONTAINER_SIZE_24),
              
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        Constant.CONTAINER_SIZE_10,
                        Constant.CONTAINER_SIZE_10,
                        Constant.CONTAINER_SIZE_10,
                        Constant.CONTAINER_SIZE_24,
                      ),
                      decoration: BoxDecoration(
                        color: Constant.gold,
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  Constant.CONTAINER_SIZE_12),
                            ),
                            child: QrImageView(
                              data: userId,
                              size: Constant.CONTAINER_SIZE_200,
                              backgroundColor: Colors.white,
                            ),
                          ),
              
                          // SizedBox(height: Constant.CONTAINER_SIZE_12),
                          //
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       userId,
                          //       style: theme.textTheme.bodyMedium?.copyWith(
                          //         fontWeight: FontWeight.w600,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //     SizedBox(width: Constant.CONTAINER_SIZE_8),
                          //      Icon(
                          //       Icons.copy,
                          //       size: Constant.CONTAINER_SIZE_16,
                          //       color: Colors.black,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
              
                  SizedBox(height: Constant.CONTAINER_SIZE_20),
              
                  InkWell(
                    onTap: () => _shareQrImage(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.share, color: Colors.white, size: Constant.CONTAINER_SIZE_18),
                        SizedBox(width: Constant.CONTAINER_SIZE_8),
                        Text(
                          "Share QR",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareQrImage() async {
    try {
      RenderRepaintBoundary boundary =
      _qrKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/qr_code.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My QR Code',
      );
    } catch (e) {
      debugPrint("QR Share Error: $e");
    }
  }

  Widget _errorView(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      ),
      child: const Text(
        "User ID not found",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
