import 'package:aqua_nexis/feature/auth/presentation/screens/scan_device_id_screen.dart';
import 'package:aqua_nexis/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../shared/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName='/sign_up';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();
  late TapGestureRecognizer _signInRecognizer;
  @override
  void initState() {
    super.initState();
    _signInRecognizer = TapGestureRecognizer()..onTap = _onTapSignIn;
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const .symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                        Text(
                          'Create New Account',
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: 35,
                            color: AppColors.textColorDarkSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                         TextFormField(
                        controller: _emailController,
                          decoration:  InputDecoration(
                            hintText: 'Email',
                            hintStyle: textTheme.labelMedium,
                          ),
                          validator: (String? value)=>Validators.validateEmail(value),
                        ),
                          const SizedBox(height: 20),
                         TextFormField(
                        controller: _fullNameController,
                          decoration:  InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: textTheme.labelMedium,
                          ),
                          validator: (String? value)=>Validators.validateInput(value,"Please enter your full name"),
                        ),
                         const SizedBox(height: 20),
                         TextFormField(
                        controller: _phoneNumberController,
                          decoration:  InputDecoration(
                            hintText: 'Phone ',
                            hintStyle: textTheme.labelMedium,
                          ),
                          validator: (String? value)=>Validators.validateInput(value,"Please enter your phone number"),
                        ),
                        const SizedBox(height: 20),
                         TextFormField(
                        controller: _deviceIdController,
                          decoration:  InputDecoration(
                            hintText: 'Device ID',
                            hintStyle: textTheme.labelMedium,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: _onScanQRCode,
                            ),
                          ),
                          validator: (String? value)=>Validators.validateInput(value,"Please enter your device ID"),
                         
                        ),
                         const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          
                          decoration:  InputDecoration(
                            suffixIcon: IconButton(
                            icon:  Icon(Icons.visibility_off),
                            onPressed: () {
                              // Toggle password visibility
                            },
                          ),
                            hintText: 'Password',
                            hintStyle: textTheme.labelMedium,
                          ),
                          validator: (String? value)=>Validators.validatePassword(value),
                        ),
                         const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          
                          decoration:  InputDecoration(
                            suffixIcon: IconButton(
                            icon:  Icon(Icons.visibility_off),
                            onPressed: () {
                              // Toggle password visibility
                            },
                          ),
                            hintText: 'Confirm Password',
                            hintStyle: textTheme.labelMedium,
                          ),
                          validator: (String? value)=>Validators.validateConfirmPassword(value, _passwordController.text),
                        ),
                         const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _onTapSignUp,
                          child: const Text('Sign Up'),
                        
                     ),
                     const SizedBox(height: 8),
                     RichText(
                      text: TextSpan(
                        text: 'By continuing you accept out  ',
                        style: textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Privacy Policy ',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.textColorDarkSecondary,
                            ),
                          ),
                          TextSpan(
                            text: 'and',
                            style: textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: ' Terms of Service',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.textColorDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                     ),
                     const SizedBox(height: 20),
                     RichText(
                       text: TextSpan(
                         text: 'Don\'t have an account? ',
                         style: textTheme.bodyMedium,
                         children: [
                           TextSpan(
                             text: 'Sign In',
                             style: textTheme.labelSmall?.copyWith(
                               color: AppColors.textColorDarkSecondary,
                             ),
                             recognizer: _signInRecognizer,
                           ),
                         ],
                       ),
                     )
        
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  

  
  Future<void> _onScanQRCode() async{
    final scannedDeviceId = await Navigator.pushNamed<String>(context, ScanDeviceIdScreen.routeName);
     if (!mounted || scannedDeviceId == null || scannedDeviceId.isEmpty) return;

  setState(() {
    _deviceIdController.text = scannedDeviceId;
  });
  }

  void _onTapSignUp() {
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _deviceIdController.dispose();
    _signInRecognizer.dispose();
    super.dispose();
  }
  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}