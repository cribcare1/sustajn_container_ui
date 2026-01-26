import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/app_loading.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';

import '../../constants/imports_util.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/utility.dart';
import '../model/payment_type_model.dart';
import '../model/social_media_model.dart';

class TermsAndConditionScreen extends ConsumerStatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  ConsumerState<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState
    extends ConsumerState<TermsAndConditionScreen> {
  late Future<String> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = _loadTermsFromAssets();
  }

  Future<String> _loadTermsFromAssets() async {
    return await rootBundle
        .loadString('assets/note/terms_condition.txt');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signUpState = ref.watch(authNotifierProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CustomAppBar(title: 'Terms & Conditions',
            leading: CustomBackButton()).getAppBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_20,
                      ),
                      child: FutureBuilder<String>(
                        future: _termsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Constant.gold,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Text(
                              "Failed to load terms & conditions",
                              style: TextStyle(color: Colors.red),
                            );
                          }

                          return Text(
                            snapshot.data ?? '',
                            textAlign: TextAlign.justify,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              height: Constant.SIZE_1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUpState.isLoading
                            ? null
                            : () async {
                          final confirmed = await termsDialog(
                            context,
                            Icons.warning_amber_outlined,
                            Strings.CONFIRM_ACCOUNT,
                            Strings.CONFIRM_MESSAGE,
                            Strings.CANCEL,
                            Strings.CREATE,
                          );

                          if (confirmed == true) {
                            _getNetworkData(signUpState);
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_20,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: Constant.CONTAINER_SIZE_16,
                          ),
                        ),
                        child: Text(
                          "Agree & Create Account",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if(signUpState.isLoading)
                Center(
                  child:CircularProgressIndicator(
                    color: Constant.gold,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  termsDialog(
      BuildContext context,
      IconData icon,
      String title,
      String subTitle,
      String cancelButton,
      String createButton
      ) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: Constant.PADDING_HEIGHT_10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              //   decoration: BoxDecoration(
              //       color: Constant.grey.withOpacity(0.2),
              //       shape: BoxShape.rectangle,
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //           color: Constant.grey.withOpacity(0.1)
              //       )
              //   ),
              //   child: Icon(
              //     icon,
              //     size: Constant.CONTAINER_SIZE_40,
              //     color: Constant.gold,
              //   ),
              // ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  decoration: BoxDecoration(
                    color: Constant.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Constant.grey.withOpacity(0.1),
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: Constant.CONTAINER_SIZE_40,
                    color: Constant.gold,
                  ),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    height: Constant.SIZE_2,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: Constant.SIZE_05),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  height: Constant.SIZE_2,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);

                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Constant.gold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        cancelButton,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Constant.gold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_12),

                  // STAY
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        createButton,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
  }

  Map<String, dynamic> removeNullAndEmpty(Map<String, dynamic> map) {
    final cleanedMap = <String, dynamic>{};

    map.forEach((key, value) {
      if (value == null) return;

      if (value is Map) {
        final nested = removeNullAndEmpty(
          Map<String, dynamic>.from(value),
        );

        cleanedMap[key] = nested;
      }
      else {
        cleanedMap[key] = value;
      }
    });

    return cleanedMap;
  }

  _getPayload(AuthState authState){
    print(authState.registrationData!.address);
    print(authState.socialMediaList);
    // print(authState.gateway??authState.gateway!.toJson());
    final address = authState.registrationData!.address!;
    final parts = address.split(',').map((e) => e.trim()).toList();

    final country = parts.isNotEmpty ? parts.last : "";
    final postalCode = parts.length >= 2 ? parts[parts.length - 2] : "";
    final addressDetails = parts.length > 2
        ? parts.sublist(0, parts.length - 2).join(', ')
        : "";

    Map<String, dynamic> mapData = {
      "fullName": authState.registrationData!.fullName,
      "email": authState.registrationData!.email,
      "phoneNumber": authState.registrationData!.phoneNumber,
      "password": authState.registrationData!.password,
      "dateOfBirth": "",
      "subscriptionPlanId":authState.planId,
      "address": {
        "addressType": "",
        "flatDoorHouseDetails": addressDetails,
        "areaStreetCityBlockDetails": "$addressDetails,$country",
        "poBoxOrPostalCode": postalCode,
        // "country": country,
      },
      "latitude": authState.registrationData!.latitude,
      "longitude": authState.registrationData!.longitude,
      // "image": authState.registrationData!.image,
      if(authState.businessModel != null)
        "basicDetails": authState.businessModel!.toJson(),
      "bankDetails": authState.bankDetails!.toJson(),
      "socialMediaList": authState.socialMediaList.isEmpty
          ? []
          : authState.socialMediaList.map((e) => e.toJson()).toList(),
      "cardDetails": authState.cardDetails?.toJson() ?? CardDetails().toJson(),
    "contactAndRegistrationDetails":authState.registrationDetailsData?.toJson()??ContactAndRegistrationDetails().toJson(),
      "paymentGetWay": () {
        final map = (authState.gateway ?? PaymentGatewayModel()).toJson();
        map.remove('asset');
        return map;
      }(),
    };

    return mapData;
  }

  Future<void> _getNetworkData(AuthState registrationState) async {
    try {
      registrationState.setIsLoading(true);
      FocusScope.of(context).unfocus();

      if(registrationState.isValid) {
        Map<String, dynamic> mapData = _getPayload(registrationState);
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((isNetworkAvailable) {
          Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
          setState(() {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);

              ref.read(registerProvider(mapData));
            } else {
              registrationState.setIsLoading(false);
              Utils.showToast(Strings.NO_INTERNET_CONNECTION);
            }
          });
        });
      }else {
        Utils.showToast("Not valid data for Registration");
      }
    } catch (e) {
      Utils.printLog('Error in Login button: $e');
    }finally{
      registrationState.setIsLoading(false);
    }
  }
}
