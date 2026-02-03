import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class LinkPaymentBottomSheet extends StatefulWidget {
  final String title;
  final String hint;
  final VoidCallback onSubmit;

  const LinkPaymentBottomSheet({
    super.key,
    required this.title,
    required this.hint,
    required this.onSubmit,
  });

  @override
  State<LinkPaymentBottomSheet> createState() =>
      _LinkPaymentBottomSheetState();
}

class _LinkPaymentBottomSheetState
    extends State<LinkPaymentBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_24),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: Constant.CONTAINER_SIZE_20,
              right: Constant.CONTAINER_SIZE_20,
              top: Constant.CONTAINER_SIZE_20,
              bottom:
              MediaQuery.of(context).viewInsets.bottom +
                  Constant.CONTAINER_SIZE_20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: Constant.CONTAINER_SIZE_24,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                TextField(
                  controller: _controller,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color:Colors.white,
                    ),
                    filled: true,
                    fillColor: Constant.grey.withOpacity(.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                    ),
                    enabledBorder: CustomTheme.roundedBorder(
                      Constant.grey.withOpacity(0.3),
                    ),
                    focusedBorder: CustomTheme.roundedBorder(
                      Constant.grey.withOpacity(0.3),
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                SizedBox(
                  width: double.infinity,
                  height: Constant.CONTAINER_SIZE_48,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSubmit();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_14,
                        ),
                      ),
                    ),
                    child: Text(
                      "Add & Continue",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_10),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
