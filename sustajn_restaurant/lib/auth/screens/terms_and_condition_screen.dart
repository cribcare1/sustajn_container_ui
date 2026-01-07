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
                          _getNetworkData(authState);
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

  Future<void> _getNetworkData(AuthState registrationState) async {
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
      Map<String, dynamic> mapData = {
        "fullName": registrationState.registrationData!.fullName,
        "email": registrationState.registrationData!.email,
        "phoneNumber": registrationState.registrationData!.phoneNumber,
        "password": registrationState.registrationData!.password,
        "dateOfBirth": "",
        "address": registrationState.registrationData!.address,
        "latitude": registrationState.registrationData!.latitude,
        "longitude": registrationState.registrationData!.longitude,
        "image": registrationState.registrationData!.image,
        "basicDetails": registrationState.businessModel!.toJson(),
        "bankDetails": registrationState.bankDetails!.toJson(),
        "socialMediaList": registrationState.socialMediaList.isEmpty
            ? []
            : registrationState.socialMediaList,
      };
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
