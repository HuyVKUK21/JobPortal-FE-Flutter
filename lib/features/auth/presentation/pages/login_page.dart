import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_form.dart';
import 'package:go_router/go_router.dart';

/// Login page
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _handleLogin(
    BuildContext context,
    String email,
    String password,
    bool rememberMe,
  ) {
    // TODO: Implement with Riverpod provider
    debugPrint('Login: $email, Remember: $rememberMe');
    
    // After successful login, pop back to previous screen
    // context.pop();
  }

  void _handleForgotPassword(BuildContext context) {
    // TODO: Navigate to forgot password page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng quên mật khẩu đang được phát triển'),
      ),
    );
  }

  void _handleSignUp(BuildContext context) {
    context.pushNamed('register');
  }

  void _handleGoogleLogin(BuildContext context) {
    // TODO: Implement Google login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đăng nhập Google đang được phát triển'),
      ),
    );
  }

  void _handleFacebookLogin(BuildContext context) {
    // TODO: Implement Facebook login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đăng nhập Facebook đang được phát triển'),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        // Login successful, navigate back
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const AuthHeader(
                  title: AppStrings.welcomeBack,
                  subtitle: AppStrings.loginSubtitle,
                ),
                const SizedBox(height: AppDimensions.spaceXXL),
                LoginForm(
                  onForgotPassword: () => _handleForgotPassword(context),
                  onSignUp: () => _handleSignUp(context),
                  onGoogleLogin: () => _handleGoogleLogin(context),
                  onFacebookLogin: () => _handleFacebookLogin(context),
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
