import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';

import '../../constants/number_constants.dart';
import '../../provider/login_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../model/social_media_model.dart';

class BusinessInformationScreen extends ConsumerStatefulWidget {
  const BusinessInformationScreen({super.key});

  @override
  ConsumerState<BusinessInformationScreen> createState() => _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends ConsumerState<BusinessInformationScreen> {

  final contactPersonController = TextEditingController();
  final contactNumberController = TextEditingController();
  final contactEmailController = TextEditingController();
  final licenceController = TextEditingController();
  final taxController = TextEditingController();
  final businessTypeController = TextEditingController();
  final websiteController = TextEditingController();
  final _key = GlobalKey<FormState>();

  _getData() {
    final profileState = ref.read(profileProvider);
    final profile = profileState.getProfileData?.data;
    if (profile!.bankDetailsResponse != null) {
      final business = profile.bankDetailsResponse;
    }
  }

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
                // padding: EdgeInsets.symmetric(horizontal: Constant.SIZE_16),
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),

                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      Utils.buildTextField(
                        context,
                        controller: contactPersonController,
                        label: Strings.CONTACT_PERSON,
                        hint: Strings.CONTACT_PERSON,
                        keyboard: TextInputType.text,
                      ),
                      SizedBox(height: Constant.SIZE_10),

                      Utils.buildTextField(
                        context,
                        controller: contactNumberController,
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
                        controller: contactEmailController,
                        label: Strings.EMAIL_REGISTRATION,
                        hint: Strings.EMAIL_REGISTRATION,
                        keyboard: TextInputType.emailAddress,
                        validator: Utils.validateEmailId,
                      ),
                      SizedBox(height: Constant.SIZE_10),

                      Utils.buildTextField(
                        context,
                        controller: licenceController,
                        label: Strings.TRADE_LICENSE_NUMBER,
                        hint: Strings.TRADE_LICENSE_NUMBER,
                        keyboard: TextInputType.emailAddress,
                        validator: Utils.validateTradeLicense,
                      ),
                      SizedBox(height: Constant.SIZE_10),
                      Utils.buildTextField(
                        context,
                        controller: taxController,
                        label: Strings.TAX_NUMBER,
                        hint: Strings.TAX_NUMBER,
                        keyboard: TextInputType.text,
                        validator:  (v) => Utils.validateTaxNumber(v),
                      ),
                      SizedBox(height: Constant.SIZE_10),

                      Utils.buildTextField(
                        context,
                        controller: businessTypeController,
                        label: Strings.TYPES_OF_BUSINESS,
                        hint: Strings.TYPES_OF_BUSINESS,
                        keyboard: TextInputType.text,
                      ),
                      SizedBox(height: Constant.SIZE_10),
                      Utils.buildTextField(
                        context,
                        controller: websiteController,
                        label: Strings.WEBSITE,
                        hint: Strings.WEBSITE,
                        keyboard: TextInputType.text,
                      ),
                      SizedBox(height: Constant.SIZE_18),

                      InkWell(
                        onTap: () => _openSocialMediaSheet(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              // size: Constant.CONTAINER_SIZE_18,
                              color: theme.secondaryHeaderColor,
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
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_70),
                    ],
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                if(_key.currentState!.validate()){
                  Utils.showToast("Information uploaded successful");
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: Constant.SIZE_15,
                  right: Constant.SIZE_15,
                  bottom: mediaQuery.padding.bottom + Constant.SIZE_10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: SubmitButton(
                    onRightTap: () {},
                    rightText: Strings.SAVE_CHANGES,
                  ),
                ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
}
