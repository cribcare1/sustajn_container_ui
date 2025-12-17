import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/register_data.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';

class BankDetails extends ConsumerStatefulWidget {
  final RegistrationData registrationData;

  const BankDetails({
    super.key,
    required this.registrationData,
  });

  @override
  ConsumerState<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends ConsumerState<BankDetails> {
  final _formKey = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final accNoController = TextEditingController();
  final confirmAccController = TextEditingController();
  final taxController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    bankNameController.addListener(() => setState(() {}));
    accNoController.addListener(() => setState(() {}));
    confirmAccController.addListener(() => setState(() {}));
    taxController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    bankNameController.dispose();
    accNoController.dispose();
    confirmAccController.dispose();
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: Center(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.BANK_DETAILS,
                        style: theme?.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        Strings.ENTER_BANK_INFO,
                        style: theme?.textTheme.bodyMedium,
                      ),
                      SizedBox(height: height * 0.03),

                      TextFormField(
                        controller: bankNameController,
                        decoration: InputDecoration(
                          hintText: Strings.BANK_NAME,
                          hintStyle: theme!.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                            fontSize: Constant.LABEL_TEXT_SIZE_15,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return "Bank name required";
                          final valid = RegExp(r'^[a-zA-Z ]+$');
                          if (!valid.hasMatch(v)) {
                            return "Only letters and spaces allowed";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),

                      TextFormField(
                        controller: accNoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        decoration: InputDecoration(
                          hintText: Strings.ACC_NO,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                            fontSize: Constant.LABEL_TEXT_SIZE_15,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return "Account number required";
                          if (v.length != 12) {
                            return "Account number must be 12 digits";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.03),

                      TextFormField(
                        controller: confirmAccController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        decoration: InputDecoration(
                          hintText: Strings.CONFIRM_ACC_NO,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                            fontSize: Constant.LABEL_TEXT_SIZE_15,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Confirm account number required";
                          }
                          if (v.length != 12) {
                            return "Account number must be 12 digits";
                          }
                          if (v != accNoController.text) {
                            return "Account numbers do not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.03),

                      TextFormField(
                        controller: taxController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: Strings.TAX_NUMBER,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return "Tax number required";
                          if (v.length != 10) {
                            return "Tax number must be 10 digits";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),

                      authState.isLoading?Center(child: CircularProgressIndicator(),): SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD0A52C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.registrationData.bankName = bankNameController.text.trim();
                              widget.registrationData.accountNumber = accNoController.text.trim();
                              widget.registrationData.taxNumber = taxController.text.trim();

                              _getNetworkData(authState);
                            }

                          },
                          child: Text(
                            Strings.CONTINUE,
                            style:
                            theme!.textTheme.titleMedium!.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (authState.isLoading)
            Center(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }


  _getNetworkData(var containerState) async {
    try {
      await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable()
          .then((isNetworkAvailable) async {
        try {
          if (isNetworkAvailable) {
            containerState.setIsLoading(true);
            final Map<String, dynamic> body =
            Map<String, dynamic>.from(widget.registrationData.toApiBody());
            body.remove('image');
            ref.read(registerDetailProvider({
              "data": body,
            }));
          } else {
            containerState.setIsLoading(false);
            if(!mounted) return;
            showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          containerState.setIsLoading(false);
        }
        if(!mounted) return;
        FocusScope.of(context).unfocus();
      });
      // }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      containerState.setIsLoading(false);
    }
  }



}