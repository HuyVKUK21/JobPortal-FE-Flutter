import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/widgets/radio_option_card.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _selectedMethod = 'sms'; // 'sms' or 'email'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          AppStrings.forgotPasswordTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Illustration
                Image.asset(
                  'assets/forgot_password_illustration.png',
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 100,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Description
                Text(
                  AppStrings.selectResetMethod,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // SMS Option
                RadioOptionCard(
                  icon: Icons.sms_outlined,
                  title: AppStrings.viaSMS,
                  subtitle: '+1 111 ****99',
                  isSelected: _selectedMethod == 'sms',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'sms';
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Email Option
                RadioOptionCard(
                  icon: Icons.email_outlined,
                  title: AppStrings.viaEmail,
                  subtitle: 'and***ley@yourdomain.com',
                  isSelected: _selectedMethod == 'email',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'email';
                    });
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to OTP verification
                      context.pushNamed(
                        'otpVerification',
                        extra: {
                          'method': _selectedMethod,
                          'contact': _selectedMethod == 'sms' 
                              ? '+1 111 ****99' 
                              : 'and***ley@yourdomain.com',
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      AppStrings.continueButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
