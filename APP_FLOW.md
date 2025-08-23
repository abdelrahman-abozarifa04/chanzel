# App Flow Logic

This document describes the app flow logic implemented for handling first-time vs returning users.

## Flow Sequences

### First-Time Users
1. **Splash Screen** (3 seconds delay)
2. **Onboarding Screen** (3 pages with navigation)
3. **Signup Screen** (create account)
4. **Complete Profile Screen** (fill profile details)
5. **Home Screen** (main app)

### Returning Users
#### Authenticated Users
1. **Splash Screen** (3 seconds delay)
2. **Home Screen** (main app)

#### Non-Authenticated Users
1. **Splash Screen** (3 seconds delay)
2. **Login Screen** (sign in)
3. **Home Screen** (main app)

## Implementation Details

### AppFlowService
- **Location**: `lib/core/services/app_flow_service.dart`
- **Purpose**: Central service to determine the appropriate navigation route
- **Key Methods**:
  - `isFirstTime()`: Checks if user is opening the app for the first time
  - `markOnboardingCompleted()`: Marks onboarding as completed
  - `getInitialRoute()`: Returns the appropriate route based on user status
  - `resetFirstTimeStatus()`: Resets first-time status (used on logout)

### Storage
- Uses `SharedPreferences` to store first-time user status
- Key: `is_first_time` (boolean)
- Default: `true` (first time)

### Navigation Logic
The splash screen automatically determines the next screen based on:
1. Whether the user has completed onboarding before
2. Whether the user is currently authenticated

### Logout Behavior
When a user logs out:
- Authentication state is cleared
- First-time status is reset to `true`
- Next app launch will show onboarding again

## Files Modified

1. **`lib/core/services/app_flow_service.dart`** - New service for flow logic
2. **`lib/features/auth/presentation/screens/splash_screen.dart`** - Updated navigation logic
3. **`lib/features/onboarding/presentation/screens/onboarding_screen.dart`** - Mark completion
4. **`lib/features/auth/presentation/viewmodels/auth_view_model.dart`** - Reset on logout

## Testing the Flow

### First Time User
1. Clear app data or uninstall/reinstall
2. Launch app → Should see splash → onboarding → signup → complete profile → home

### Returning Authenticated User
1. Complete onboarding and signup
2. Close app and relaunch → Should see splash → home directly

### Returning Non-Authenticated User
1. Complete onboarding and signup
2. Logout from app
3. Relaunch app → Should see splash → login → home

### After Logout
1. Logout from app
2. Relaunch app → Should see splash → onboarding (first-time flow again)

## Debug Logging

The service includes debug logging to help troubleshoot flow issues:
- Check console for "AppFlowService:" prefixed messages
- Check console for "OnboardingScreen:" prefixed messages
