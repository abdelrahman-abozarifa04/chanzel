import 'package:chanzel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:chanzel/features/home/presentation/screens/home_screen.dart';
import 'package:chanzel/features/auth/presentation/screens/login_screen.dart';
import 'package:chanzel/features/home/presentation/screens/kids.dart';
import 'package:chanzel/features/home/presentation/screens/mens.dart';
import 'package:chanzel/features/home/presentation/screens/womans_screen.dart';
import 'package:chanzel/features/home/presentation/screens/card_screen.dart';
import 'package:chanzel/features/home/presentation/screens/checkout_screen.dart';
import 'package:chanzel/features/home/presentation/screens/settings_screen.dart';
import 'package:chanzel/features/home/presentation/screens/payment_screen.dart';
import 'package:chanzel/features/home/presentation/screens/addcard_screen.dart';
import 'package:chanzel/features/home/presentation/screens/scsses_screen.dart';
import 'package:chanzel/features/home/presentation/screens/orders_screen.dart';
import 'package:chanzel/features/home/presentation/screens/profile_screen.dart';
import 'package:chanzel/features/home/presentation/screens/search_screen.dart';
import 'package:chanzel/features/home/presentation/screens/wishlist_screen.dart';
import 'package:chanzel/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:chanzel/features/auth/presentation/screens/signup_screen.dart';
import 'package:chanzel/features/auth/presentation/screens/splash_screen.dart';
import 'package:chanzel/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:chanzel/firebase_options.dart';
import 'package:chanzel/core/services/theme_service.dart';
import 'package:chanzel/core/services/logger_service.dart';
import 'package:chanzel/core/theme/app_theme.dart';
import 'package:chanzel/core/constants/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
 * Copyright (c) 2025 Abdelrahman Sami. All rights reserved.
 * 
 * This application is the property of Abdelrahman Sami.
 * Unauthorized copying, distribution, or modification of this application
 * is strictly prohibited.
 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Logger.info('Firebase initialized successfully');
  } catch (e) {
    Logger.critical('Firebase initialization error: $e', error: e);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chanzel',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            home: const SplashScreen(),
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.onboarding: (context) => const OnboardingScreen(),
              AppRoutes.signup: (context) => const SignUpScreen(),
              AppRoutes.completeProfile: (context) =>
                  const CompleteProfileScreen(),
              AppRoutes.editProfile: (context) =>
                  const CompleteProfileScreen(isEditing: true),
              AppRoutes.login: (context) => const SignInScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
              AppRoutes.womansScreen: (context) => const WomenProductsScreen(),
              AppRoutes.mensScreen: (context) => const MenProductsScreen(),
              AppRoutes.kidsScreen: (context) => const KidsProductsScreen(),
              AppRoutes.cart: (context) => const MyCartScreen(),
              AppRoutes.checkout: (context) => const CheckoutScreen(),
              AppRoutes.settings: (context) => const SettingsScreen(),
              AppRoutes.payment: (context) => const PaymentMethodsScreen(),
              AppRoutes.addCard: (context) => const AddCardScreen(),
              AppRoutes.success: (context) => const SuccessScreen(),
              AppRoutes.orders: (context) => const OrdersScreen(),
              AppRoutes.profile: (context) => const ProfileScreen(),
              AppRoutes.search: (context) => const SearchScreen(),
              AppRoutes.wishlist: (context) => const WishlistScreen(),
            },
          );
        },
      ),
    );
  }
}
