import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../../common_widgets/submit_button.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';

class DamagedContainerScannerWidget extends StatefulWidget {
  final String? customer;

  const DamagedContainerScannerWidget({super.key, this.customer = ''});

  @override
  State<DamagedContainerScannerWidget> createState() =>
      _DamagedContainerScannerWidgetState();
}

class _DamagedContainerScannerWidgetState
    extends State<DamagedContainerScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F3727),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_20),
          child: Column(
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

              SizedBox(height: Constant.CONTAINER_SIZE_40),

              Center(
                child: Container(
                  height: Constant.CONTAINER_SIZE_220,
                  width: Constant.CONTAINER_SIZE_220,
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_20,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_16,
                    ),
                    child: Stack(
                      children: [
                        _cornerBorder(top: 0, left: 0),
                        _cornerBorder(top: 0, right: 0),
                        _cornerBorder(bottom: 0, left: 0),
                        _cornerBorder(bottom: 0, right: 0),
                      ],
                    ),
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
                        // Navigate to manual damage screen
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

              SizedBox(height: Constant.CONTAINER_SIZE_150),
              (widget.customer == 'customer')
                  ? SizedBox(
                      width: double.infinity,
                      child: SubmitButton(
                        onRightTap: () {},
                        rightText: Strings.VERIFY,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
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
