// lib/features/onboarding/presentation/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:chanzel/features/onboarding/presentation/viewmodels/onboarding_view_model.dart';
import 'package:chanzel/features/onboarding/presentation/widgets/onboarding_page_content.dart';
import 'package:chanzel/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/core/constants/app_fonts.dart';
import 'package:chanzel/core/services/app_flow_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _viewModel.pageController,
                  itemCount: _viewModel.pages.length,
                  onPageChanged: _viewModel.onPageChanged,
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(page: _viewModel.pages[index]);
                  },
                ),
              ),
              OnboardingPageIndicator(
                pageCount: _viewModel.pages.length,
                currentPageIndex: _viewModel.currentPageIndex,
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.naiveColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (_viewModel.isLastPage) {
                    // Mark onboarding as completed for first-time users
                    print('OnboardingScreen: Marking onboarding as completed');
                    await AppFlowService.markOnboardingCompleted();
                    print(
                      'OnboardingScreen: Onboarding completed, navigating to signup',
                    );
                    // Navigate directly to signup screen on last page
                    Navigator.pushReplacementNamed(context, '/signup');
                  } else {
                    // Continue to next page
                    _viewModel.nextPageOrComplete(context);
                  }
                },
                child: Text(
                  _viewModel.buttonText,
                  style: TextStyles.white20medium,
                ),
              ),
              const SizedBox(height: 20),
              // Remove the login/signup options - only show Get Started button on last page
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
