import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:chanzel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:chanzel/features/auth/domain/models/user_model.dart';
import 'package:chanzel/features/auth/data/user_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // State variables to hold form data
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  // User service for local storage
  final UserService _userService = UserService();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Password validation state
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasSpecialChar = false;
  bool _hasNumericChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates password against the requirements
  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 6;
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasNumericChar = password.contains(RegExp(r'[0-9]'));
    });
  }

  /// Checks if password meets all requirements
  bool get _isPasswordValid =>
      _hasMinLength &&
      _hasUpperCase &&
      _hasLowerCase &&
      _hasSpecialChar &&
      _hasNumericChar;

  /// Handles the sign-up process
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate() &&
        _agreeToTerms &&
        _isPasswordValid) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      print('Starting signup process...');
      final success = await authViewModel.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );

      print('Signup result: $success');

      if (mounted) {
        if (success) {
          // Debug: Print success message
          print('Signup successful, navigating to complete profile...');

          // Navigate to complete profile screen
          try {
            print('Attempting navigation to /completeProfile');
            Navigator.pushReplacementNamed(context, '/completeProfile');
            print('Navigation successful');
          } catch (e) {
            print('Navigation error: $e');
            // Fallback navigation
            print('Using fallback navigation');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CompleteProfileScreen(),
              ),
            );
          }
        } else {
          // Show error message
          print('Signup failed: ${authViewModel.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authViewModel.errorMessage ?? 'Sign up failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to terms and conditions'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (!_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please ensure password meets all requirements'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Section
                _buildHeader(),
                const SizedBox(height: 32.0),

                // 2. Form Input Fields
                _buildNameField(),
                const SizedBox(height: 20.0),
                _buildEmailField(),
                const SizedBox(height: 20.0),
                _buildPasswordField(),
                const SizedBox(height: 8.0),

                // Password Requirements
                _buildPasswordRequirements(),
                const SizedBox(height: 16.0),

                // 3. Terms & Conditions Checkbox
                _buildTermsCheckbox(),
                const SizedBox(height: 24.0),

                // 4. Sign Up Button
                _buildSignUpButton(),
                const SizedBox(height: 24.0),

                // 5. Social Sign Up Section
                _buildSocialSignUp(),
                const SizedBox(height: 32.0),

                // 6. Sign In Link
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the header
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Fill your information below or register with your social account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  /// Builds the name input field with validation
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'UserName',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: ColorsManger.naiveColor, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the email input field with validation
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'User@Gmail.com',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: ColorsManger.naiveColor, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable helper method for standard text fields
  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method specifically for the password field
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (!_isPasswordValid) {
              return 'Password does not meet requirements';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••••••••••',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              letterSpacing: 2,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the password requirements widget
  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12.0),
          _buildRequirementItem(
            'Minimum password length: 6 characters',
            _hasMinLength,
          ),
          const SizedBox(height: 6.0),
          _buildRequirementItem(
            'Require uppercase character',
            _hasUpperCase,
          ),
          const SizedBox(height: 6.0),
          _buildRequirementItem(
            'Require lowercase character',
            _hasLowerCase,
          ),
          const SizedBox(height: 6.0),
          _buildRequirementItem(
            'Require special character',
            _hasSpecialChar,
          ),
          const SizedBox(height: 6.0),
          _buildRequirementItem(
            'Require numeric character',
            _hasNumericChar,
          ),
        ],
      ),
    );
  }

  /// Builds a single requirement item with checkbox
  Widget _buildRequirementItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_box : Icons.check_box_outline_blank,
          color: isValid
              ? Colors.green
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          size: 18.0,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isValid
                  ? Colors.green
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 13.0,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for the terms and conditions checkbox
  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (bool? value) {
            setState(() {
              _agreeToTerms = value!;
            });
          },
          activeColor: ColorsManger.naiveColor,
        ),
        Text(
          'Agree with Terms & Condition',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // Helper method for the main sign-up button
  Widget _buildSignUpButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return ElevatedButton(
          onPressed:
              (authViewModel.isLoading || !_agreeToTerms || !_isPasswordValid)
                  ? null
                  : _handleSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManger.naiveColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 5,
          ),
          child: authViewModel.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
        );
      },
    );
  }

  // Helper method for the social media login buttons
  Widget _buildSocialSignUp() {
    return Column(
      children: [
        Text(
          'Or sign up with',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 24.0),
        _buildSocialButtons(),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          Image.network(
            'https://i.postimg.cc/50VbkDtk/facebook-2-1.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.facebook, size: 24, color: Colors.blue[600]);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 20.0),
        _buildSocialIcon(
          Image.network(
            'https://i.postimg.cc/hvCnvj1H/google-1.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 20.0),
        _buildSocialIcon(
          Image.network(
            'https://i.postimg.cc/gkJd5VYd/apple-1.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.apple, size: 24, color: Colors.black);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Reusable helper for a single social icon button
  Widget _buildSocialIcon(Widget icon) {
    return InkWell(
      onTap: () {
        // TODO: Handle social login
        print('social icon tapped');
      },
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: icon,
      ),
    );
  }

  // Helper method for the "Already have an account?" link
  Widget _buildSignInLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          children: [
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: ColorsManger.naiveColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
            ),
          ],
        ),
      ),
    );
  }
}
