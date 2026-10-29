import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/dialog_utils.dart';
import '../../navigation/route_names.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemo(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      DialogUtils.showSnackBar(context, 'Successfully signed in!');
      if (auth.isAdmin) {
        Navigator.pushReplacementNamed(context, RouteNames.adminDashboard);
      } else if (auth.isDoctor) {
        Navigator.pushReplacementNamed(context, RouteNames.doctorDashboard);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.mainShell);
      }
    } else {
      DialogUtils.showSnackBar(
        context,
        auth.errorMessage ?? 'Login failed. Please check credentials.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand / Logo
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(Icons.local_hospital_rounded,
                            size: 36, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Khushi Hygieia',
                    textAlign: TextAlign.center,
                    style: AppTypography.heading1.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Access your unified healthcare platform',
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle,
                  ),
                  const SizedBox(height: 32),

                  // Form Fields
                  AppTextField(
                    label: 'Email Address',
                    hint: 'rahul@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined,
                        size: 20, color: AppColors.textMuted),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter email';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteNames.forgotPassword),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter password' : null,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          size: 20, color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Doctor note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🩺', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Are you a Doctor? Sign in with your registered account or switch to Doctor Demo below.',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign In Button
                  AppButton(
                    label: 'Sign In',
                    isLoading: auth.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),

                  // Quick Demo Accounts Section
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Quick Demo Access',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            ActionChip(
                              backgroundColor: AppColors.infoLight,
                              label: const Text('Patient Demo',
                                  style: TextStyle(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              onPressed: () => _fillDemo(
                                  AppConstants.demoPatientEmail,
                                  AppConstants.demoPassword),
                            ),
                            ActionChip(
                              backgroundColor: AppColors.successLight,
                              label: const Text('Doctor Demo',
                                  style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              onPressed: () => _fillDemo(
                                  AppConstants.demoDoctorEmail,
                                  AppConstants.demoPassword),
                            ),
                            ActionChip(
                              backgroundColor: const Color(0xFFF3E8FF),
                              label: const Text('Admin Demo',
                                  style: TextStyle(
                                      color: Color(0xFF7E22CE),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              onPressed: () => _fillDemo(
                                  AppConstants.demoAdminEmail,
                                  AppConstants.demoPassword),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Switch to Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, RouteNames.signup),
                        child: const Text(
                          'Create one',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
