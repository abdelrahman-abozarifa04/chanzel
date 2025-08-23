// lib/data/onboarding_data.dart

import 'package:chanzel/features/onboarding/domain/models/onboarding_model.dart';
import 'package:chanzel/core/constants/app_images.dart';

class OnboardingData {
  // Static list accessible from anywhere
  static final List<OnboardingModel> pages = [
    OnboardingModel(
      title: "Welcome to Your Dream Closet",
      description:
          "Discover the latest trends and timeless classics. We've curated the best styles and brands just for you. Your next favorite outfit is just a tap away.",
      imagePath: ImagesManger.fashion,
    ),
    OnboardingModel(
      title: "Style, Personalized for You",
      description:
          " Take our quick style quiz and get recommendations tailored to your unique taste, size, and preferences. Say goodbye to endless scrolling and hello to personalized picks.",
      imagePath: ImagesManger.stylish,
    ),
    OnboardingModel(
      title: "Easy & Secure Checkout",
      description:
          "Shop with confidence. Our streamlined checkout process is simple, fast, and secure. Plus, enjoy hassle-free returns on every order.",
      imagePath: ImagesManger.visa_card,
    ),
  ];
}
