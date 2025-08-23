import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chanzel/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:chanzel/features/auth/presentation/screens/login_screen.dart';
import 'package:chanzel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:chanzel/features/home/presentation/screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authViewModel.isAuthenticated) {
          // Check if profile is completed
          final userData = authViewModel.userData;
          if (userData != null && userData['profileCompleted'] == true) {
            return const HomeScreen();
          } else {
            // Profile not completed, redirect to complete profile
            return const CompleteProfileScreen();
          }
        } else {
          // Not authenticated, show login screen
          return const SignInScreen();
        }
      },
    );
  }
}
