import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';

@singleton
class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  Future<void> setToken(String token) async {
    try {
      await _storage.write(key: AppConstants.secureTokenKey, value: token);
      AppLogger.info('Token saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save token', error: e);
      throw CacheException(message: '保存Token失败');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.secureTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read token', error: e);
      return null;
    }
  }

  Future<void> setRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: AppConstants.secureRefreshTokenKey, value: refreshToken);
    } catch (e) {
      AppLogger.error('Failed to save refresh token', error: e);
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppConstants.secureRefreshTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read refresh token', error: e);
      return null;
    }
  }

  Future<void> setPid(String pid) async {
    try {
      await _storage.write(key: AppConstants.securePidKey, value: pid);
    } catch (e) {
      AppLogger.error('Failed to save PID', error: e);
    }
  }

  Future<String?> getPid() async {
    try {
      return await _storage.read(key: AppConstants.securePidKey);
    } catch (e) {
      AppLogger.error('Failed to read PID', error: e);
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('Secure storage cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', error: e);
    }
  }

  Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      AppLogger.error('Failed to delete key: $key', error: e);
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      AppLogger.error('Failed to read key: $key', error: e);
      return null;
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      AppLogger.error('Failed to write key: $key', error: e);
      throw CacheException(message: '保存数据失败');
    }
  }
}