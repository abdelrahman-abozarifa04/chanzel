import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:chanzel/core/services/logger_service.dart';

enum ConnectionType { wifi, mobile, ethernet, vpn, bluetooth, other, none }

class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal() {
    _initConnectivity();
  }

  ConnectionType _connectionType = ConnectionType.none;
  bool _isInitialized = false;
  bool _isConnected = false;

  ConnectionType get connectionType => _connectionType;
  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;

  void _initConnectivity() async {
    try {
      // For now, assume we have a connection
      // In a real app, you would check actual connectivity
      _connectionType = ConnectionType.wifi;
      _isConnected = true;
      _isInitialized = true;
      notifyListeners();

      Logger.info('Connectivity service initialized');
    } catch (e) {
      Logger.error('Failed to initialize connectivity service: $e', error: e);
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Check if we have internet connectivity
  bool get hasInternetConnection => _isConnected;

  // Check if we're on WiFi
  bool get isOnWifi => _connectionType == ConnectionType.wifi;

  // Check if we're on mobile data
  bool get isOnMobile => _connectionType == ConnectionType.mobile;

  // Get connection type as string
  String get connectionTypeString {
    switch (_connectionType) {
      case ConnectionType.wifi:
        return 'WiFi';
      case ConnectionType.mobile:
        return 'Mobile Data';
      case ConnectionType.ethernet:
        return 'Ethernet';
      case ConnectionType.vpn:
        return 'VPN';
      case ConnectionType.bluetooth:
        return 'Bluetooth';
      case ConnectionType.other:
        return 'Other';
      case ConnectionType.none:
      default:
        return 'No Connection';
    }
  }

  // Simulate connection loss for testing
  void simulateConnectionLoss() {
    _connectionType = ConnectionType.none;
    _isConnected = false;
    notifyListeners();
    Logger.info('Simulated connection loss');
  }

  // Simulate connection restoration for testing
  void simulateConnectionRestore() {
    _connectionType = ConnectionType.wifi;
    _isConnected = true;
    notifyListeners();
    Logger.info('Simulated connection restoration');
  }

  // Wait for internet connection with timeout
  Future<bool> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (hasInternetConnection) return true;

    final completer = Completer<bool>();
    Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    // For now, just wait a bit and return current status
    await Future.delayed(const Duration(seconds: 1));
    if (!completer.isCompleted) {
      completer.complete(hasInternetConnection);
    }

    return completer.future;
  }
}
