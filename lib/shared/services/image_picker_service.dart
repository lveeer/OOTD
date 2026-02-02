import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/media_file.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<MediaFile>> pickImages({
    int maxCount = AppConstants.maxImageCount,
    int maxWidth = AppConstants.imageMaxWidth,
    int maxHeight = AppConstants.imageMaxHeight,
    int quality = AppConstants.imageCompressQuality,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: quality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (images.length > maxCount) {
        throw const ValidationException(
          message: '最多只能选择${AppConstants.maxImageCount}张图片',
        );
      }

      final mediaFiles = <MediaFile>[];
      for (final image in images) {
        final file = File(image.path);
        final compressedFile = await _compressImage(
          file,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          quality: quality,
        );

        final imageBytes = await compressedFile.readAsBytes();
        final decodedImage = await decodeImageFromList(imageBytes);

        mediaFiles.add(MediaFile(
          id: image.name,
          path: compressedFile.path,
          type: MediaType.image,
          width: decodedImage.width,
          height: decodedImage.height,
          size: imageBytes.length,
          createdAt: DateTime.now(),
        ));
      }

      AppLogger.info('Picked ${mediaFiles.length} images');
      return mediaFiles;
    } catch (e) {
      AppLogger.error('Failed to pick images', error: e);
      if (e is ValidationException) rethrow;
      throw const UnknownException(message: '选择图片失败');
    }
  }

  Future<MediaFile?> pickImage({
    int maxWidth = AppConstants.imageMaxWidth,
    int maxHeight = AppConstants.imageMaxHeight,
    int quality = AppConstants.imageCompressQuality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: quality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (image == null) return null;

      final file = File(image.path);
      final compressedFile = await _compressImage(
        file,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        quality: quality,
      );

      final imageBytes = await compressedFile.readAsBytes();
      final decodedImage = await decodeImageFromList(imageBytes);

      return MediaFile(
        id: image.name,
        path: compressedFile.path,
        type: MediaType.image,
        width: decodedImage.width,
        height: decodedImage.height,
        size: imageBytes.length,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Failed to pick image', error: e);
      throw const UnknownException(message: '选择图片失败');
    }
  }

  Future<MediaFile?> takePhoto({
    int maxWidth = AppConstants.imageMaxWidth,
    int maxHeight = AppConstants.imageMaxHeight,
    int quality = AppConstants.imageCompressQuality,
  }) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: quality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (photo == null) return null;

      final file = File(photo.path);
      final compressedFile = await _compressImage(
        file,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        quality: quality,
      );

      final imageBytes = await compressedFile.readAsBytes();
      final decodedImage = await decodeImageFromList(imageBytes);

      return MediaFile(
        id: photo.name,
        path: compressedFile.path,
        type: MediaType.image,
        width: decodedImage.width,
        height: decodedImage.height,
        size: imageBytes.length,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Failed to take photo', error: e);
      throw const UnknownException(message: '拍照失败');
    }
  }

  Future<File> _compressImage(
    File file, {
    required int maxWidth,
    required int maxHeight,
    required int quality,
  }) async {
    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${file.parent.path}/compressed_${file.uri.pathSegments.last}',
        quality: quality,
        minWidth: maxWidth,
        minHeight: maxHeight,
        format: CompressFormat.jpeg,
        keepExif: true,
      );

      return compressedFile ?? file;
    } catch (e) {
      AppLogger.warning('Failed to compress image, using original', error: e);
      return file;
    }
  }

  Future<List<MediaFile>> pickFromGallery({
    int maxCount = AppConstants.maxImageCount,
  }) async {
    try {
      final PermissionState permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        throw const PermissionDeniedException(message: '请授权访问相册');
      }

      final List<AssetEntity> assets = await PhotoManager.getAssetListRange(
        start: 0,
        end: maxCount,
      );

      final mediaFiles = <MediaFile>[];
      for (final asset in assets) {
        final file = await asset.file;
        if (file == null) continue;

        final imageBytes = await file.readAsBytes();
        final decodedImage = await decodeImageFromList(imageBytes);

        mediaFiles.add(MediaFile(
          id: asset.id,
          path: file.path,
          type: asset.type == AssetType.image ? MediaType.image : MediaType.video,
          width: decodedImage.width,
          height: decodedImage.height,
          size: imageBytes.length,
          createdAt: asset.createDateTime,
        ));
      }

      return mediaFiles;
    } catch (e) {
      AppLogger.error('Failed to pick from gallery', error: e);
      if (e is PermissionDeniedException) rethrow;
      throw const UnknownException(message: '从相册选择失败');
    }
  }
}