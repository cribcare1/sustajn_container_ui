import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Constant.SIZE_15),
                child: Column(
                  children: [
                    _buildTextField(
                      context,
                      label: Strings.CONTACT_PERSON,
                      hint: Strings.CONTACT_PERSON,
                    ),
                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      label: Strings.MOBILE_NUMBER,
                      hint: Strings.MOBILE_NUMBER,
                    ),
                    SizedBox(height: Constant.SIZE_10),
                    _buildTextField(
                      context,
                      label: Strings.EMAIL_REGISTRATION,
                      hint: Strings.EMAIL_REGISTRATION,
                    ),
                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      label: Strings.TRADE_LICENSE_NUMBER,
                      hint: Strings.TRADE_LICENSE_NUMBER,
                    ),
                    SizedBox(height: Constant.SIZE_10),
                    _buildTextField(
                      context,
                      label: Strings.TAX_NUMBER,
                      hint: Strings.TAX_NUMBER,
                    ),
                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      label: "Type of Business",
                      hint: "Type of Business",
                    ),
                    SizedBox(height: Constant.SIZE_10),
                    _buildTextField(
                      context,
                      label: Strings.WEBSITE,
                      hint: Strings.WEBSITE,
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
                          Strings.ADD_SOCIAL_MEDIA,
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
                    Strings.SAVE_CHANGES,
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

  Widget _buildTextField(
    BuildContext context, {
    required String hint,
    required String label,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: Constant.SIZE_08),
          decoration: BoxDecoration(
            color: Color(0xFF1F4D3A),
            borderRadius: BorderRadius.circular(Constant.LABEL_TEXT_SIZE_14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.LABEL_TEXT_SIZE_14,
            ),
            cursorColor: Colors.white70,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white70),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white70,
                fontSize: Constant.CONTAINER_SIZE_13,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: Constant.LABEL_TEXT_SIZE_16,
                vertical: Constant.LABEL_TEXT_SIZE_14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.SIZE_08),
              ),
              enabledBorder: CustomTheme.roundedBorder(Constant.grey),
              focusedBorder: CustomTheme.roundedBorder(Constant.grey),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
