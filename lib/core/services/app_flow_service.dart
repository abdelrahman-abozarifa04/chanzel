/*
 * Copyright (c) 2025 Abdelrahman Sami. All rights reserved.
 * 
 * This application is the property of Abdelrahman Sami.
 * Unauthorized copying, distribution, or modification of this application
 * is strictly prohibited.
 */

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chanzel/core/services/logger_service.dart';
import 'package:chanzel/core/constants/app_routes.dart';

class AppFlowService {
  static const String _firstTimeKey = 'is_first_time';

  // Check if this is the user's first time opening the app
  static Future<bool> isFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_firstTimeKey) ?? true;
    } catch (e) {
      Logger.error('Error checking first time status: $e', error: e);
      return true; // Default to first time if there's an error
    }
  }

  // Mark that the user has completed onboarding
  static Future<void> markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstTimeKey, false);
    } catch (e) {
      Logger.error('Error marking onboarding completed: $e', error: e);
    }
  }

  // Check if user is authenticated
  static bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  // Get the appropriate route based on user status
  static Future<String> getInitialRoute() async {
    final isFirstTimeUser = await isFirstTime();
    final isAuthenticated = isUserAuthenticated();

    Logger.info(
      'isFirstTimeUser: $isFirstTimeUser, isAuthenticated: $isAuthenticated',
    );

    if (isFirstTimeUser) {
      // First time user: splash -> onboarding -> signup -> home
      Logger.info('First time user, navigating to onboarding');
      return AppRoutes.onboarding;
    } else if (isAuthenticated) {
      // Returning authenticated user: splash -> home
      Logger.info('Returning authenticated user, navigating to home');
      return AppRoutes.home;
    } else {
      // Returning non-authenticated user: splash -> login -> home
      Logger.info('Returning non-authenticated user, navigating to login');
      return AppRoutes.login;
    }
  }

  // Reset first time status (useful for testing or logout)
  static Future<void> resetFirstTimeStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstTimeKey, true);
    } catch (e) {
      Logger.error('Error resetting first time status: $e', error: e);
    }
  }
}
