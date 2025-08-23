import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chanzel/core/services/logger_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      Logger.info('Creating user with email and password');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      Logger.info('User created successfully');

      // Try to create user profile in Firestore, but don't fail if it doesn't work
      try {
        Logger.info('Creating user profile in Firestore');
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'profileCompleted': false,
        });
        Logger.info('User profile created in Firestore');
      } catch (firestoreError) {
        Logger.warning('Firestore error (non-critical): $firestoreError', error: firestoreError);
        // Don't throw error - Firestore is optional for basic functionality
      }

      // Update display name
      try {
        Logger.info('Updating display name');
        await userCredential.user!.updateDisplayName(fullName);
        Logger.info('Display name updated');
      } catch (displayNameError) {
        Logger.warning('Display name update error (non-critical): $displayNameError', error: displayNameError);
        // Don't throw error - display name is optional
      }

      return userCredential;
    } catch (e) {
      Logger.error('Critical error during signup: $e', error: e);
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Complete profile
  Future<void> completeProfile({
    required String phoneNumber,
    required String address,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    try {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'phoneNumber': phoneNumber,
        'address': address,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to complete profile: $e');
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      Logger.error('Error getting user data from Firestore: $e', error: e);
      // Return null instead of throwing error - app can work with local data
      return null;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return 'An error occurred: ${e.message}';
      }
    }
    return 'An unexpected error occurred.';
  }
}
