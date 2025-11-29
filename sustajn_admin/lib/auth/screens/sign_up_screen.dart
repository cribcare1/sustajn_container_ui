import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/card_widget.dart';
import '../../constants/string_utils.dart';
import 'map_selection_screen.dart';

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
  final _locationController = TextEditingController();

  UserType _selectedType = UserType.user;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
                        Expanded(
                          flex: 2,
                          child: RadioListTile<UserType>(
                            visualDensity: const VisualDensity(vertical: 0, horizontal: -4),
                            title: const Text('User'),
                            value: UserType.user,
                            groupValue: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val!);
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: themeData.primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: RadioListTile<UserType>(
                            visualDensity: const VisualDensity(vertical: 0, horizontal: -4),
                            title: const Text('Restaurant'),
                            value: UserType.restaurant,
                            groupValue: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val!);
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: themeData.primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: RadioListTile<UserType>(
                            visualDensity: const VisualDensity(vertical: 0, horizontal: -4),
                            title: const Text('Admin'),
                            value: UserType.admin,
                            groupValue: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val!);
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: themeData.primaryColor,
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
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
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
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
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

                    SizedBox(height: height * 0.02),
                    /// --- Location Field ---
                    TextFormField(
                      controller: _locationController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.map),
                          onPressed: _navigateToMap,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please select your location';
                        }
                        return null;
                      },
                      onTap: _navigateToMap,
                    ),
                    SizedBox(height: height * 0.03),

                    /// --- Sign Up Button ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  themeData.primaryColor,
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
                    SizedBox(height: height * 0.02),
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

  void _navigateToMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MapSelectionScreen(),
      ),
    );

    if (selectedLocation != null && mounted) {
      setState(() {
        _locationController.text = selectedLocation;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}