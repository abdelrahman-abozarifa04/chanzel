// lib/features/onboarding/presentation/viewmodels/onboarding_view_model.dart

import 'package:flutter/material.dart';
import 'package:chanzel/features/onboarding/data/onboarding_data.dart';
import 'package:chanzel/features/onboarding/domain/models/onboarding_model.dart';

// ChangeNotifier allows the ViewModel to notify the UI of changes.
class OnboardingViewModel with ChangeNotifier {
  final PageController pageController = PageController();
  final List<OnboardingModel> pages = OnboardingData.pages;

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  bool get isLastPage => _currentPageIndex == pages.length - 1;

  String get buttonText => isLastPage ? 'Get Started' : 'Continue';

  void onPageChanged(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void nextPageOrComplete(BuildContext context) {
    if (isLastPage) {
      // Don't navigate automatically - let user choose login or signup
      // Navigation is now handled by the buttons in the UI
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
