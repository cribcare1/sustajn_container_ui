import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/subscription_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import 'forget_password.dart';

class BusinessScreen extends StatefulWidget {
  final int currentStep;
  const BusinessScreen({super.key, this.currentStep=2});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final specialityController = TextEditingController();
  final cuisineController = TextEditingController();
  final websiteController = TextEditingController();


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
                    Strings.BUSINESS_INFO,
                    style: theme?.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    Strings.PROVIDE_INFOR,
                    style: theme?.textTheme.bodyMedium,
                  ),
                  SizedBox(height: height * 0.03),
                  TextFormField(
                    controller: specialityController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: Strings.SPECIALITY,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),

                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: cuisineController,
                    decoration: InputDecoration(
                      labelText: Strings.CUISINE,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  TextFormField(
                    controller: websiteController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: Strings.WEBSITE,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),

                  ),
                  SizedBox(height: height * 0.04),
                  Center(
                    child: Text(
                      Strings.ADD_SOCIAL_MEDIA,
                      style: theme!.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),

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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> SubscriptionScreen()));
                      },
                      child: Text(
                        Strings.CONTINUE,
                        style: theme!.textTheme.titleMedium!.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Color(0xFFD0A52C)
                        ),
                        backgroundColor: theme.scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> SubscriptionScreen()));
                      },
                      child: Text(
                        Strings.SKIP,
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