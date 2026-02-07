import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';

import '../../constants/number_constants.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utility.dart';
import '../model/social_media_model.dart';

class BusinessInformationScreen extends ConsumerStatefulWidget {
  const BusinessInformationScreen({super.key});

  @override
  ConsumerState<BusinessInformationScreen> createState() =>
      _BusinessInformationScreenState();
}

class _BusinessInformationScreenState
    extends ConsumerState<BusinessInformationScreen> {
  final _key = GlobalKey<FormState>();

  late TextEditingController _contactPersonController;
  late TextEditingController _contactNumberController;
  late TextEditingController _contactEmailController;
  late TextEditingController _licenceController;
  late TextEditingController _vatController;
  late TextEditingController _businessTypeController;
  late TextEditingController _websiteController;
  String? _selectedBusinessType;

  @override
  void initState() {
    super.initState();
    Utils.userId;
    _contactPersonController = TextEditingController();
    _contactNumberController = TextEditingController();
    _contactEmailController = TextEditingController();
    _licenceController = TextEditingController();
    _vatController = TextEditingController();
    _businessTypeController = TextEditingController();
    _websiteController = TextEditingController();
    _getData();
  }

  @override
  void dispose() {
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _contactEmailController.dispose();
    _licenceController.dispose();
    _vatController.dispose();
    _businessTypeController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  final List<String> _businessTypes = [
    'Restaurant',
    'Cafe',
    'Fast food Shop',
    'Food court Cloud kitchen',
  ];

  _getData() {
    final profileState = ref.read(profileProvider);
    final profile = profileState.getProfileData?.data;
    if (profile!.contactAndRegistrationDetailsResponse != null || profile!.bankDetailsResponse != null) {
      final business = profile.contactAndRegistrationDetailsResponse;
      final website = profile.businessDetailsResponse;

      _contactPersonController.text = business!.contactPersonName ?? "";
      _contactNumberController.text = business.contactNumber ?? "";
      _contactEmailController.text = business.contactEmail ?? "";
      _licenceController.text = business.treadLicenseNumber ?? "";
      _vatController.text = business.vatNumber ?? "";
      _websiteController.text = website!.website ?? "";


    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    Strings.BUSINESS_INFORMATION,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),

                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Contact and Registration Details",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: Constant.CONTAINER_SIZE_18,
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_08),

                      Utils.buildTextField(
                        context,
                        controller: _contactPersonController,
                        label: Strings.CONTACT_PERSON,
                        hint: Strings.CONTACT_PERSON,
                        keyboard: TextInputType.text,
                        validator: (v) =>
                            Utils.validateRequired(v, Strings.CONTACT_PERSON),
                      ),
                      SizedBox(height: Constant.SIZE_10),

                      Utils.buildTextField(
                        context,
                        controller: _contactNumberController,
                        label: Strings.MOBILE_NUMBER,
                        hint: Strings.MOBILE_NUMBER,
                        keyboard: TextInputType.number,
                        validator: Utils.validateMobile,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),

                      SizedBox(height: Constant.SIZE_10),
                      Utils.buildTextField(
                        context,
                        controller: _contactEmailController,
                        label: Strings.EMAIL_REGISTRATION,
                        hint: Strings.EMAIL_REGISTRATION,
                        keyboard: TextInputType.emailAddress,
                        validator: Utils.validateEmailId,
                      ),
                      SizedBox(height: Constant.SIZE_10),

                      Utils.buildTextField(
                        context,
                        controller: _licenceController,
                        label: Strings.TRADE_LICENSE_NUMBER,
                        hint: Strings.TRADE_LICENSE_NUMBER,
                        keyboard: TextInputType.emailAddress,
                        validator: Utils.validateTradeLicense,
                      ),
                      SizedBox(height: Constant.SIZE_10),
                      Utils.buildTextField(
                        context,
                        controller: _vatController,
                        label: Strings.VAT_NUMBER,
                        hint: Strings.VAT_NUMBER,
                        keyboard: TextInputType.text,
                        validator: (v) => Utils.validateTaxNumber(v),
                      ),
                      SizedBox(height: Constant.SIZE_10),

                      Text(
                        Strings.BUSINESS_DTLS,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: Constant.CONTAINER_SIZE_18,
                        ),
                      ),

                      SizedBox(height: Constant.SIZE_08),

                      DropdownButtonFormField2<String>(
                        value: _selectedBusinessType,

                        selectedItemBuilder: (context) {
                          return _businessTypes.map((item) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item,
                                style: TextStyle(color: Colors.white70),
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
                            vertical: Constant.CONTAINER_SIZE_10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.SIZE_08,
                            ),
                            borderSide: BorderSide(color: Constant.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_14,
                            ),
                            borderSide: BorderSide(color: Constant.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_14,
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
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() => _selectedBusinessType = value);
                        },
                      ),

                      SizedBox(height: Constant.SIZE_10),

                      Utils.buildTextField(
                        context,
                        controller: _websiteController,
                        label: Strings.WEBSITE,
                        hint: Strings.WEBSITE,
                        keyboard: TextInputType.text,
                        validator: (v) => Utils.validateRequired(v, 'Website'),
                      ),
                      SizedBox(height: Constant.SIZE_18),

                      InkWell(
                        onTap: () => _openSocialMediaSheet(context),
                        child: Padding(
                          padding: EdgeInsets.all(Constant.SIZE_08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: theme.secondaryHeaderColor),
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
                        ),
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_70),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),

              child: SubmitButton(
                rightText: Strings.SAVE_CHANGES,
                onRightTap: () {
                  if (!_key.currentState!.validate()) {
                    return;
                  }
                  Utils.showToast("Information uploaded successful");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSocialMediaSheet(BuildContext context) {
    final registrationState = ref.watch(authNotifierProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.SIZE_10),
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
                  final alreadyAdded = registrationState.socialMediaList.any(
                    (e) => e.socialMediaType == item.type,
                  );

                  return GestureDetector(
                    onTap: alreadyAdded
                        ? null
                        : () {
                            Navigator.pop(context);
                            registrationState.setSocialMedia(
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
                          CircleAvatar(
                            backgroundColor: item.color,
                            child: Icon(item.icon, color: Colors.black),
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
    final data = {
      "userId": Utils.userId,

      "basicDetails": {
        "businessType": "Restaurant",
        "websiteDetails": "https://www.surajrestaurant.com",
        "cuisine": "Indian"
      },

      "contactAndRegistrationDetails": {
        "contactPersonName": _contactPersonController.text,
        "contactEmail": _contactEmailController.text,
        "treadLicenseNumber": _licenceController.text,
        "vatNumber": _contactNumberController.text,
        "contactNumber": _contactNumberController.text,
        "registrationNumber": regdNo
      },

      "socialMediaList": [
        {
          "socialMediaType": "Instagram",
          "link": "https://instagram.com/surajrestaurant"
        },
        {
          "socialMediaType": "Facebook",
          "link": "https://facebook.com/surajrestaurant"
        }
      ]
    };
    return data;
  }

  _businessInfoNetworkCall(String regdNo) async {
    Utils.printLog('business info Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return;
    }
    try {
      await ref.read(businessInfoProvider(getJsonData(regdNo)).future);
      Navigator.pop(context);
    } catch (e) {
      Utils.printLog(e.toString());
    }
  }

}
