import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sustajn_restaurant/auth/screens/sign_up_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import 'business_information.dart';
import 'forget_password.dart';

class BankDetails extends StatefulWidget {
  final int currentStep;
  const BankDetails({super.key, this.currentStep=1});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final _formKey = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final accNoController = TextEditingController();
  final confirmAccController = TextEditingController();
  final taxController = TextEditingController();

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
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
                  Row(
                    children: List.generate(4, (index) {
                      bool active = index <= widget.currentStep;
                      return Expanded(
                        child: Container(
                          height: Constant.SIZE_05,
                          margin: EdgeInsets.only(right: index == 3 ? 0 : Constant.SIZE_10),
                          decoration: BoxDecoration(
                            color: active
                                ? theme!.primaryColor
                                : theme!.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(Constant.SIZE_10),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_20),
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
                      labelText: Strings.BANK_NAME,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) return "Bank name required";
                      final valid = RegExp(r'^[a-zA-Z ]+$');
                      if (!valid.hasMatch(v)) return "Only letters and spaces allowed";
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
                      labelText: Strings.ACC_NO,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) return "Account number required";
                      if (v.length != 12) return "Account number must be 12 digits";
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
                      labelText: Strings.CONFIRM_ACC_NO,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) return "Confirm account number required";
                      if (v.length != 12) return "Account number must be 12 digits";
                      if (v != accNoController.text) return "Account numbers do not match";
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
                      if (v.length != 10) return "Tax number must be 10 digits";
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
              
                  SizedBox(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> BusinessScreen())
                          );
                        }
                      },
                      child: Text(
                        Strings.CONTINUE,
                        style: theme!.textTheme.titleMedium!.copyWith(
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
    );
  }
}
