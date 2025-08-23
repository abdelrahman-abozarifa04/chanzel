import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/core/constants/app_icons.dart';
import 'package:chanzel/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // State variable to manage password visibility
  bool _isPasswordObscured = true;

  // Form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles the sign-in process
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      final success = await authViewModel.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        if (success) {
          // Navigate to home screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authViewModel.errorMessage ?? 'Sign in failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Section
                _buildHeader(),
                const SizedBox(height: 48.0),

                // Error message display
                Consumer<AuthViewModel>(
                  builder: (context, authViewModel, child) {
                    if (authViewModel.errorMessage != null) {
                      return Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                authViewModel.errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // 2. Form Input Fields
                _buildEmailField(),
                const SizedBox(height: 20.0),
                _buildPasswordField(),
                const SizedBox(height: 12.0),

                // 3. Forgot Password Link
                _buildForgotPasswordLink(),
                const SizedBox(height: 24.0),

                // 4. Sign In Button
                _buildSignInButton(),
                const SizedBox(height: 32.0),

                // 5. Social Media Sign Up Section
                _buildSocialSignUp(),
                const SizedBox(height: 40.0),

                // 6. Link to Sign Up Screen
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header section with the title and subtitle.
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Sign In',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Hi! Welcome back, you\'ve been missed',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  /// Builds the email input field with validation.
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
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the password input field with a visibility toggle icon.
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _passwordController,
          obscureText: _isPasswordObscured,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••••••••••',
            hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: ColorsManger.naiveColor, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the "Forgot Password?" text link.
  Widget _buildForgotPasswordLink() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: ColorsManger.naiveColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds the primary "Sign In" button.
  Widget _buildSignInButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return ElevatedButton(
          onPressed: authViewModel.isLoading ? null : _handleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManger.naiveColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
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
                  'Sign In',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
        );
      },
    );
  }

  /// Builds the social sign-up section with icons.
  Widget _buildSocialSignUp() {
    return Column(
      children: [
        const Text(
          'Or sign up with',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24.0),
        _buildSocialButtons(), // Using your provided social buttons widget
      ],
    );
  }

  /// This is the social buttons widget you provided.
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

  /// A reusable helper method for creating a single social media icon button.
  Widget _buildSocialIcon(Widget socialIcon) {
    return InkWell(
      onTap: () {
        // TODO: Implement social login logic.
        print('Social icon tapped');
      },
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: socialIcon,
      ),
    );
  }

  /// Builds the "Don't have an account? Sign Up" text link.
  Widget _buildSignUpLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have an account? ',
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: const TextStyle(
                color: ColorsManger.naiveColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
            ),
          ],
        ),
      ),
    );
  }
}
