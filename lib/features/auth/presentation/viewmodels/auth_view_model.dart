import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chanzel/features/auth/data/firebase_auth_service.dart';
import 'package:chanzel/core/services/app_flow_service.dart';
import 'package:chanzel/core/services/logger_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  User? get currentUser => _authService.currentUser;

  // Constructor
  AuthViewModel() {
    _initializeAuth();
  }

  // Initialize authentication state
  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) {
      _isAuthenticated = user != null;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    try {
      _userData = await _authService.getUserData();
      notifyListeners();
    } catch (e) {
      Logger.error('Error loading user data: $e', error: e);
      // Don't set error message - app can work without Firestore data
      _userData = null;
      notifyListeners();
    }
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      Logger.info('Starting signup for $email');
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      Logger.info('Signup successful');
      _setLoading(false);
      return true;
    } catch (e) {
      Logger.error('Signup failed with error: $e', error: e);
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      // Reset first-time status when user logs out
      await AppFlowService.resetFirstTimeStatus();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Complete profile
  Future<bool> completeProfile({
    required String phoneNumber,
    required String address,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.completeProfile(
        phoneNumber: phoneNumber,
        address: address,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );
      await _loadUserData(); // Reload user data
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
