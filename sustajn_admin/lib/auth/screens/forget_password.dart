import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/common_widgets/submit_button.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_provider/network_provider.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../auth_provider.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);
    final registrationState = ref.watch(authNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(

backgroundColor: theme!.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: theme!.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stack(
            children: [
              SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Constant.CONTAINER_SIZE_140),
                Text(
                  Strings.FORGOT_PASSWORD_TXT,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_10),
                Text(
                  Strings.ENTER_EMAIL_TORCV_CODE,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color!
                        .withOpacity(Constant.SIZE_065),
                    fontSize: Constant.LABEL_TEXT_SIZE_15,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_40),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white70),
                  cursorColor: Colors.white70,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: Strings.EMAIL,
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: theme.primaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      borderSide: BorderSide(color: Constant.grey),
                    ),
                    enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                    focusedBorder: CustomTheme.roundedBorder(Constant.grey),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter your email ID';
                    }
                    if (!v.contains('@')) {
                      return 'Enter a valid Gmail ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
              authState.isLoading?Center(child: CircularProgressIndicator(),):  SizedBox(
                  width: double.infinity,
                  height: Constant.CONTAINER_SIZE_45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD0A52C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      ),
                      side: const BorderSide(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _getNetworkData(registrationState);
                      }
                    },
                    child: Text(
                      Strings.CONTINUE_VERIFICATION,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }
  _getNetworkData(var registrationState) async {
    try {
      if (registrationState.isValid) {
        registrationState.setIsLoading(true);
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {

              ref.read(validateEmail({"email":_emailController.text,"previous":"forgotPassword"}));
            } else {
              registrationState.setIsLoading(false);
              if(!mounted) return;
              showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setIsLoading(false);
          }
          if(!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
    }
  }
}
