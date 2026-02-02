import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';

class HiveHelper {
  static HiveHelper? _instance;
  static HiveHelper get instance => _instance ??= HiveHelper._();

  HiveHelper._();

  late Box _appBox;
  late Box _draftsBox;
  late Box _userBox;
  late Box _cacheBox;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _appBox = await Hive.openBox(AppConstants.hiveBoxName);
      _draftsBox = await Hive.openBox(AppConstants.hiveDraftsBoxName);
      _userBox = await Hive.openBox(AppConstants.hiveUserBoxName);
      _cacheBox = await Hive.openBox(AppConstants.hiveCacheBoxName);
      AppLogger.info('Hive initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Hive', error: e);
      throw CacheException(message: '本地存储初始化失败');
    }
  }

  Future<void> clear() async {
    try {
      await _appBox.clear();
      await _draftsBox.clear();
      await _userBox.clear();
      await _cacheBox.clear();
    } catch (e) {
      AppLogger.error('Failed to clear Hive', error: e);
      throw CacheException(message: '清除缓存失败');
    }
  }

  // AppBox methods
  Future<void> setAppValue(String key, dynamic value) async {
    try {
      await _appBox.put(key, value);
    } catch (e) {
      AppLogger.error('Failed to set app value: $key', error: e);
      throw CacheException(message: '保存数据失败');
    }
  }

  T? getAppValue<T>(String key) {
    try {
      return _appBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('Failed to get app value: $key', error: e);
      return null;
    }
  }

  Future<void> removeAppValue(String key) async {
    try {
      await _appBox.delete(key);
    } catch (e) {
      AppLogger.error('Failed to remove app value: $key', error: e);
    }
  }

  // DraftsBox methods
  Future<void> saveDraft(String key, dynamic draft) async {
    try {
      await _draftsBox.put(key, draft);
    } catch (e) {
      AppLogger.error('Failed to save draft: $key', error: e);
      throw CacheException(message: '保存草稿失败');
    }
  }

  T? getDraft<T>(String key) {
    try {
      return _draftsBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('Failed to get draft: $key', error: e);
      return null;
    }
  }

  Future<void> deleteDraft(String key) async {
    try {
      await _draftsBox.delete(key);
    } catch (e) {
      AppLogger.error('Failed to delete draft: $key', error: e);
    }
  }

  List<dynamic> getAllDrafts() {
    try {
      return _draftsBox.values.toList();
    } catch (e) {
      AppLogger.error('Failed to get all drafts', error: e);
      return [];
    }
  }

  // UserBox methods
  Future<void> setUserValue(String key, dynamic value) async {
    try {
      await _userBox.put(key, value);
    } catch (e) {
      AppLogger.error('Failed to set user value: $key', error: e);
      throw CacheException(message: '保存用户数据失败');
    }
  }

  T? getUserValue<T>(String key) {
    try {
      return _userBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('Failed to get user value: $key', error: e);
      return null;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _userBox.clear();
    } catch (e) {
      AppLogger.error('Failed to clear user data', error: e);
    }
  }

  // CacheBox methods
  Future<void> setCacheValue(String key, dynamic value, {Duration? ttl}) async {
    try {
      await _cacheBox.put(key, value);
      if (ttl != null) {
        final expiryTime = DateTime.now().add(ttl).millisecondsSinceEpoch;
        await _cacheBox.put('${key}_expiry', expiryTime);
      }
    } catch (e) {
      AppLogger.error('Failed to set cache value: $key', error: e);
    }
  }

  T? getCacheValue<T>(String key) {
    try {
      final expiryTime = _cacheBox.get('${key}_expiry');
      if (expiryTime != null) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(expiryTime);
        if (DateTime.now().isAfter(expiry)) {
          _cacheBox.delete(key);
          _cacheBox.delete('${key}_expiry');
          return null;
        }
      }
      return _cacheBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('Failed to get cache value: $key', error: e);
      return null;
    }
  }

  Future<void> clearCache() async {
    try {
      await _cacheBox.clear();
    } catch (e) {
      AppLogger.error('Failed to clear cache', error: e);
    }
  }
}