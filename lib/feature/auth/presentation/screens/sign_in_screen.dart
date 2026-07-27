import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/asset_paths.dart';
import '../../../shared/utils/validators.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName='/sign_in';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const .only(top: 200.0, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Lottie.asset(
                  AssetPaths.logo,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  'aquanexis',
                  style: textTheme.titleLarge?.copyWith(
                    fontFamily: 'Arthaus',
                  ),
                ),
               ],),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _onTapForgotPassword,
                      child:  Text('Forgot Password'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _onTapSignIn,
                    child: const Text('Sign In'),
                  
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
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: 'and',
                      style: textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: ' Terms of Service',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
               ),
               const SizedBox(height: 20),
               RichText(text:  TextSpan(
                 text: 'Don\'t have an account? ',
                 style: textTheme.bodyMedium,
                 children: [
                   TextSpan(
                     text: 'Sign Up',
                     style: textTheme.labelSmall?.copyWith(
                       color: Colors.blue,
                     ),
                   ),

                 ],


               ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform sign-in logic here
      final email = _emailController.text;
      final password = _passwordController.text;
      // You can call your authentication API or service here
      print('Email: $email, Password: $password');
    }
  }

  void _onTapForgotPassword() {
  }
}