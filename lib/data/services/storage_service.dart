import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'supabase_service.dart';

class StorageService {
  static final Dio _dio = Dio();
  
  // Download file from URL
  static Future<String?> downloadFile(
    String url, 
    String filename, {
    Function(int, int)? onProgress,
  }) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status != PermissionStatus.granted) {
          debugPrint('Storage permission denied');
          return null;
        }
      }
      
      // Get downloads directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }
      
      final filePath = '${downloadsDir.path}/$filename';
      
      // Download file
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: onProgress,
      );
      
      debugPrint('File downloaded to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }
  
  // Open downloaded file
  static Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        debugPrint('Error opening file: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }
  
  // Download and open file
  static Future<void> downloadAndOpenFile(
    String url, 
    String filename, {
    Function(int, int)? onProgress,
  }) async {
    final filePath = await downloadFile(url, filename, onProgress: onProgress);
    if (filePath != null) {
      await openFile(filePath);
    }
  }
  
  // Upload file to Supabase Storage
  static Future<String?> uploadFile(
    String bucketName,
    String filePath,
    File file,
  ) async {
    try {
      final response = await SupabaseService.storage
          .from(bucketName)
          .upload(filePath, file);
      
      if (response.isNotEmpty) {
        // Get public URL
        final publicUrl = SupabaseService.storage
            .from(bucketName)
            .getPublicUrl(filePath);
        
        return publicUrl;
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }
  
  // Delete file from Supabase Storage
  static Future<bool> deleteFile(String bucketName, String filePath) async {
    try {
      await SupabaseService.storage
          .from(bucketName)
          .remove([filePath]);
      return true;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }
  
  // Get file size in human readable format
  static String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
