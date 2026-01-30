import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';

import '../../constants/number_constants.dart';
import '../../provider/profile_provider.dart';

class EditReferPartnerDialog extends ConsumerStatefulWidget {
  const EditReferPartnerDialog({super.key});

  @override
  ConsumerState<EditReferPartnerDialog> createState() =>
      _EditReferPartnerDialogState();
}

class _EditReferPartnerDialogState
    extends ConsumerState<EditReferPartnerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _restaurantNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _contactNumberController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _restaurantNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _contactNumberController = TextEditingController();
    _emailController = TextEditingController();
    _getData();
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateRestaurantName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter restaurant name';
    }
    return null;
  }

  String? _validateContactPerson(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter contact person name';
    }
    return null;
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter contact number';
    }
    if (value.length != 10) {
      return 'Contact number must be 10 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter email address';
    }
    final email = value.trim();

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  _getData() {
    final profileState = ref.read(profileProvider);
    final profile = profileState.getProfileData?.data;
    if (profile!.bankDetailsResponse != null) {
      final bank = profile.bankDetailsResponse;
      _restaurantNameController.text = bank!.bankName ?? "";
      _contactPersonController.text = bank.accountNumber ?? "";
      _contactNumberController.text = bank.taxNumber ?? "";
      _emailController.text = bank.emailId ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.CONTAINER_SIZE_16),
              topRight: Radius.circular(Constant.CONTAINER_SIZE_16),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Strings.REFER_PARTNER,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_20,
                      ),
                      child: Icon(
                        Icons.close,
                        size: Constant.CONTAINER_SIZE_20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                _buildTextField(
                  context,
                  label: "${Strings.RESTAURANT_NAME}*",
                  hint: "${Strings.RESTAURANT_NAME}*",
                  keyboardType: TextInputType.text,
                  controller: _restaurantNameController,
                  validator: _validateRestaurantName,
                ),

                SizedBox(height: Constant.SIZE_10),

                _buildTextField(
                  context,
                  label: "${Strings.CONTACT_PERSON}*",
                  hint: "${Strings.CONTACT_PERSON}*",
                  keyboardType: TextInputType.text,
                  controller: _contactPersonController,
                  validator: _validateContactPerson,
                ),

                SizedBox(height: Constant.SIZE_10),

                _buildTextField(
                  context,
                  label: "${Strings.CONTACT_NUMBER}*",
                  hint: "${Strings.CONTACT_NUMBER}*",
                  keyboardType: TextInputType.number,
                  controller: _contactNumberController,
                  validator: _validateContactNumber,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: Constant.SIZE_10),

                _buildTextField(
                  context,
                  label: "${Strings.EMAIL}*",
                  hint: "${Strings.EMAIL}*",
                  keyboardType: TextInputType.text,
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_24),
                SizedBox(
                  width: double.infinity,
                  child: SubmitButton(
                    onRightTap: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    rightText: Strings.SAVE_CHANGES,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
        required String hint,
        required String label,
        TextInputType keyboardType = TextInputType.text,
        TextEditingController? controller,
        String? Function(String?)? validator,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: Colors.white,
        fontSize: Constant.LABEL_TEXT_SIZE_14,
      ),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white70,
          fontSize: Constant.CONTAINER_SIZE_13,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Constant.CONTAINER_SIZE_16,
          vertical: Constant.CONTAINER_SIZE_14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey),
        ),
      ),
    );
  }
}
