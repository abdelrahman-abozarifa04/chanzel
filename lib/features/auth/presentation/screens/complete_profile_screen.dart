import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/core/constants/egyptian_cities.dart';
import 'package:chanzel/features/auth/data/user_service.dart';
import 'package:chanzel/features/auth/domain/models/user_model.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

class CompleteProfileScreen extends StatefulWidget {
  final bool isEditing;

  const CompleteProfileScreen({super.key, this.isEditing = false});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfileScreen> {
  // Controllers to manage the text in the TextFields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // User service for data management
  final UserService _userService = UserService();

  // Profile photo
  File? _selectedPhoto;
  XFile? _selectedXFile;
  String? _photoBase64;
  final ImagePicker _picker = ImagePicker();

  // Selected city and gender
  String? _selectedCity;
  String? _selectedGender;

  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load the saved data when the screen is first initialized.
    _loadProfileData();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed to prevent memory leaks.
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Loads user profile data and populates the text fields.
  Future<void> _loadProfileData() async {
    final user = await _userService.loadUserData();
    if (user != null) {
      setState(() {
        _nameController.text = user.name ?? '';
        _phoneController.text = user.phone ?? '';
        _selectedGender = user.gender;
        _selectedCity = user.address;
      });
    }

    // Load profile photo as base64
    final photoBase64 = await _userService.loadUserPhotoBase64();
    if (photoBase64 != null) {
      setState(() {
        _photoBase64 = photoBase64;
      });
    }
  }

  /// Handles profile photo selection from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedXFile = image;
          _selectedPhoto = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  /// Handles profile photo capture from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedXFile = image;
          _selectedPhoto = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
    }
  }

  /// Shows image source selection dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Saves the current user profile data.
  Future<void> _saveProfileData() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedGender == null ||
        _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('CompleteProfileScreen: Starting to save profile data...');

      // Save profile photo if selected
      if (_selectedXFile != null) {
        print('CompleteProfileScreen: Saving profile photo from XFile...');
        try {
          await _userService.saveUserPhotoFromXFile(_selectedXFile!);
          print(
            'CompleteProfileScreen: Profile photo saved successfully from XFile',
          );
        } catch (photoError) {
          print(
            'CompleteProfileScreen: Error saving photo from XFile: $photoError',
          );
          // Try fallback method with File
          if (_selectedPhoto != null) {
            try {
              await _userService.saveUserPhoto(_selectedPhoto!);
              print(
                'CompleteProfileScreen: Profile photo saved successfully from File',
              );
            } catch (filePhotoError) {
              print(
                'CompleteProfileScreen: Error saving photo from File: $filePhotoError',
              );
              // Continue without photo - it's optional
            }
          }
        }
      } else if (_selectedPhoto != null) {
        print('CompleteProfileScreen: Saving profile photo from File...');
        try {
          await _userService.saveUserPhoto(_selectedPhoto!);
          print(
            'CompleteProfileScreen: Profile photo saved successfully from File',
          );
        } catch (photoError) {
          print('CompleteProfileScreen: Error saving photo: $photoError');
          // Continue without photo - it's optional
        }
      }

      // Create user model
      final user = UserModel(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender,
        address: _selectedCity,
        profileCompleted: true,
      );

      print('CompleteProfileScreen: Saving user data locally...');
      // Save user data locally first
      await _userService.saveUserData(user);
      print('CompleteProfileScreen: User data saved locally successfully');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        print('CompleteProfileScreen: Navigating to home screen...');
        // Navigate based on whether we're editing or completing profile
        if (widget.isEditing) {
          Navigator.pop(
            context,
            true,
          ); // Return true to indicate successful edit
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      print('CompleteProfileScreen: Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Subtitle Text
              Text(
                "Don't worry, only you can see your personal data. No one else will be able to see it",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 40.0),

              // 2. Profile Picture Section
              _buildProfilePhotoSection(),
              const SizedBox(height: 48.0),

              // 3. Form Input Fields
              _buildTextField(
                label: 'Name',
                hint: 'Enter your full name',
                controller: _nameController,
              ),
              const SizedBox(height: 20.0),

              _buildTextField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20.0),

              // Gender dropdown
              _buildGenderDropdown(),
              const SizedBox(height: 20.0),

              // Address dropdown
              _buildAddressDropdown(),
              const SizedBox(height: 40.0),

              // 4. Complete Profile Button
              _buildCompleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      title: Text(
        widget.isEditing ? 'Edit Profile' : 'Complete Profile',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  /// Builds the profile photo section with image selection.
  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: ColorsManger.beigeColor,
                backgroundImage: _getProfileImage(),
                child: _getProfileImage() == null
                    ? const Icon(
                        Icons.person_outline,
                        size: 80,
                        color: ColorsManger.naiveColor,
                      )
                    : null,
              ),
              Positioned(
                bottom: 5,
                right: -5,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsManger.naiveColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Tap the edit icon to add a photo',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate image for the profile photo
  ImageProvider? _getProfileImage() {
    // Priority: 1. Selected photo (new), 2. Base64 (saved), 3. None
    if (_selectedPhoto != null) {
      return FileImage(_selectedPhoto!);
    } else if (_photoBase64 != null) {
      return MemoryImage(base64Decode(_photoBase64!));
    }
    return null;
  }

  /// Builds the address dropdown for Egyptian cities.
  Widget _buildAddressDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'City',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _selectedCity,
          decoration: InputDecoration(
            hintText: 'Select your city',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
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
              borderSide: const BorderSide(
                color: ColorsManger.naiveColor,
                width: 2.0,
              ),
            ),
          ),
          items: EgyptianCities.cities.map((String city) {
            return DropdownMenuItem<String>(value: city, child: Text(city));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCity = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a city';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Country: ${EgyptianCities.getCountry()}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// A reusable helper method to build styled text input fields.
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
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
              borderSide: const BorderSide(
                color: ColorsManger.naiveColor,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Normalizes gender values to match dropdown item values
  String? _getNormalizedGenderValue(String? gender) {
    if (gender == null) return null;

    // Convert to lowercase for comparison
    final lowerGender = gender.toLowerCase();

    // Map common variations to the expected dropdown values
    if (lowerGender == 'male' || lowerGender == 'm') {
      return 'Male';
    } else if (lowerGender == 'female' || lowerGender == 'f') {
      return 'Female';
    }

    // If no match found, return null to avoid assertion error
    return null;
  }

  /// Builds the gender dropdown with Male/Female options
  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _getNormalizedGenderValue(_selectedGender),
          decoration: InputDecoration(
            hintText: 'Select your gender',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
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
              borderSide: const BorderSide(
                color: ColorsManger.naiveColor,
                width: 2.0,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem<String>(value: 'Male', child: Text('Male')),
            DropdownMenuItem<String>(value: 'Female', child: Text('Female')),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your gender';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds the primary "Complete profile" button.
  Widget _buildCompleteButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveProfileData,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManger.naiveColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Complete Profile',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
    );
  }
}
