import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authNotifierProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final error = ref.read(authNotifierProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: const GlassAppBar(title: 'Daftar Akun'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Buat Akun Baru',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Isi data diri Anda untuk mendaftar',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                FilledInput(
                  controller: _nameController,
                  hintText: 'Nama Lengkap',
                  prefixIcon: const Icon(
                    Symbols.person,
                    size: 20,
                    fill: 0,
                    weight: 300,
                    color: AppColors.onSurfaceVariant,
                  ),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                FilledInput(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Symbols.mail,
                    size: 20,
                    fill: 0,
                    weight: 300,
                    color: AppColors.onSurfaceVariant,
                  ),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                FilledInput(
                  controller: _phoneController,
                  hintText: 'Nomor Telepon',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(
                    Symbols.phone,
                    size: 20,
                    fill: 0,
                    weight: 300,
                    color: AppColors.onSurfaceVariant,
                  ),
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 16),
                FilledInput(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(
                    Symbols.lock,
                    size: 20,
                    fill: 0,
                    weight: 300,
                    color: AppColors.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Symbols.visibility_off : Symbols.visibility,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                FilledInput(
                  controller: _confirmPasswordController,
                  hintText: 'Konfirmasi Password',
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: const Icon(
                    Symbols.lock_reset,
                    size: 20,
                    fill: 0,
                    weight: 300,
                    color: AppColors.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Symbols.visibility_off : Symbols.visibility,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: 'Daftar',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    TextButtonWidget(
                      label: 'Masuk',
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
