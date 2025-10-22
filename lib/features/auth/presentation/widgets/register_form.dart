import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_button.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/social_auth_section.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/terms_checkbox.dart';

/// Register form widget
class RegisterForm extends StatefulWidget {
  final Function(String name, String email, String password) onRegister;
  final VoidCallback onGoogleRegister;
  final VoidCallback onFacebookRegister;
  final bool isLoading;

  const RegisterForm({
    super.key,
    required this.onRegister,
    required this.onGoogleRegister,
    required this.onFacebookRegister,
    this.isLoading = false,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.mustAgreeToTerms),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      widget.onRegister(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
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
            controller: _nameController,
            hintText: AppStrings.fullName,
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: Validators.validateName,
          ),
          const SizedBox(height: AppDimensions.space),
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
          const SizedBox(height: AppDimensions.space),
          AuthTextField(
            controller: _confirmPasswordController,
            hintText: AppStrings.confirmPassword,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: (value) => Validators.validateConfirmPassword(
              value,
              _passwordController.text,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          TermsCheckbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value;
              });
            },
          ),
          const SizedBox(height: AppDimensions.spaceL),
          AuthButton(
            onPressed: _handleRegister,
            text: AppStrings.register,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          SocialAuthSection(
            onGooglePressed: widget.onGoogleRegister,
            onFacebookPressed: widget.onFacebookRegister,
          ),
        ],
      ),
    );
  }
}
