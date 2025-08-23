class ValidationService {
  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (name.length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    // Basic phone validation for Egyptian numbers
    final phoneRegex = RegExp(r'^(\+20|0)?1[0-9]{9}$');
    if (!phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Please enter a valid Egyptian phone number';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'Address is required';
    }

    if (address.length < 10) {
      return 'Address must be at least 10 characters long';
    }

    if (address.length > 200) {
      return 'Address must be less than 200 characters';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Number validation
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Positive number validation
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final number = double.parse(value!);
    if (number <= 0) {
      return 'Please enter a positive number';
    }

    return null;
  }

  // Date validation
  static String? validateDate(DateTime? date, {String? fieldName}) {
    if (date == null) {
      return fieldName != null ? '$fieldName is required' : 'Date is required';
    }

    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date cannot be in the future';
    }

    // Check if date is not too far in the past (e.g., 100 years ago)
    final minDate = DateTime(now.year - 100, now.month, now.day);
    if (date.isBefore(minDate)) {
      return 'Date seems too far in the past';
    }

    return null;
  }

  // Age validation
  static String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Birth date is required';
    }

    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    if (age < 13) {
      return 'You must be at least 13 years old';
    }

    if (age > 120) {
      return 'Please enter a valid birth date';
    }

    return null;
  }
}
