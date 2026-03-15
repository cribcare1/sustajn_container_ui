import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../network_provider/network_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utils/utility.dart';

enum MobileEditType { primary, secondary }

class EditMobileNumberDialog extends ConsumerStatefulWidget {
  final String primaryMobileNumber;
  final String secondaryMobileNumber;
  final MobileEditType editType;

  const EditMobileNumberDialog({
    super.key,
    required this.primaryMobileNumber,
    required this.secondaryMobileNumber,
    required this.editType,
  });

  @override
  ConsumerState<EditMobileNumberDialog> createState() =>
      _EditMobileNumberDialogState();
}

class _EditMobileNumberDialogState
    extends ConsumerState<EditMobileNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _primaryController = TextEditingController();
  final TextEditingController _secondaryController = TextEditingController();
  File? imageFile;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    Utils.getToken();
    Utils.userId;
    if (widget.editType == MobileEditType.primary) {
      _primaryController.text = widget.primaryMobileNumber;
    } else {
      _secondaryController.text = widget.secondaryMobileNumber;
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();

    super.dispose();
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
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
final profileState = ref.read(profileProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_16,
            0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Utils.buildFloatingHeader(context),
              SizedBox(height: Constant.SIZE_08),
              Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constant.CONTAINER_SIZE_16),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.editType == MobileEditType.primary
                            ? Strings.EDIT_MOBILE_NUMBER
                            : Strings.EDIT_SECONDARY_MOBILE_NUMBER,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_20),

                      if (widget.editType == MobileEditType.primary)
                        TextFormField(
                          controller: _primaryController,
                          validator: _validateMobileNumber,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: _inputDecoration(
                            theme,
                            Strings.PRIMARY_NUMBER,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),

                      if (widget.editType == MobileEditType.secondary)
                        TextFormField(
                          controller: _secondaryController,
                          validator: _validateMobileNumber,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: _inputDecoration(
                            theme,
                            Strings.SECONDARY_NUMBER,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),

                      SizedBox(height: Constant.CONTAINER_SIZE_24),

                     profileState.isSaving?const Center(child: CircularProgressIndicator(),): SizedBox(
                        width: double.infinity,
                        child: SubmitButton(
                          rightText: Strings.SAVE_CHANGES,
                          onRightTap: () {
                            if (!_formKey.currentState!.validate()) return;
                            _editMobileNetworkCall();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        borderSide: BorderSide(color: Constant.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        borderSide: BorderSide(color: Constant.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
    );
  }
//TODO:- conformation Dialog
  // Future<void> _showConfirmationDialog(BuildContext context) async {
  //   final theme = Theme.of(context);
  //
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           return AlertDialog(
  //             backgroundColor: theme.scaffoldBackgroundColor,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
  //             ),
  //             title: const Text(
  //               Strings.CONFIRM_UPDATE,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             content: Text(
  //               Strings.UPDATE_CONTACT_NO,
  //               style: TextStyle(color: Colors.grey.shade300),
  //             ),
  //             actions: [
  //               /// NO button
  //               TextButton(
  //                 onPressed: _isUpdating
  //                     ? null
  //                     : () {
  //                         Navigator.of(dialogContext).pop();
  //                       },
  //                 child: const Text(
  //                   Strings.NO,
  //                   style: TextStyle(color: Colors.grey),
  //                 ),
  //               ),
  //
  //               SizedBox(
  //                 width: Constant.CONTAINER_SIZE_120,
  //                 child: SubmitButton(
  //                   rightText: Strings.UPDATE,
  //                   isLoading: _isUpdating,
  //                   onRightTap: _isUpdating
  //                       ? null
  //                       : () async {
  //                           setDialogState(() => _isUpdating = true);
  //
  //                           await Future.delayed(Duration(seconds: 2));
  //
  //                           final result = await _editMobileNetworkCall();
  //
  //                           if (!mounted) return;
  //
  //                           setDialogState(() => _isUpdating = false);
  //
  //                           if (result != false) {
  //                             Navigator.of(dialogContext).pop();
  //                             NavUtil.popScreen(context, 2);
  //                           } else {
  //                             Utils.showToast(Strings.SOMETHING_WENT_WRONG);
  //                           }
  //                         },
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Map<String, dynamic> getJsonData() {
    return {
      "userId": Utils.userId,
      "phoneNumber": widget.editType == MobileEditType.primary
          ? _primaryController.text
          : widget.primaryMobileNumber,
      "secondaryNumber": widget.editType == MobileEditType.secondary
          ? _secondaryController.text
          : widget.secondaryMobileNumber,
    };
  }

  _editMobileNetworkCall() async {
    Utils.printLog('edit mobile number Network call');
    ref.read(profileProvider).setIsSaving(true);
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
        Strings.USER_DATA: getJsonData(),
      }),
    );
  }
}
