import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';

class DeepLinkService {
  Future<bool> openTaobao(String url) async {
    try {
      if (Platform.isIOS) {
        final taobaoUrl = url.replaceFirst(
          'https://',
          AppConstants.taobaoScheme,
        );
        final canLaunch = await canLaunchUrl(Uri.parse(taobaoUrl));
        if (canLaunch) {
          return await launchUrl(
            Uri.parse(taobaoUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } else if (Platform.isAndroid) {
        final intentUrl = 'intent://s.click.taobao.com/#Intent;scheme=https;package=com.taobao.taobao;end';
        final canLaunch = await canLaunchUrl(Uri.parse(intentUrl));
        if (canLaunch) {
          return await launchUrl(
            Uri.parse(intentUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      }
      
      // Fallback to web
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      AppLogger.error('Failed to open Taobao', error: e);
      throw const UnknownException(message: '打开淘宝失败');
    }
  }

  Future<bool> openJD(String url) async {
    try {
      final jdUrl = url.replaceFirst(
        'https://',
        AppConstants.jdScheme,
      );
      
      final canLaunch = await canLaunchUrl(Uri.parse(jdUrl));
      if (canLaunch) {
        return await launchUrl(
          Uri.parse(jdUrl),
          mode: LaunchMode.externalApplication,
        );
      }
      
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      AppLogger.error('Failed to open JD', error: e);
      throw const UnknownException(message: '打开京东失败');
    }
  }

  Future<bool> openUrl(String url) async {
    try {
      if (url.contains('taobao.com') || url.contains('tmall.com')) {
        return await openTaobao(url);
      } else if (url.contains('jd.com')) {
        return await openJD(url);
      }
      
      final canLaunch = await canLaunchUrl(Uri.parse(url));
      if (!canLaunch) {
        throw const UnknownException(message: '无法打开链接');
      }
      
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      AppLogger.error('Failed to open URL: $url', error: e);
      if (e is UnknownException) rethrow;
      throw const UnknownException(message: '打开链接失败');
    }
  }

  Future<String?> getClipboardText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text;
    } catch (e) {
      AppLogger.error('Failed to get clipboard text', error: e);
      return null;
    }
  }

  Future<bool> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (e) {
      AppLogger.error('Failed to copy to clipboard', error: e);
      return false;
    }
  }

  String? parseTaobaoPassword(String text) {
    final match = AppConstants.taobaoPasswordRegex.firstMatch(text);
    return match?.group(1);
  }
}