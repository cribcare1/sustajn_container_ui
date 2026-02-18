import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sustajn_restaurant/auth/screens/payment_type_screen.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/provider/login_provider.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/submit_button.dart';
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

  late FocusNode focusNode;
  late FocusNode _contactFocus;
  late FocusNode _vatFocus;
  late FocusNode _contactNumberFocus;
  late FocusNode _contactEmailFocus;
  late FocusNode _licenceFocus;
  late FocusNode _businessTypeFocus;
  late FocusNode _websiteFocus;

  String? _selectedBusinessType;
  bool _isLoading = false;

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

    _contactFocus = FocusNode();
    _vatFocus = FocusNode();
    _contactNumberFocus = FocusNode();
    _contactEmailFocus = FocusNode();
    _licenceFocus = FocusNode();
    _websiteFocus = FocusNode();
    _businessTypeFocus = FocusNode();
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

    _contactFocus.dispose();
    _vatFocus.dispose();
    _contactNumberFocus.dispose();
    _contactEmailFocus.dispose();
    _licenceFocus.dispose();
    _websiteFocus.dispose();
    _businessTypeFocus.dispose();
    super.dispose();
  }

  _getData() {
    final profileState = ref.read(profileProvider);
    final profile = profileState.getProfileData?.data;
    if (profile!.contactAndRegistrationDetailsResponse != null ||
        profile.bankDetailsResponse != null) {
      final business = profile.contactAndRegistrationDetailsResponse;
      final website = profile.businessDetailsResponse;

      contactPersonController.text = business!.contactPersonName ?? "";
      contactNumberController.text = business.contactNumber ?? "";
      contactEmailController.text = business.contactEmail ?? "";
      licenceController.text = business.treadLicenseNumber ?? "";
      vatController.text = business.vatNumber ?? "";
      websiteController.text = website!.website ?? "";
    }
  }

  final List<String> _businessTypes = [
    Strings.RESTAURANT,
    Strings.CAFE,
    Strings.FAST_FOOD,
    Strings.FOOD_COURT,
  ];

  @override
  Widget build(BuildContext context) {
    String? regdNo;

    if (widget.previous == Strings.PROFILE) {
      final profileState = ref.watch(profileProvider);
      regdNo = profileState
          .getProfileData
          ?.data
          ?.contactAndRegistrationDetailsResponse
          ?.registrationNumber;
    }

    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.previous == Strings.PROFILE
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
                          color: active ? Constant.grey : Colors.white,
                          borderRadius: BorderRadius.circular(Constant.SIZE_10),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_20),
                Text(
                  Strings.BUSINESS_INFORMATION,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  Strings.BUSINESS_INFO_TXT,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_25),
              ],
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  Strings.CONTACT_REGISTRATION,
                  textAlign: TextAlign.left,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: Constant.SIZE_05),
              Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Strings.CONTACT_PERSON;
                        }
                        return null;
                      },
                      keyboard: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                      ],
                      controller: contactPersonController,
                      hint: Strings.CONTACT_PERSON,
                      label: Strings.CONTACT_PERSON,
                      focusNode: _contactFocus,
                    ),

                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.MOBILE_NUMBER;
                        }
                        if (value.length != 10) {
                          return Strings.MOBILE_VALIDATE;
                        }
                        return null;
                      },
                      controller: contactNumberController,
                      hint: Strings.MOBILE_NUMBER,
                      label: Strings.MOBILE_NUMBER,
                      focusNode: _contactNumberFocus,
                      keyboard: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.EMAIL_REGISTRATION;
                        }
                        final email = value.trim();

                        if (email.contains(' ')) {
                          return Strings.ENTER_EMAIL_ADDRESS;
                        }

                        final regex = Strings.email;

                        if (!regex.hasMatch(email)) {
                          return Strings.ENTER_EMAIL_ADDRESS;
                        }
                        return null;
                      },
                      controller: contactEmailController,
                      hint: Strings.EMAIL_REGISTRATION,
                      label: Strings.EMAIL_REGISTRATION,
                      focusNode: _contactEmailFocus,
                      keyboard: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.TRADE_LICENSE_NUMBER;
                        }
                        if (value.length != 5) {
                          return Strings.TRADE_LICENSE_VALIDATE;
                        }
                        return null;
                      },
                      controller: licenceController,
                      hint: Strings.TRADE_LICENSE_NUMBER,
                      label: Strings.TRADE_LICENSE_NUMBER,
                      focusNode: _licenceFocus,
                      keyboard: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                    _buildTextField(
                      context,
                      keyboard: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.VAT_NUMBER;
                        }
                        if (value.length != 15) {
                          return Strings.VAT_NUMBER_15;
                        }
                        return null;
                      },
                      controller: vatController,
                      hint: Strings.VAT_NUMBER,
                      label: Strings.VAT_NUMBER,
                      focusNode: _vatFocus,
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        Strings.BUSINESS_DTLS,
                        textAlign: TextAlign.left,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_15),
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
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_20,
                          ),
                          borderSide: BorderSide(color: Constant.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_16,
                          ),
                          borderSide: BorderSide(color: Constant.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_16,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1AE31),
                          ),
                        ),
                      ),

                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
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
                        setState(() => _selectedBusinessType = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.ENTER_BUSINESSTYPE;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: Constant.SIZE_10),

                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.ENTER_WEBSITE;
                        }
                        return null;
                      },
                      controller: websiteController,
                      hint: Strings.ENTER_WEBSITE,
                      label: Strings.ENTER_WEBSITE,
                      focusNode: _websiteFocus,
                      textInputAction: TextInputAction.done,
                    ),
                    widget.authState.socialMediaList.isNotEmpty
                        ? Column(
                            children: widget.authState.socialMediaList.map((
                              item,
                            ) {
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
                                    SizedBox(width: Constant.CONTAINER_SIZE_12),
                                    Expanded(
                                      child: TextField(
                                        controller: item.controller,
                                        decoration: InputDecoration(
                                          hintText: Strings.LINK,
                                          hintStyle: theme.textTheme.titleSmall!
                                              .copyWith(color: Colors.grey),
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
                                                    .removeSocialMedia(item);
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              Constant.CONTAINER_SIZE_25,
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
                          Icon(Icons.add, color: theme.secondaryHeaderColor),
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
                    if (widget.previous == Strings.PROFILE) ...[
                      SizedBox(
                        width: double.infinity,
                        child: SubmitButton(
                          rightText: Strings.SAVE_BUSINESS_DTLS,
                          isLoading: _isLoading,
                          onRightTap: _isLoading
                              ? null
                              : () async {
                            if (!_key.currentState!.validate()) return;

                            setState(() => _isLoading = true);

                            /// PROFILE FLOW
                            if (widget.previous == Strings.PROFILE) {
                              final bool success =
                                  await _businessInfoNetworkCall(regdNo!) ?? false;

                              if (!mounted) return;

                              setState(() => _isLoading = false);

                              if (success) {
                                Utils.showToast(
                                  '${Strings.BUSINESS_INFO} ${Strings.SUCC_MSG}',
                                );
                                NavUtil.popScreen(context, 1);
                              } else {
                                showCustomSnackBar(
                                  context: context,
                                  message: Strings.SOMETHING_WENT_WRONG,
                                  color: Colors.red,
                                );
                              }
                              return;
                            }

                            setState(() => _isLoading = false);
                          },
                        ),
                      ),

                    ] else ...[
                      SubmitClearButton(
                        onLeftTap: () {
                          Utils.skipDialog(
                            context: context,
                            icon: Icons.warning_amber,
                            subTitle: Strings.SKIP_BUSINESS_DETAILS,
                            cancelButtonText: Strings.CANCEL,
                            yesButtonText: Strings.SKIP_CONTINUE,
                            onCancel: () {
                              NavUtil.popScreen(context, 1);
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
                        onRightTap: _isLoading
                            ? null
                            : () async {
                                if (!_key.currentState!.validate()) {
                                  return;
                                }
                                setState(() => _isLoading = true);
                                NavUtil.navigateToPushScreen(
                                  context,
                                  PaymentTypeScreen(),
                                );
                              },
                        rightText: Strings.CONTINUE,
                        isLoading: _isLoading,
                      ),
                    ],
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
    required String label,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([focusNode, controller]),
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(bottom: Constant.SIZE_15),
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboard,
            textInputAction: textInputAction,
            obscureText: obscure,
            style: TextStyle(color: Colors.white70),
            cursorColor: Colors.white70,
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: focusNode.hasFocus ? null : hint,
              hintStyle: TextStyle(color: Colors.white70),

              labelText: (focusNode.hasFocus || controller.text.isNotEmpty)
                  ? label
                  : null,

              labelStyle: TextStyle(color: Colors.white70),
              floatingLabelBehavior: FloatingLabelBehavior.auto,

              filled: true,
              fillColor: theme.primaryColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: BorderSide(color: Constant.grey),
              ),
              enabledBorder: CustomTheme.roundedBorder(Constant.grey),
              focusedBorder: CustomTheme.roundedBorder(Constant.grey),
            ),
          ),
        );
      },
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
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                  CloseButton(color: Colors.white),
                ],
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Wrap(
                spacing: Constant.CONTAINER_SIZE_20,
                alignment: WrapAlignment.center,
                children: socialMediaOptions.map((item) {
                  final alreadyAdded = widget.authState.socialMediaList.any(
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
                            style: const TextStyle(color: Colors.white),
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
        "businessType": Strings.RESTAURANT,
        "websiteDetails": websiteController.text,
      },

      "contactAndRegistrationDetails": {
        "contactPersonName": contactPersonController.text,
        "contactEmail": contactEmailController.text,
        "treadLicenseNumber": licenceController.text,
        "vatNumber": vatController.text,
        "contactNumber": contactNumberController.text,
        "registrationNumber": regdNo,
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
      await ref.read(businessInfoProvider(getJsonData(regdNo)).future);
      return true;
    } catch (e) {
      Utils.printLog('Business info error: $e');
      return false;
    }
  }
}
