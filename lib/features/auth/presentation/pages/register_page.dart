import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/register_form.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/text_link_row.dart';
import 'package:go_router/go_router.dart';

/// Register page
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void _handleRegister(
    BuildContext context,
    String name,
    String email,
    String password,
  ) {
    // TODO: Implement with Riverpod provider
    debugPrint('Register: $name, $email');
    
    // After successful registration, navigate to login or home
    // context.go('/login');
  }

  void _handleGoogleRegister(BuildContext context) {
    // TODO: Implement Google register
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đăng ký Google đang được phát triển'),
      ),
    );
  }

  void _handleFacebookRegister(BuildContext context) {
    // TODO: Implement Facebook register
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đăng ký Facebook đang được phát triển'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const AuthHeader(
                  title: AppStrings.createAccount,
                  subtitle: AppStrings.registerSubtitle,
                ),
                const SizedBox(height: AppDimensions.spaceXXL),
                RegisterForm(
                  onRegister: (name, email, password) =>
                      _handleRegister(context, name, email, password),
                  onGoogleRegister: () => _handleGoogleRegister(context),
                  onFacebookRegister: () => _handleFacebookRegister(context),
                ),
                const SizedBox(height: AppDimensions.spaceL),
                TextLinkRow(
                  text: AppStrings.haveAccount,
                  linkText: AppStrings.loginNow,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: AppDimensions.spaceL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
