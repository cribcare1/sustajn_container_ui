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
import '../../utils/utils.dart';

class EditMobileNumberDialog extends ConsumerStatefulWidget {
  final String mobileNumber;
  final int userId;
  const EditMobileNumberDialog({Key? key, required this.mobileNumber, required this.userId}) : super(key: key);

  @override
  ConsumerState<EditMobileNumberDialog> createState() =>
      _EditMobileNumberDialogState();
}

class _EditMobileNumberDialogState extends ConsumerState<EditMobileNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();


  File? imageFile;

  @override
  void initState() {
    super.initState();

    Utils.getToken();
    Utils.userId;
    _controller.text = widget.mobileNumber;

    _controller.selection = TextSelection.collapsed(
      offset: _controller.length,
    );
  }


  @override
  void dispose() {
    _controller.dispose();
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
                        'Edit Mobile Number',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_20),
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
                  controller: _controller,
                  validator: _validateMobileNumber,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.white,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white
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
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide: BorderSide(color: Constant.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide:
                      BorderSide(color: Constant.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide:
                      BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),


                SizedBox(height: Constant.CONTAINER_SIZE_24),

               profileState.isLoading ?Utils.showProgressBar(): SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      await _editMobileNetwork(
                        _controller.text.trim(),
                        profileState,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC8B531),
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.CONTAINER_SIZE_14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_12),
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

  Future<bool> _editMobileNetwork(String name, var profileState) async {
    try {
      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();

      if (!isNetworkAvailable) {
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        return false;
      }

      profileState.setContext(context);
      profileState.setIsLoading(true);

      if (profileState.profileList.isNotEmpty) {
        profileState.profileList.first.fullName = name;
      }

      final params = Utils.multipartParams(
        NetworkUrls.UPDATE_PROFILE,
        getJsonData(name),
        Strings.USER_DATA,
      );

      await ref.read(profileUpdateProvider(params).future);

      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      ref.read(profileProvider).clearProfileList();
      ref.read(
        getProfileProvider('${NetworkUrls.GET_PROFILE}${widget.userId}'),
      );

      return true;
    } catch (e) {
      Utils.printLog('Error in edit name: $e');
      return false;
    } finally {
      profileState.setIsLoading(false);
    }
  }
}