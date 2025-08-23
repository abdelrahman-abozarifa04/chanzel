import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chanzel/features/auth/domain/models/user_model.dart';
import 'package:chanzel/core/services/logger_service.dart';

class UserService {
  static const String _userDataKey = 'user_data';
  static const String _userPhotoKey = 'user_photo';

  // Save user data to SharedPreferences
  Future<void> saveUserData(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userMap = user.toMap();
    await prefs.setString(_userDataKey, jsonEncode(userMap));
  }

  // Load user data from SharedPreferences
  Future<UserModel?> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      final userMap = jsonDecode(userDataString) as Map<String, dynamic>;
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  // Save user photo as base64 string
  Future<void> saveUserPhoto(File photoFile) async {
    try {
      Logger.info('Starting to save photo...');
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Simple approach - just try to read bytes directly
      final bytes = await photoFile.readAsBytes();
      final base64String = base64Encode(bytes);
      await prefs.setString(_userPhotoKey, base64String);
      Logger.info(
        'Photo saved successfully as base64, length: ${base64String.length}',
      );
    } catch (e) {
      Logger.error('Error saving photo: $e', error: e);
      // Don't throw error - photo is optional, just log the issue
    }
  }

  // Alternative method: Save photo from XFile (from image picker)
  Future<void> saveUserPhotoFromXFile(XFile xFile) async {
    try {
      Logger.info('Starting to save photo from XFile...');
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Read bytes directly from XFile
      final bytes = await xFile.readAsBytes();
      final base64String = base64Encode(bytes);
      await prefs.setString(_userPhotoKey, base64String);
      Logger.info(
        'Photo saved successfully from XFile as base64, length: ${base64String.length}',
      );
    } catch (e) {
      Logger.error('Error saving photo from XFile: $e', error: e);
      // Don't throw error - photo is optional, just log the issue
    }
  }

  // Load user photo as base64 string (no file operations)
  Future<String?> loadUserPhotoBase64() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userPhotoKey);
    } catch (e) {
      Logger.error('Error loading user photo: $e', error: e);
      return null;
    }
  }

  // Load user photo from SharedPreferences (legacy method - returns null to avoid errors)
  Future<File?> loadUserPhoto() async {
    // Return null to avoid file operation errors
    // Use loadUserPhotoBase64() instead for displaying photos
    return null;
  }

  // Get user photo as base64 string
  Future<String?> getUserPhotoBase64() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhotoKey);
  }

  // Clear all user data
  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.remove(_userPhotoKey);
  }

  // Update specific user field
  Future<void> updateUserField(String field, dynamic value) async {
    final user = await loadUserData();
    if (user != null) {
      final updatedUser = user.copyWith(
        id: field == 'id' ? value : user.id,
        name: field == 'name' ? value : user.name,
        email: field == 'email' ? value : user.email,
        phone: field == 'phone' ? value : user.phone,
        gender: field == 'gender' ? value : user.gender,
        address: field == 'address' ? value : user.address,
        photoUrl: field == 'photoUrl' ? value : user.photoUrl,
        profileCompleted: field == 'profileCompleted'
            ? value
            : user.profileCompleted,
      );
      await saveUserData(updatedUser);
    }
  }
}
