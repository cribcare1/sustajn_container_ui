import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class BusinessInformationScreen extends StatelessWidget {
  const BusinessInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Constant.SIZE_15,
                vertical: Constant.SIZE_10,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: Constant.CONTAINER_SIZE_20,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: Constant.SIZE_05),
                  Text(
                    'Business Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.SIZE_15,
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      context,
                      hint: 'Specialty',
                    ),
                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      hint: 'Cuisine',
                    ),
                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      hint: 'Website',
                    ),
                    SizedBox(height: Constant.SIZE_18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: Constant.CONTAINER_SIZE_18,
                          color: Constant.gold,
                        ),
                        SizedBox(width: Constant.SIZE_06),
                        Text(
                          'Add Social Media',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_14,
                            color: Constant.gold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_70),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: Constant.SIZE_15,
                right: Constant.SIZE_15,
                bottom: mediaQuery.padding.bottom + Constant.SIZE_10,
              ),
              child: SizedBox(
                height: Constant.CONTAINER_SIZE_50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC8B531),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_15,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Save Changes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_15,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String hint}) {
    final theme = Theme.of(context);

    return TextField(
      maxLines: Constant.MAX_LINE_1,
      style: theme.textTheme.bodyMedium?.copyWith(
       color: Colors.white70
      ),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.primaryColor,
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          fontSize: Constant.LABEL_TEXT_SIZE_14,
          color: Colors.white70,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        enabledBorder: CustomTheme.roundedBorder(Constant.grey),
        focusedBorder: CustomTheme.roundedBorder(Constant.grey),
        isDense: true,
      ),
    );
  }
}
