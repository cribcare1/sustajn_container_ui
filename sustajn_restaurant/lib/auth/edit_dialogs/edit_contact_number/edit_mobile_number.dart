import 'dart:io';

import 'package:country_code_picker_plus/country_code_picker_plus.dart';
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
    Utils.userId;
    if (widget.editType == MobileEditType.primary) {
      _primaryController.text = widget.primaryMobileNumber.split(" ").last;
    } else {
      _secondaryController.text = widget.secondaryMobileNumber.split(" ").last;
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
  Country? _selectedCountry = Country(
    code: 'AE',
    dialCode: '+971',
    name: 'United Arab Emirates',
  );
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    Constant.CONTAINER_SIZE_16,
                                  ),
                                  border: Border.all(color: Constant.grey),
                                ),
                                child: CountryCodePicker(
                                  textStyle: theme.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                  mode: CountryCodePickerMode.dialog,
                                  dialogBackgroundColor: theme.primaryColor,
                                  dialogTextStyle: theme.textTheme.titleSmall!
                                      .copyWith(color: Colors.white),
                                  searchStyle: theme.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                  closeIcon: Icon(Icons.close, color: Colors.white),
                                  searchDecoration: InputDecoration(
                                    hintText: "search country name",
                                    hintStyle: theme.textTheme.titleSmall!.copyWith(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountry = value;

                                    });
                                  },
                                  initialSelection: "AE",
                                  showFlag: true,
                                  showDropDownButton: true,
                                ),
                              ),
                            ),
                            SizedBox(width: Constant.SIZE_08),
                            Expanded(
                              flex: 6,
                              child:   TextFormField(
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
                            ),
                          ],
                        ),


                      if (widget.editType == MobileEditType.secondary)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    Constant.CONTAINER_SIZE_16,
                                  ),
                                  border: Border.all(color: Constant.grey),
                                ),
                                child: CountryCodePicker(
                                  textStyle: theme.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                  mode: CountryCodePickerMode.dialog,
                                  dialogBackgroundColor: theme.primaryColor,
                                  dialogTextStyle: theme.textTheme.titleSmall!
                                      .copyWith(color: Colors.white),
                                  searchStyle: theme.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                  closeIcon: Icon(Icons.close, color: Colors.white),
                                  searchDecoration: InputDecoration(
                                    hintText: "search country name",
                                    hintStyle: theme.textTheme.titleSmall!.copyWith(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountry = value;

                                    });
                                  },
                                  initialSelection: "AE",
                                  showFlag: true,
                                  showDropDownButton: true,
                                ),
                              ),
                            ),
                            SizedBox(width: Constant.SIZE_08),
                            Expanded(
                              flex: 6,
                              child:   TextFormField(
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
                            ),
                          ],
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
  Map<String, dynamic> getJsonData() {
    return {
      "userId": Utils.userId,
      "phoneNumber": widget.editType == MobileEditType.primary
          ? "${_selectedCountry!.dialCode} ${_primaryController.text}"
          : widget.primaryMobileNumber,
      "secondaryNumber": widget.editType == MobileEditType.secondary
          ? "${_selectedCountry!.dialCode} ${_secondaryController.text}"
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
