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
    return await rootBundle.loadString('assets/note/terms_condition.txt');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Terms & Conditions",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_20,
                ),
                child: FutureBuilder<String>(
                  future: _termsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Text(
                        "Failed to load terms & conditions",
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    return Text(
                      snapshot.data ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: Constant.SIZE_01,
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
              child: authState.isLoading
                  ? Center(child: AppLoading())
                  : SizedBox(
                      width: double.infinity,
                      child: SubmitButton(
                        onRightTap: () {
                          print(authState.registrationData!.address);
                          print(authState.socialMediaList);
                          print(authState.gateway!.toJson());
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
                            "image": authState.registrationData!.image,
                            "basicDetails": authState.businessModel!.toJson(),
                            "bankDetails": authState.bankDetails!.toJson(),
                            "socialMediaList": authState.socialMediaList.isEmpty
                                ? []
                                : authState.socialMediaList.map((e) => e.toJson()).toList(),
                            "cardDetails": authState.cardDetails?.toJson() ?? CardDetails().toJson(),

                            "paymentGetWay": () {
                              final map = (authState.gateway ?? PaymentGatewayModel()).toJson();
                              map.remove('asset');
                              return map;
                            }(),
                          };
                          print("========= $mapData ==========");
                          _getNetworkData(authState, mapData);
                        },
                        rightText: "Agree & Create Account",
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getNetworkData(AuthState registrationState, Map<String, dynamic> mapData ) async {
    try {
      registrationState.setIsLoading(true);
      FocusScope.of(context).unfocus();
      final isNetworkAvailable = await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable();
      if (!isNetworkAvailable) {
        if (!mounted) return;
        showCustomSnackBar(
          context: context,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
        return;
      }
      ref.read(registerProvider(mapData).future).then((value) {
        if (!mounted) return;

        if (value.status != null &&
            value.status?.toLowerCase() == Strings.SUCCESS) {
          showCustomSnackBar(
            context: context,
            message: Strings.USER_REGISTERED_SUCCESS,
            color: Colors.green,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        } else {
          Utils.showToast(value.message ?? "Registration failed");
        }
      });
    } catch (e) {
      Utils.printLog('Error in Login button: $e');
    }finally{
      registrationState.setIsLoading(false);
    }
  }
}
