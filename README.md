# 🛍️ Chanzel - Modern E-commerce Flutter App

<div align="center">

![Chanzel Logo](assets/images/chanzel_logo.jpg)

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-00D4AA?style=for-the-badge&logo=architecture&logoColor=white)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**A sophisticated Flutter e-commerce application built with modern architecture principles**

[🚀 Features](#-features) • [🏗️ Architecture](#️-architecture) • [📱 Screenshots](#-screenshots) • [🛠️ Tech Stack](#️-tech-stack) • [🚀 Getting Started](#-getting-started) • [📁 Project Structure](#-project-structure)

</div>

---

## ✨ Overview

**Chanzel** is a premium e-commerce mobile application that demonstrates industry best practices in Flutter development. Built with clean architecture principles, this app showcases modern mobile app development techniques while providing a seamless shopping experience.

### 🎯 **Key Highlights**
- 🏗️ **Clean Architecture** - Separation of concerns with Domain, Data, and Presentation layers
- 🔐 **Firebase Integration** - Authentication, real-time database, and cloud services
- 📱 **Cross-Platform** - Single codebase for iOS and Android
- 🎨 **Modern UI/UX** - Beautiful, responsive design with smooth animations
- 🚀 **Performance Optimized** - Efficient state management and lazy loading
- 🧪 **Testable Code** - Well-structured codebase with dependency injection

---

## 🚀 Features

### 🛍️ **E-commerce Functionality**
- **Product Catalog** - Browse products by category (Men, Women, Kids)
- **Smart Search** - Advanced product search with filters
- **Shopping Cart** - Persistent cart with local storage
- **Wishlist** - Save favorite products for later
- **Order Management** - Track orders and order history
- **Payment Integration** - Secure payment processing
- **User Profiles** - Personalized shopping experience

### 🔐 **Authentication & Security**
- **Firebase Auth** - Secure user authentication
- **Profile Management** - Complete user profile setup
- **Session Management** - Persistent login sessions
- **Data Privacy** - Secure data handling

### 🎨 **User Experience**
- **Onboarding Flow** - Guided app introduction
- **Responsive Design** - Works on all screen sizes
- **Dark/Light Theme** - Customizable app appearance
- **Smooth Animations** - Polished user interactions
- **Offline Support** - Basic offline functionality

---

## 🏗️ Architecture

### **Clean Architecture Implementation**

```
📱 Presentation Layer (UI)
├── 🎨 Screens & Widgets
├── 🔄 ViewModels
└── 📋 State Management

📊 Domain Layer (Business Logic)
├── 🎯 Use Cases
├── 📋 Entities
└── 🔗 Repository Interfaces

💾 Data Layer (Data Sources)
├── 🌐 API Services
├── 🗄️ Local Storage
└── 🔧 Repository Implementations
```

### **Key Architectural Principles**
- **Dependency Inversion** - High-level modules don't depend on low-level modules
- **Single Responsibility** - Each class has one reason to change
- **Open/Closed Principle** - Open for extension, closed for modification
- **Interface Segregation** - Clients don't depend on interfaces they don't use

---

## 📱 Screenshots

<div align="center">

### 🎨 **App Screenshots**

| Splash Screen                                       | Home Screen                                       | Search Screen                                       |
| :--------------------------------------------------: | :-------------------------------------------------: | :--------------------------------------------------: |
| ![Splash Screen](https://i.postimg.cc/L6FMrxNJ/splash.jpg) | ![Home Screen](https://i.postimg.cc/Qxgrscy0/home.jpg) | ![Search Screen](https://i.postimg.cc/xT2Wsc1H/search.jpg) |

| Wishlist                                          | Shopping Cart                                     | Checkout                                          |
| :-------------------------------------------------: | :------------------------------------------------: | :-------------------------------------------------: |
| ![Wishlist](https://i.postimg.cc/wBGCF21T/wishlist.jpg) | ![Shopping Cart](https://i.postimg.cc/qBnPX844/cart.jpg) | ![Checkout](https://i.postimg.cc/B6FVp0WM/checkout.jpg) |

| Payment                                           |
| :-------------------------------------------------: |
| ![Payment](https://i.postimg.cc/TPpSybt8/visacard.jpg) |

</div>

---

## 🛠️ Tech Stack

### **Frontend Framework**
- **[Flutter 3.16+](https://flutter.dev/)** - Cross-platform UI framework
- **[Dart 3.0+](https://dart.dev/)** - Programming language

### **Backend & Services**
- **[Firebase](https://firebase.google.com/)** - Authentication, Database, Storage
- **[Firebase Auth](https://firebase.google.com/docs/auth)** - User authentication
- **[Cloud Firestore](https://firebase.google.com/docs/firestore)** - Real-time database

### **State Management**
- **[Provider](https://pub.dev/packages/provider)** - State management solution
- **[ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)** - State change notifications

### **Local Storage**
- **[SharedPreferences](https://pub.dev/packages/shared_preferences)** - Local data persistence
- **[Hive](https://pub.dev/packages/hive)** - Lightweight local database

### **Development Tools**
- **[Flutter DevTools](https://docs.flutter.dev/development/tools/devtools)** - Debugging and profiling
- **[VS Code](https://code.visualstudio.com/)** - Recommended IDE
- **[Android Studio](https://developer.android.com/studio)** - Alternative IDE

---

## 🚀 Getting Started

### **Prerequisites**
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.16.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.0.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/) for version control

### **Installation Steps**

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/chanzel.git
   cd chanzel
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download `google-services.json` for Android
   - Download `GoogleService-Info.plist` for iOS
   - Place them in the respective platform folders

4. **Run the app**
   ```bash
   flutter run
   ```

### **Build for Production**

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📁 Project Structure

```
lib/
├── 📱 main.dart                 # App entry point
├── 🏗️ core/                     # Core functionality
│   ├── 🔧 constants/            # App constants
│   ├── 🎨 theme/                # App theming
│   └── 🛠️ services/             # Core services
├── 🏠 features/                 # Feature modules
│   ├── 🔐 auth/                 # Authentication
│   ├── 🏠 home/                 # Home & products
│   └── 📚 onboarding/           # Onboarding flow
└── 🔧 shared/                   # Shared components
    ├── 🎨 widgets/              # Reusable widgets
    └── 🛠️ utils/                # Utility functions
```

### **Feature Module Structure**
Each feature follows the same structure:
```
feature_name/
├── 📊 data/                     # Data layer
│   ├── 🌐 repositories/          # Repository implementations
│   └── 🗄️ services/             # Data services
├── 🎯 domain/                   # Domain layer
│   ├── 📋 models/               # Business entities
│   ├── 🔗 repositories/         # Repository interfaces
│   └── ⚡ usecases/             # Business logic
└── 📱 presentation/             # Presentation layer
    ├── 🎨 screens/              # UI screens
    ├── 🔄 viewmodels/           # State management
    └── 🎨 widgets/              # Feature-specific widgets
```

---

## 🧪 Testing

### **Run Tests**
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

### **Test Structure**
- **Unit Tests** - Business logic and utilities
- **Widget Tests** - UI component testing
- **Integration Tests** - End-to-end user flows

---

## 📊 Performance & Optimization

### **Performance Features**
- **Lazy Loading** - Images and data loaded on demand
- **Memory Management** - Efficient resource usage
- **State Optimization** - Minimal rebuilds with Provider
- **Image Caching** - Optimized image loading

### **Best Practices**
- **Code Splitting** - Feature-based code organization
- **Dependency Injection** - Loose coupling between components
- **Error Handling** - Comprehensive error management
- **Logging** - Structured logging for debugging

---

## 🔧 Configuration

### **Environment Variables**
Create a `.env` file in the root directory:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
```

### **Build Configuration**
- **Debug Mode** - Development with hot reload
- **Profile Mode** - Performance profiling
- **Release Mode** - Production optimization

---

## 🚀 Deployment

### **Android**
1. Generate signed APK/Bundle
2. Upload to Google Play Console
3. Configure release notes and metadata

### **iOS**
1. Archive the app in Xcode
2. Upload to App Store Connect
3. Submit for review

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### **Contribution Guidelines**
- Follow Flutter coding standards
- Write tests for new features
- Update documentation as needed
- Ensure all tests pass

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase Team** - For backend services
- **Open Source Community** - For inspiration and tools

---

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/chanzel/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/chanzel/discussions)

---

<div align="center">

**Made with ❤️ using Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

**⭐ Star this repository if you found it helpful! ⭐**

</div>

