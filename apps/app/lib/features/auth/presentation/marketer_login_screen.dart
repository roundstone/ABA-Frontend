import 'package:flutter/material.dart';
import '../domain/auth_entities.dart';
import 'login_screen.dart';

/// Marketer Login Screen - uses shared [LoginScreen] configured for [UserRole.marketer].
class MarketerLoginScreen extends StatelessWidget {
  const MarketerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(role: UserRole.marketer);
  }
}
