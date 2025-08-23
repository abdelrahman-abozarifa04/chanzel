import 'package:chanzel/core/constants/app_images.dart';
import 'package:chanzel/core/services/app_flow_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for splash screen
    Future.delayed(const Duration(seconds: 6), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    try {
      final route = await AppFlowService.getInitialRoute();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      print('Error determining navigation route: $e');
      // Fallback to onboarding if there's an error
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(ImagesManger.splash_bottom),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(ImagesManger.splash_top),
          ),
          Center(
            child: SvgPicture.asset(
              ImagesManger.splash_center,
              width: 340,
              height: 340,
            ),
          ),
          // Copyright footer
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  '© 2025 Abdelrahman Sami',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'All rights reserved',
                  style: TextStyle(fontSize: 10, color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
