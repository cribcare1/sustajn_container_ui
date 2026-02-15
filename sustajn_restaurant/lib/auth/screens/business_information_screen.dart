import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sustajn_restaurant/auth/screens/payment_type_screen.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/provider/login_provider.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../network_provider/network_provider.dart';
import '../../notifier/login_notifier.dart';
import '../../provider/profile_provider.dart';
import '../model/social_media_model.dart';

class BusinessInformationDetails extends ConsumerStatefulWidget {
  final AuthState authState;
  final String? previous;

  const BusinessInformationDetails({
    super.key,
    required this.authState,
    this.previous = "",
  });

  @override
  ConsumerState<BusinessInformationDetails> createState() =>
      _BusinessInformationDetailsState();
}

class _BusinessInformationDetailsState
    extends ConsumerState<BusinessInformationDetails> {
  final _key = GlobalKey<FormState>();

  late TextEditingController websiteController;
  late TextEditingController contactPersonController;
  late TextEditingController vatController;
  late TextEditingController contactNumberController;
  late TextEditingController contactEmailController;
  late TextEditingController licenceController;
  late TextEditingController businessTypeController;

  String? _selectedBusinessType;

  final Map<String, bool> _fieldTouched = {
    'contactPerson': false,
    'contactNumber': false,
    'email': false,
    'licence': false,
    'vat': false,
    'website': false,
    'businessType': false,
  };

  final Map<String, String?> _fieldErrors = {
    'contactPerson': null,
    'contactNumber': null,
    'email': null,
    'licence': null,
    'vat': null,
    'website': null,
    'businessType': null,
  };

  bool _formSubmitted = false;

  @override
  void initState() {
    super.initState();
    Utils.userId;
    contactPersonController = TextEditingController();
    contactNumberController = TextEditingController();
    contactEmailController = TextEditingController();
    licenceController = TextEditingController();
    vatController = TextEditingController();
    websiteController = TextEditingController();
    businessTypeController = TextEditingController();

    contactPersonController.addListener(() {
      _validateFieldRealTime('contactPerson', contactPersonController.text, _validateContactPerson);
    });
    contactNumberController.addListener(() {
      _validateFieldRealTime('contactNumber', contactNumberController.text, _validateContactNumber);
    });
    contactEmailController.addListener(() {
      _validateFieldRealTime('email', contactEmailController.text, _validateEmail);
    });
    licenceController.addListener(() {
      _validateFieldRealTime('licence', licenceController.text, _validateTradeLicense);
    });
    vatController.addListener(() {
      _validateFieldRealTime('vat', vatController.text, _validateVAT);
    });
    websiteController.addListener(() {
      _validateFieldRealTime('website', websiteController.text, _validateWebsite);
    });
  }

  void _validateFieldRealTime(
      String fieldName,
      String value,
      String? Function(String?) validator,
      ) {
    if (!_fieldTouched[fieldName]! && !_formSubmitted) {
      return;
    }

    final error = validator(value);

    if (_fieldErrors[fieldName] != error) {
      setState(() {
        _fieldTouched[fieldName] = true;
        _fieldErrors[fieldName] = error;
      });
    }
  }

  @override
  void dispose() {
    contactPersonController.dispose();
    contactNumberController.dispose();
    contactEmailController.dispose();
    licenceController.dispose();
    vatController.dispose();
    websiteController.dispose();
    businessTypeController.dispose();
    super.dispose();
  }

  final List<String> _businessTypes = [
    'Restaurant',
    'Cafe',
    'Fast food Shop',
    'Food court Cloud kitchen',
  ];

  String? _validateContactPerson(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.CONTACT_PERSON_ERROR_TXT;
    }

    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Contact person name should contain only letters and spaces';
    }

    if (value.trim().length < 2) {
      return 'Contact person name should be at least 2 characters';
    }

    if (value.length > 20) {
      return 'Contact person name should not exceed 50 characters';
    }

    return null;
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.MOBILE_NUMBER_ERROR_TXT;
    }

    final cleanedNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedNumber.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.EMAIL_REGISTRATION_ERROR_TXT;
    }

    final email = value.trim();

    if (email.split('@').length != 2) {
      return 'Please enter a valid email address';
    }

    final RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    if (email.contains('..')) {
      return 'Please enter a valid email address';
    }

    if (email.startsWith('@') || email.endsWith('@')) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validateTradeLicense(String? value) {
    if (value == null || value.isEmpty) {
      return 'Trade License number is required';
    }

    final cleanedValue = value.trim();

    if (cleanedValue.length < 5) {
      return 'Trade License number should be at least 5 characters';
    }

    if (cleanedValue.length > 12) {
      return 'Trade License number should not exceed 12 characters';
    }

    final RegExp licenseRegex = RegExp(r'^[a-zA-Z0-9\s\-]+$');
    if (!licenseRegex.hasMatch(cleanedValue)) {
      return 'Trade License contains invalid characters';
    }

    return null;
  }

  String? _validateVAT(String? value) {
    if (value == null || value.isEmpty) {
      return 'VAT number is required';
    }

    final cleanedValue = value.replaceAll(' ', '');

    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return 'VAT number should contain only digits';
    }

    if (cleanedValue.length != 15) {
      return 'UAE VAT number must be exactly 15 digits';
    }

    return null;
  }

  String? _validateWebsite(String? value) {
    if (value == null || value.isEmpty) {
      return 'Website URL is required';
    }

    final cleanedValue = value.trim();

    final RegExp urlRegex = RegExp(
      r'^(https?:\/\/)?'
      r'(www\.)?'
      r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b'
      r'([-a-zA-Z0-9()@:%_\+.~#?&/=]*)$',
    );

    if (!urlRegex.hasMatch(cleanedValue)) {
      return 'Please enter a valid website URL (e.g., www.example.com or https://example.com)';
    }

    if (!cleanedValue.startsWith('http://') &&
        !cleanedValue.startsWith('https://')) {
      if (!cleanedValue.startsWith('www.')) {
        return 'Website should start with www. or http:// or https://';
      }
    }

    return null;
  }

  String? _validateBusinessType(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.BUSINESS_TYPE_ERROR_TXT;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.read(profileProvider);
    String? regdNo;

    if (widget.previous == 'profile') {
      final profileState = ref.watch(profileProvider);
      regdNo = profileState.getProfileData?.data
          ?.contactAndRegistrationDetailsResponse
          ?.registrationNumber;
    }

    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.previous == 'profile'
              ? Strings.BUSINESS_INFORMATION
              : "",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.previous == "") ...[
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Row(
                  children: List.generate(4, (index) {
                    bool active = index <= 1;
                    return Expanded(
                      child: Container(
                        height: Constant.SIZE_05,
                        margin: EdgeInsets.only(
                          right: index == 3 ? 0 : Constant.SIZE_10,
                        ),
                        decoration: BoxDecoration(
                          color: active ? Constant.gold : Colors.white,
                          borderRadius:
                          BorderRadius.circular(Constant.SIZE_10),
                        ),
                      ),
                    );
                  }),
                ),
              ],
              SizedBox(height: Constant.CONTAINER_SIZE_20),
              Text(
                Strings.BUSINESS_INFORMATION,
                style: theme.textTheme.titleLarge!
                    .copyWith(color: Colors.white),
              ),
              Text(
                Strings.BUSINESS_INFO_TXT,
                style: theme.textTheme.titleSmall!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_25),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  Strings.CONTACT_REGISTRATION,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: Constant.SIZE_05),
              Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contact Person Field
                    _buildTextField(
                      context,
                      controller: contactPersonController,
                      hint: Strings.CONTACT_PERSON,
                      fieldName: 'contactPerson',
                      validator: _validateContactPerson,
                      keyboard: TextInputType.name,
                    ),

                    // Contact Number Field
                    _buildTextField(
                      context,
                      controller: contactNumberController,
                      hint: Strings.MOBILE_NUMBER,
                      fieldName: 'contactNumber',
                      validator: _validateContactNumber,
                      keyboard: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),

                    _buildTextField(
                      context,
                      controller: contactEmailController,
                      hint: Strings.EMAIL_REGISTRATION,
                      fieldName: 'email',
                      validator: _validateEmail,
                      keyboard: TextInputType.emailAddress,
                    ),

                    _buildTextField(
                      context,
                      controller: licenceController,
                      hint: Strings.TRADE_LICENSE_NUMBER,
                      fieldName: 'licence',
                      validator: _validateTradeLicense,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(12),
                      ],
                    ),

                    _buildTextField(
                      context,
                      controller: vatController,
                      hint: Strings.VAT_NUMBER,
                      fieldName: 'vat',
                      validator: _validateVAT,
                      keyboard: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        Strings.BUSINESS_DTLS,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_15),
                    _buildBusinessTypeDropdown(context, theme),

                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      controller: websiteController,
                      hint: Strings.ENTER_WEBSITE,
                      fieldName: 'website',
                      validator: _validateWebsite,
                      keyboard: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),

                    widget.authState.socialMediaList.isNotEmpty
                        ? Column(
                      children:
                      widget.authState.socialMediaList.map((item) {
                        final config = socialMediaOptions.firstWhere(
                              (e) => e.type == item.socialMediaType,
                        );

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: Constant.CONTAINER_SIZE_12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: config.color,
                                child: Icon(
                                  config.icon,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  width:
                                  Constant.CONTAINER_SIZE_12),
                              Expanded(
                                child: TextField(
                                  controller: item.controller,
                                  decoration: InputDecoration(
                                    hintText: Strings.LINK,
                                    hintStyle: theme.textTheme
                                        .titleSmall!
                                        .copyWith(
                                        color: Colors.grey),
                                    filled: true,
                                    fillColor: theme.primaryColor,
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.authState
                                              .removeSocialMedia(
                                              item);
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        Constant
                                            .CONTAINER_SIZE_25,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                        : SizedBox(),

                    InkWell(
                      onTap: () => _openSocialMediaSheet(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add,
                              color: theme.secondaryHeaderColor),
                          Text(
                            Strings.ADD_SOCIAL_MEDIA,
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: theme.secondaryHeaderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),

                    SubmitClearButton(
                      onLeftTap: () {
                        Utils.skipDialog(
                          context: context,
                          icon: Icons.warning_amber,
                          subTitle: Strings.SKIP_BUSINESS_DETAILS,
                          cancelButtonText: Strings.CANCEL,
                          yesButtonText: Strings.SKIP_CONTINUE,
                          onCancel: () {
                            Navigator.pop(context);
                          },
                          onYes: () {
                            NavUtil.navigateToPushScreen(
                              context,
                              PaymentTypeScreen(),
                            );
                          },
                        );
                      },
                      leftText: Strings.SKIP,
                      onRightTap: () async {
                        setState(() {
                          _formSubmitted = true;
                          _fieldErrors['contactPerson'] =
                              _validateContactPerson(
                                  contactPersonController.text);
                          _fieldErrors['contactNumber'] =
                              _validateContactNumber(
                                  contactNumberController.text);
                          _fieldErrors['email'] =
                              _validateEmail(contactEmailController.text);
                          _fieldErrors['licence'] = _validateTradeLicense(
                              licenceController.text);
                          _fieldErrors['vat'] =
                              _validateVAT(vatController.text);
                          _fieldErrors['website'] =
                              _validateWebsite(websiteController.text);
                          _fieldErrors['businessType'] =
                              _validateBusinessType(_selectedBusinessType);
                        });

                        final hasErrors = _fieldErrors.values.any((e) => e != null);

                        if (hasErrors) {
                          return;
                        }

                        setState(() {
                          _formSubmitted = false;
                        });

                        if (widget.previous == 'profile') {
                          if (regdNo == null || regdNo!.isEmpty) {
                            showCustomSnackBar(
                              context: context,
                              message: Strings.SOMETHING_WENT_WRONG,
                              color: Colors.red,
                            );
                            return;
                          }

                          final bool success =
                          await _businessInfoNetworkCall(regdNo!);

                          if (success) {
                            Utils.showToast(
                                '${Strings.BUSINESS_INFO} ${Strings.SUCC_MSG}');
                            Navigator.pop(context);
                          } else {
                            showCustomSnackBar(
                              context: context,
                              message:
                              Strings.SOMETHING_WENT_WRONG,
                              color: Colors.red,
                            );
                          }

                          return;
                        }

                        NavUtil.navigateToPushScreen(
                          context,
                          PaymentTypeScreen(),
                        );
                      },
                      rightText: Strings.CONTINUE,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String hint,
        required String fieldName,
        required String? Function(String?) validator,
        TextInputType keyboard = TextInputType.text,
        TextInputAction textInputAction = TextInputAction.next,
        List<TextInputFormatter>? inputFormatters,
      }) {
    final theme = Theme.of(context);
    final error = _fieldErrors[fieldName];

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            autofocus: false,
            textInputAction: textInputAction,
            style: const TextStyle(color: Colors.white70),
            cursorColor: Colors.white70,
            inputFormatters: inputFormatters,
            // Don't use validator here, we handle it manually
            validator: (_) => null,
            onChanged: (value) {
              if (!_fieldTouched[fieldName]!) {
                setState(() {
                  _fieldTouched[fieldName] = true;
                });
              }
              _validateFieldRealTime(fieldName, value, validator);
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: theme.primaryColor,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: BorderSide(color: Constant.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: BorderSide(
                  color: error != null ? Colors.red : Constant.grey,
                  width: error != null ? 1.5 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: BorderSide(
                  color: error != null ? Colors.red : Constant.grey,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: EdgeInsets.only(
                top: Constant.SIZE_08,
                left: Constant.CONTAINER_SIZE_12,
              ),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBusinessTypeDropdown(
      BuildContext context,
      ThemeData theme,
      ) {
    final error = _fieldErrors['businessType'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField2<String>(
          value: _selectedBusinessType,
          selectedItemBuilder: (context) {
            return _businessTypes.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            }).toList();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.primaryColor,
            labelText: Strings.TYPES_OF_BUSINESS,
            labelStyle: const TextStyle(color: Colors.white70),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_16,
              vertical: Constant.CONTAINER_SIZE_14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              borderSide: BorderSide(color: Constant.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              borderSide: BorderSide(
                color: error != null ? Colors.red : Constant.grey,
                width: error != null ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              borderSide: BorderSide(
                color: error != null
                    ? Colors.red
                    : const Color(0xFFD1AE31),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
          ),
          items: _businessTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBusinessType = value;
              _fieldTouched['businessType'] = true;
              _fieldErrors['businessType'] =
                  _validateBusinessType(value);
            });
          },
          validator: (_) => null,
        ),
        if (error != null)
          Padding(
            padding: EdgeInsets.only(
              top: Constant.SIZE_08,
              left: Constant.CONTAINER_SIZE_12,
            ),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  void _openSocialMediaSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_10),
        ),
      ),
      builder: (_) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_16,
            MediaQuery.of(context).viewInsets.bottom +
                Constant.CONTAINER_SIZE_50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.SOCIAL_MEDIA,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  CloseButton(color: Colors.white),
                ],
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Wrap(
                spacing: Constant.CONTAINER_SIZE_20,
                alignment: WrapAlignment.center,
                children: socialMediaOptions.map((item) {
                  final alreadyAdded =
                  widget.authState.socialMediaList.any(
                        (e) => e.socialMediaType == item.type,
                  );

                  return GestureDetector(
                    onTap: alreadyAdded
                        ? null
                        : () {
                      Navigator.pop(context);
                      widget.authState.setSocialMedia(
                        SocialMediaModel(
                          socialMediaType: item.type,
                          controller: TextEditingController(),
                        ),
                      );
                      setState(() {});
                    },
                    child: Opacity(
                      opacity: alreadyAdded ? 0.4 : 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: Constant.CONTAINER_SIZE_60,
                            height: Constant.CONTAINER_SIZE_60,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: FaIcon(
                                item.icon,
                                color:
                                item.type == SocialMediaType.snapchat ||
                                    item.type == SocialMediaType.x
                                    ? Colors.black
                                    : Colors.white,
                                size: Constant.CONTAINER_SIZE_26,
                              ),
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_06),
                          Text(
                            item.label,
                            style:
                            const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> getJsonData(String regdNo) {
    final authState = ref.read(authNotifierProvider);
    final data = {
      "userId": Utils.userId,
      "basicDetails": {
        "businessType": _selectedBusinessType ?? "Restaurant",
        "websiteDetails": websiteController.text.trim(),
      },
      "contactAndRegistrationDetails": {
        "contactPersonName": contactPersonController.text.trim(),
        "contactEmail": contactEmailController.text.trim(),
        "treadLicenseNumber": licenceController.text.trim(),
        "vatNumber": vatController.text.replaceAll(' ', ''),
        "contactNumber": contactNumberController.text.trim(),
        "registrationNumber": regdNo
      },
      "socialMediaList": authState.socialMediaList.isEmpty
          ? []
          : authState.socialMediaList.map((e) => e.toJson()).toList(),
    };
    return data;
  }

  Future<bool> _businessInfoNetworkCall(String regdNo) async {
    Utils.printLog('business info Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return false;
    }

    try {
      await ref.read(
        businessInfoProvider(getJsonData(regdNo)).future,
      );
      return true;
    } catch (e) {
      Utils.printLog('Business info error: $e');
      return false;
    }
  }
}