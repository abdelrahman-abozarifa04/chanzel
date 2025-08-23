import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chanzel/core/services/logger_service.dart';

class PromoService extends ChangeNotifier {
  static final PromoService _instance = PromoService._internal();
  factory PromoService() => _instance;
  PromoService._internal() {
    _loadPromoFromStorage();
  }

  String? _appliedPromoCode;
  double _discountPercentage = 0.0;
  double _discountAmount = 0.0;

  static const String _promoKey = 'applied_promo';

  // Valid promo codes and their discount percentages
  static const Map<String, double> _validPromoCodes = {
    'abdo': 20.0, // 20% discount
  };

  String? get appliedPromoCode => _appliedPromoCode;
  double get discountPercentage => _discountPercentage;
  double get discountAmount => _discountAmount;

  /// Apply a promo code and return success status
  bool applyPromoCode(String promoCode, double subtotal) {
    final code = promoCode.toLowerCase().trim();

    if (_validPromoCodes.containsKey(code)) {
      _appliedPromoCode = code;
      _discountPercentage = _validPromoCodes[code]!;
      _discountAmount = (subtotal * _discountPercentage) / 100;
      _savePromoToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Remove applied promo code
  void removePromoCode() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    _discountAmount = 0.0;
    _savePromoToStorage();
    notifyListeners();
  }

  /// Calculate total after discount
  double calculateTotal(double subtotal, double shippingFee) {
    return subtotal + shippingFee - _discountAmount;
  }

  /// Check if a promo code is valid
  bool isValidPromoCode(String promoCode) {
    return _validPromoCodes.containsKey(promoCode.toLowerCase().trim());
  }

  /// Clear all promo data (used when cart is cleared)
  void clearPromoData() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    _discountAmount = 0.0;
    _savePromoToStorage();
    notifyListeners();
  }

  /// Save promo data to local storage
  Future<void> _savePromoToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final promoData = {
        'appliedPromoCode': _appliedPromoCode,
        'discountPercentage': _discountPercentage,
        'discountAmount': _discountAmount,
      };
      await prefs.setString(_promoKey, jsonEncode(promoData));
    } catch (e) {
      Logger.error('Error saving promo to storage: $e', error: e);
    }
  }

  /// Load promo data from local storage
  Future<void> _loadPromoFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final promoString = prefs.getString(_promoKey);
      if (promoString != null) {
        final promoData = jsonDecode(promoString) as Map<String, dynamic>;
        _appliedPromoCode = promoData['appliedPromoCode'];
        _discountPercentage = (promoData['discountPercentage'] ?? 0.0)
            .toDouble();
        _discountAmount = (promoData['discountAmount'] ?? 0.0).toDouble();
      }
    } catch (e) {
      Logger.error('Error loading promo from storage: $e', error: e);
    }
  }
}
