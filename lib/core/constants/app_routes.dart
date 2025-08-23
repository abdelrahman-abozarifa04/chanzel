class AppRoutes {
  // Auth routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String completeProfile = '/completeProfile';
  static const String editProfile = '/editProfile';

  // Main app routes
  static const String home = '/home';
  static const String womansScreen = '/womans_screen';
  static const String mensScreen = '/mens_screen';
  static const String kidsScreen = '/kids_screen';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String settings = '/settings';
  static const String payment = '/payment';
  static const String addCard = '/add_card';
  static const String success = '/success';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String wishlist = '/wishlist';

  // Helper method to get all routes
  static List<String> get allRoutes => [
    splash,
    onboarding,
    signup,
    login,
    completeProfile,
    editProfile,
    home,
    womansScreen,
    mensScreen,
    kidsScreen,
    cart,
    checkout,
    settings,
    payment,
    addCard,
    success,
    orders,
    profile,
    search,
    wishlist,
  ];
}
