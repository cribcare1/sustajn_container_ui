import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';

import 'package:sustajn_customer/constants/string_utils.dart';
import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../models/register_data.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/signup_provider.dart';
import '../../utils/utils.dart';

class TermsconditionScreen extends ConsumerStatefulWidget {
  const TermsconditionScreen({super.key});

  @override
  ConsumerState<TermsconditionScreen> createState() =>
      _TermsconditionScreenState();
}

class _TermsconditionScreenState extends ConsumerState<TermsconditionScreen> {

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
    final signUpState = ref.watch(signUpNotifier);
    RegistrationData? registrationData = signUpState.registrationData;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CustomAppBar(title: 'Terms & Conditions',
          leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
          Column(
            children: [

              // Padding(
              //   padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         icon: Icon(
              //           Icons.arrow_back,
              //           color: Colors.white,
              //           size: Constant.CONTAINER_SIZE_26,
              //         ),
              //         onPressed: () => Navigator.pop(context),
              //       ),
              //       SizedBox(width: Constant.SIZE_06),
              //       Text(
              //         "Terms & Conditions",
              //         style: theme.textTheme.headlineSmall?.copyWith(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

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
                          child: CircularProgressIndicator(),
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          height: Constant.CONTAINER_SIZE_1,
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
                child:CircularProgressIndicator(),
              )
    ],
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
            children: [
              Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                decoration: BoxDecoration(
                    color: Constant.grey.withOpacity(0.2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Constant.grey.withOpacity(0.1)
                    )
                ),
                child: Icon(
                  icon,
                  size: Constant.CONTAINER_SIZE_40,
                  color: Constant.gold,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white
              )),
              SizedBox(height: Constant.SIZE_05),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white
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
        if (nested.isNotEmpty) {
          cleanedMap[key] = nested;
        }
      } else if (value.toString().trim().isNotEmpty) {
        cleanedMap[key] = value;
      }
    });

    return cleanedMap;
  }

  _getNetworkData(var registrationState) async {
    try {
      if(registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((isNetworkAvailable) {
          Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
          setState(() {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              final Map<String, dynamic> rawBody =
              Map<String, dynamic>.from(registrationState.registrationData.toApiBody());
              final body = removeNullAndEmpty(rawBody);
              final params = Utils.multipartParams(
                  NetworkUrls.REGISTER_USER, body,
                  Strings.DATA, registrationState.registrationData.profileImage);
              ref.read(registerProvider(params));
            } else {
              registrationState.setIsLoading(false);
              Utils.showToast(Strings.NO_INTERNET_CONNECTION);
            }
          });
        });
      }
    } catch (e) {
      Utils.printLog('Error in registration button onPressed: $e');
    }
  }
}

