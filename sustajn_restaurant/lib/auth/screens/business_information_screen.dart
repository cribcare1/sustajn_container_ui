import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/payment_type_screen.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_outline_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../notifier/login_notifier.dart';
import '../model/social_media_model.dart';

class BusinessInformationDetails extends ConsumerStatefulWidget {
  final AuthState authState;

  const BusinessInformationDetails({super.key, required this.authState});

  @override
  ConsumerState<BusinessInformationDetails> createState() =>
      _BusinessInformationDetailsState();
}

class _BusinessInformationDetailsState
    extends ConsumerState<BusinessInformationDetails> {
  final businessTypeController = TextEditingController();
  final websiteController = TextEditingController();
  final cuisineTypeController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
          ),
        ).getAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        borderRadius: BorderRadius.circular(Constant.SIZE_10),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Text(
                Strings.BUSINESS_INFORMATION,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Constant.SIZE_06),
              Text(
                Strings.PROVIDE_INFORMATION,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter business type";
                        }
                        return null;
                      },
                      controller: businessTypeController,
                      hint: "Enter business type",
                    ),
                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter website";
                        }
                        return null;
                      },
                      controller: websiteController,
                      hint: "Enter website",
                    ),
                    _buildTextField(
                      context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter country";
                        }
                        return null;
                      },
                      controller: cuisineTypeController,
                      hint: "Enter country",
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
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: config.color,
                                      child: Icon(
                                        config.icon,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: item.controller,
                                        decoration: InputDecoration(
                                          hintText: 'Link',
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
                                              25,
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
                            " Add Social Media",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: theme.secondaryHeaderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    SizedBox(
                      width: double.infinity,
                      child: SubmitButton(
                        onRightTap: () {
                          if (_key.currentState!.validate()) {
                            final businessModel = BusinessModel(
                              speciality: businessTypeController.text,
                              websiteDetails: websiteController.text,
                              cuisine: cuisineTypeController.text,
                            );
                            widget.authState.setBusinessDetails(businessModel);
                            Utils.navigateToPushScreen(
                              context,
                              PaymentTypeScreen(),
                            );
                          } else {
                            showCustomSnackBar(
                              context: context,
                              message: "Enter Business details",
                              color: Colors.red,
                            );
                          }
                        },
                        rightText: "Continue",
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    CustomOutlineButton(
                      title: "Skip",
                      onTap: () {
                        Utils.navigateToPushScreen(
                          context,
                          PaymentTypeScreen(),
                        );
                      },
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
    String? Function(String?)? validator,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    bool? readOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        autofocus: false,
        style: TextStyle(color: Colors.white70),
        cursorColor: Colors.white70,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
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
  }

  void _openSocialMediaSheet(BuildContext context) {
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
                    'Social Media',
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
                          const SizedBox(height: 6),
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
