import 'package:flutter/material.dart';
import '../domain/auth_entities.dart';
import 'login_screen.dart';

/// Customer Login Screen - uses shared [LoginScreen] configured for [UserRole.customer].
class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(role: UserRole.customer);
  }
}
