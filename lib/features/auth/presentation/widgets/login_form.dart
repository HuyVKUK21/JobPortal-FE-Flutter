import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_button.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/remember_me_checkbox.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/social_auth_section.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/text_link_row.dart';

/// Login form widget
class LoginForm extends StatefulWidget {
  final Function(String email, String password, bool rememberMe) onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onGoogleLogin;
  final VoidCallback onFacebookLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onGoogleLogin,
    required this.onFacebookLogin,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
        _rememberMe,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: _emailController,
            hintText: AppStrings.email,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: AppDimensions.space),
          AuthTextField(
            controller: _passwordController,
            hintText: AppStrings.password,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RememberMeCheckbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              ),
              TextButton(
                onPressed: widget.onForgotPassword,
                child: const Text(
                  AppStrings.forgotPassword,
                  style: TextStyle(
                    fontSize: AppDimensions.font,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          AuthButton(
            onPressed: _handleLogin,
            text: AppStrings.login,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          SocialAuthSection(
            onGooglePressed: widget.onGoogleLogin,
            onFacebookPressed: widget.onFacebookLogin,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          TextLinkRow(
            text: AppStrings.noAccount,
            linkText: AppStrings.registerNow,
            onPressed: widget.onSignUp,
          ),
        ],
      ),
    );
  }
}
