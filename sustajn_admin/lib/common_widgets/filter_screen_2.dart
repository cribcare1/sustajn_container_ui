import 'package:flutter/material.dart';
import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';

class ReusableFilterBottomSheet extends StatefulWidget {
  final String title;
  final String leftTabTitle;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onApply;

  const ReusableFilterBottomSheet({
    super.key,
    required this.title,
    required this.leftTabTitle,
    required this.options,
    required this.onApply,
    this.selectedValue,
  });

  @override
  State<ReusableFilterBottomSheet> createState() =>
      _ReusableFilterBottomSheetState();
}

class _ReusableFilterBottomSheetState
    extends State<ReusableFilterBottomSheet> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    final height = MediaQuery.of(context).size.height * 0.92;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      decoration: BoxDecoration(
        color: themeData!.secondaryHeaderColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constant.CONTAINER_SIZE_20),
          topRight: Radius.circular(Constant.CONTAINER_SIZE_20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: themeData.textTheme.titleLarge!.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Constant.SIZE_02),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeData.colorScheme.onSurface.withOpacity(0.06),
                    ),
                    child: Icon(
                      Icons.close,
                      size: Constant.CONTAINER_SIZE_25,
                      color: themeData.colorScheme.onSurface,
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),


            Expanded(
              child: Row(
                children: [

                  Container(
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: themeData.dividerColor.withOpacity(0.4),
                          width: Constant.SIZE_01,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.leftTabTitle,
                          style: themeData.textTheme.bodyLarge?.copyWith(
                            color: themeData.primaryColor,
                            fontSize: Constant.LABEL_TEXT_SIZE_18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                      ],
                    ),
                  ),


                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          widget.options.length,
                              (index) => RadioListTile(
                            value: widget.options[index],
                            activeColor: themeData.primaryColor,
                            groupValue: selectedOption,
                            onChanged: (val) {
                              setState(() {
                                selectedOption = val;
                              });
                            },
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              widget.options[index],
                              style: themeData.textTheme.bodyMedium?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_16,
                                color: themeData.colorScheme.onSurface,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),


            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => selectedOption = null);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.CONTAINER_SIZE_18,
                      ),
                      side: BorderSide(
                        color: themeData.primaryColor,
                        width: Constant.SIZE_01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                      ),
                    ),
                    child: Text(
                      "Clear",
                      style: themeData.textTheme.labelLarge?.copyWith(
                        color: themeData.primaryColor,
                        fontSize: Constant.LABEL_TEXT_SIZE_16,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: Constant.CONTAINER_SIZE_20),


                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(selectedOption);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.CONTAINER_SIZE_18,
                      ),
                      backgroundColor: Color(0xFFD9B649),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                      ),
                    ),
                    child: Text(
                      "Apply",
                      style: themeData.textTheme.labelLarge?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_16,
                        color: themeData.primaryColor,
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
}
