import 'package:flutter/material.dart';
import 'package:chanzel/core/services/logger_service.dart';

class ErrorService {
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            if (actionText != null && onAction != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onAction();
                },
                child: Text(actionText),
              ),
          ],
        );
      },
    );
  }

  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }

  static void showWarningSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: duration,
      ),
    );
  }

  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    bool showDialog = false,
    bool showSnackBar = true,
  }) {
    final errorMessage = customMessage ?? _getErrorMessage(error);
    
    Logger.error('Error occurred: $errorMessage', error: error);
    
    if (showDialog) {
      showErrorDialog(
        context,
        title: 'Error',
        message: errorMessage,
      );
    } else if (showSnackBar) {
      showErrorSnackBar(context, message: errorMessage);
    }
  }

  static String _getErrorMessage(dynamic error) {
    if (error is String) return error;
    
    // Handle common error types
    if (error.toString().contains('network')) {
      return 'Network error. Please check your connection.';
    }
    if (error.toString().contains('permission')) {
      return 'Permission denied. Please check app permissions.';
    }
    if (error.toString().contains('firebase')) {
      return 'Authentication error. Please try again.';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }
}
