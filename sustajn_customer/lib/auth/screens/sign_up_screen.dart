import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/card_widget.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import 'login_screen.dart';

enum UserType { user, restaurant, admin }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserType _selectedType = UserType.user;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var themeData = CustomTheme.getTheme(true);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Center(
          child: SummaryCard(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Strings.SIGN_UP,
                      style: themeData!.textTheme.titleLarge,
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(flex: 2,
                          child: RadioListTile<UserType>(
                            visualDensity: VisualDensity(vertical: 0,horizontal: -4),
                            title: const Text('User'),
                            value: UserType.user,
                            groupValue: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val!);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(flex: 3,
                          child: RadioListTile<UserType>(
                            visualDensity: VisualDensity(vertical: 0,horizontal: -4),
                            title: const Text('Restaurant'),
                            value: UserType.restaurant,
                            groupValue: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val!);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: RadioListTile<UserType>(
                            visualDensity: VisualDensity(vertical: 0,horizontal: -4),
                            title: const Text('Admin'),
                            value: UserType.admin,
                            groupValue: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val!);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    /// --- Name Field ---
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    /// --- Mobile Number Field ---
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your mobile number';
                        }
                        if (v.length != 10) {
                          return 'Enter a valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    /// --- Email Field ---
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your email';
                        }
                        if (!v.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    /// --- Password Field ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter your password';
                        }
                        if (v.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    /// --- Confirm Password Field ---
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Confirm your password';
                        }
                        if (v != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.03),

                    /// --- Sign Up Button ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeData.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Registered as ${_selectedType.name.toUpperCase()}'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        Strings.SIGN_UP,
                        style: themeData.textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: height*0.02),
                    Text.rich(
                      TextSpan(
                        text: "Already have Account? ",
                        style: const TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: Strings.LOGIN,
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
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
          ),
        ),
      ),
    );
  }
}
