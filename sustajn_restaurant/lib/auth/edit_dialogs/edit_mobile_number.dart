import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utility.dart';

class EditMobileNumberDialog extends ConsumerStatefulWidget {
  final String mobileNumber;

  const EditMobileNumberDialog({
    Key? key, required this.mobileNumber});

  @override
  ConsumerState<EditMobileNumberDialog> createState() =>
      _EditMobileNumberDialogState();
}

class _EditMobileNumberDialogState
    extends ConsumerState<EditMobileNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    super.initState();

    Utils.getToken();
    Utils.userId;
    // final String mobileNumber = "";
    // _mobileController.text = mobileNumber;
    _mobileController.text = widget.mobileNumber;

    _mobileController.selection = TextSelection.collapsed(
      offset: _mobileController.length,
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Enter your mobile number';
    }
    if (value.length != 10) {
      return 'Enter a valid 10-digit number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final profileState = ref.watch(profileProvider);
    return SafeArea(
      top: false,
      child: Padding(
        padding: MediaQuery
            .of(context)
            .viewInsets,
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
                        'Edit Mobile Number',
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

                SizedBox(height: Constant.SIZE_08),

                TextFormField(
                  controller: _mobileController,
                  validator: _validateMobileNumber,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.white,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_16,
                      vertical: Constant.CONTAINER_SIZE_14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      borderSide: BorderSide(color: Constant.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      borderSide: BorderSide(color: Constant.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      borderSide: BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_24),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      await _editMobileNetworkCall(
                        _mobileController.text.trim(),
                      );
                      if (mounted) {
                        Navigator.pop(context, _mobileController.text.trim());
                      }
                      // {
                      //   Navigator.pop(context, _controller.text.trim());
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC8B531),
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.CONTAINER_SIZE_14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_12,
                        ),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> getJsonData(String mobileNo) {
    final data = {
      "userId": Utils.userId,
      "phoneNumber": mobileNo
    };
    return data;
  }

  _editMobileNetworkCall(String mobileNo) async {
    Utils.printLog('edit mobile number Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return;
    }

    ref.read(
      profileUpdateProvider({
        NetworkUrls.UPDATE_PROFILE: NetworkUrls.UPDATE_PROFILE,
        Strings.USER_DATA: getJsonData(mobileNo),
      }),
    );
  }
}