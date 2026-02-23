// ============================================================================
// Day 31: Flutter Secure Storage Service
// ============================================================================
// flutter_secure_storage: Stores sensitive data securely
// - iOS: Keychain
// - Android: KeyStore with AES encryption
// - Web: Not secure (uses local storage)
// - macOS/Linux/Windows: Uses platform-specific secure storage
//
// 🎯 USE CASES:
// ✅ Authentication tokens
// ✅ API keys
// ✅ User credentials
// ✅ Encryption keys
// ✅ Sensitive user data
//
// ⚠️ DON'T USE FOR:
// ❌ Large data (slow performance)
// ❌ Non-sensitive data (use SharedPreferences)
// ❌ Frequently changing data
//
// 🔧 PLATFORM CONFIGURATION:
// Android: Min SDK 18, auto-backup must be configured
// iOS: Auto-configured, uses Keychain
// Web: NOT SECURE - falls back to local storage
// ============================================================================

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart';

// ============================================================================
// Secure Storage Service (Singleton Pattern)
// ============================================================================
// Wrapper around FlutterSecureStorage for type-safe operations

class SecureStorageService {
  // ============================================================
  // Singleton instance
  // ============================================================
  // Ensures only one instance exists throughout the app
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // ============================================================
  // FlutterSecureStorage with custom options
  // ============================================================
  // Platform-specific encryption settings
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      // Use encrypted SharedPreferences on Android
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      // Use Keychain accessibility - available after first unlock
      accessibility: KeychainAccessibility.first_unlock,
    ),
    webOptions: WebOptions(
      // Web is NOT secure - this is just for demo
      dbName: 'FlutterSecureStorage',
      publicKey: 'demo_public_key',
    ),
  );

  // ============================================================
  // TOKEN MANAGEMENT
  // ============================================================
  // Store and retrieve authentication tokens securely

  // Storage keys - using const for type safety
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyTokenExpiry = 'token_expiry';
  static const _keyAuthToken = 'auth_token_json';

  /// Save individual token parts
  /// Example: await secureStorage.saveToken('eyJhbGc...', 'refresh123', DateTime.now().add(Duration(hours: 1)));
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    // Save each part separately
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
      _storage.write(key: _keyTokenExpiry, value: expiresAt.toIso8601String()),
    ]);
  }

  /// Save entire AuthToken object as JSON
  /// Example: await secureStorage.saveAuthToken(authToken);
  Future<void> saveAuthToken(AuthToken token) async {
    final json = jsonEncode(token.toJson());
    await _storage.write(key: _keyAuthToken, value: json);
  }

  /// Retrieve access token
  /// Returns null if not found
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Retrieve token expiry
  Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: _keyTokenExpiry);
    if (expiryString == null) return null;
    return DateTime.tryParse(expiryString);
  }

  /// Retrieve full AuthToken object
  /// Example: final token = await secureStorage.getAuthToken();
  Future<AuthToken?> getAuthToken() async {
    final json = await _storage.read(key: _keyAuthToken);
    if (json == null) return null;
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AuthToken.fromJson(map);
    } catch (e) {
      print('Error parsing AuthToken: $e');
      return null;
    }
  }

  /// Check if user is authenticated (has valid token)
  /// Example: if (await secureStorage.isAuthenticated()) { ... }
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    if (token == null) return false;
    
    // Check if token is expired using extension method
    return !token.isExpired;
  }

  /// Delete all tokens (logout)
  /// Example: await secureStorage.clearTokens();
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyTokenExpiry),
      _storage.delete(key: _keyAuthToken),
    ]);
  }

  // ============================================================
  // GENERIC KEY-VALUE STORAGE
  // ============================================================
  // Store any string data securely

  /// Write a secure value
  /// Example: await secureStorage.write('api_key', 'sk_live_abc123');
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secure value
  /// Example: final apiKey = await secureStorage.read('api_key');
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a specific key
  /// Example: await secureStorage.delete('api_key');
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete ALL stored data (use with caution!)
  /// Example: await secureStorage.deleteAll();
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Get all keys (for debugging)
  /// Example: final keys = await secureStorage.getAllKeys();
  Future<Map<String, String>> getAllKeys() async {
    return await _storage.readAll();
  }

  /// Check if a key exists
  /// Example: if (await secureStorage.containsKey('api_key')) { ... }
  Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  // ============================================================
  // USER PREFERENCES (Secure)
  // ============================================================
  // Store sensitive user preferences

  /// Save user credentials (for auto-login demo)
  /// ⚠️ In production, use OAuth tokens instead
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await Future.wait([
      _storage.write(key: 'user_email', value: email),
      _storage.write(key: 'user_password', value: password),
    ]);
  }

  /// Get saved credentials
  Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: 'user_email');
    final password = await _storage.read(key: 'user_password');
    return {'email': email, 'password': password};
  }

  /// Clear saved credentials
  Future<void> clearCredentials() async {
    await Future.wait([
      _storage.delete(key: 'user_email'),
      _storage.delete(key: 'user_password'),
    ]);
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================
/*

// 1. SAVE TOKEN
final storage = SecureStorageService();
await storage.saveToken(
  accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  refreshToken: 'refresh_token_here',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);

// 2. SAVE AUTH TOKEN OBJECT
final authToken = AuthToken(
  accessToken: 'access123',
  refreshToken: 'refresh456',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);
await storage.saveAuthToken(authToken);

// 3. CHECK AUTHENTICATION
if (await storage.isAuthenticated()) {
  print('User is logged in');
  final token = await storage.getAuthToken();
  print('Token: ${token?.authorizationHeader}');
} else {
  print('User is logged out');
}

// 4. LOGOUT
await storage.clearTokens();

// 5. GENERIC STORAGE
await storage.write('api_key', 'secret_key_123');
final apiKey = await storage.read('api_key');

// 6. DEBUGGING
final allKeys = await storage.getAllKeys();
print('Stored keys: ${allKeys.keys}');

*/
