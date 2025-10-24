import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/register_form.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/text_link_row.dart';
import 'package:go_router/go_router.dart';

/// Register page
class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  void _handleRegister(
    BuildContext context,
    WidgetRef ref,
    String firstName,
    String lastName,
    String email,
    String phone,
    String password,
  ) async {
    // Register as job seeker by default
    await ref.read(authProvider.notifier).registerJobSeeker(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
    );

    // Check if registration was successful
    final authState = ref.read(authProvider);
    if (!authState.isLoading && authState.error == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Go back to login page
      }
    } else if (authState.error != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
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
                  onRegister: (firstName, lastName, email, phone, password) =>
                      _handleRegister(context, ref, firstName, lastName, email, phone, password),
                  onGoogleRegister: () => _handleGoogleRegister(context),
                  onFacebookRegister: () => _handleFacebookRegister(context),
                  isLoading: authState.isLoading,
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
