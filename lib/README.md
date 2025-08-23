# Clean Architecture Structure

This project follows Clean Architecture principles with a feature-based organization.

## Directory Structure

```
lib/
├── core/                          # Core functionality shared across features
│   ├── constants/                 # App-wide constants
│   │   ├── app_colors.dart       # Color definitions
│   │   ├── app_fonts.dart        # Font styles
│   │   ├── app_icons.dart        # Icon definitions
│   │   ├── app_images.dart       # Image asset paths
│   │   └── constants.dart        # Barrel file for constants
│   ├── utils/                     # Utility functions
│   └── widgets/                   # Core widgets
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer
│   │   ├── domain/                # Domain layer
│   │   │   └── models/           # Domain models
│   │   └── presentation/          # Presentation layer
│   │       ├── screens/          # UI screens
│   │       ├── viewmodels/       # ViewModels
│   │       └── widgets/          # Feature-specific widgets
│   ├── home/                      # Home feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── onboarding/                # Onboarding feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/                   # Profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/                        # Shared components
│   ├── utils/                     # Shared utilities
│   └── widgets/                   # Shared widgets
│       ├── auth_header.dart      # Reusable auth header
│       ├── custom_button.dart    # Reusable button
│       ├── custom_text_field.dart # Reusable text field
│       └── widgets.dart          # Barrel file for widgets
└── main.dart                      # App entry point
```

## Architecture Principles

### 1. Feature-Based Organization
Each feature is self-contained with its own data, domain, and presentation layers.

### 2. Clean Architecture Layers
- **Presentation Layer**: UI components, screens, and view models
- **Domain Layer**: Business logic and models
- **Data Layer**: Data sources and repositories

### 3. Dependency Direction
Dependencies flow inward: Presentation → Domain ← Data

### 4. Shared Components
- **Core**: App-wide constants and utilities
- **Shared**: Reusable widgets and utilities across features

## Benefits

1. **Maintainability**: Clear separation of concerns
2. **Scalability**: Easy to add new features
3. **Testability**: Each layer can be tested independently
4. **Reusability**: Shared components reduce code duplication
5. **Team Collaboration**: Different team members can work on different features

## Usage

### Importing Constants
```dart
import 'package:final_project/core/constants/constants.dart';
```

### Importing Shared Widgets
```dart
import 'package:final_project/shared/widgets/widgets.dart';
```

### Feature-Specific Imports
```dart
import 'package:final_project/features/auth/presentation/screens/login_screen.dart';
```
