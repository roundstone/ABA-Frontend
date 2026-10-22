import 'package:flutter/material.dart';
import '../domain/auth_entities.dart';
import 'login_screen.dart';

/// Merchant Login Screen - uses shared [LoginScreen] configured for [UserRole.merchant].
class MerchantLoginScreen extends StatelessWidget {
  const MerchantLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(role: UserRole.merchant);
  }
}
