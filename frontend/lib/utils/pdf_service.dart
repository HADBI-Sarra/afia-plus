import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service to handle PDF file operations (upload, download, view)
class PDFService {
  static const String _prescriptionFolder = 'prescriptions';
  
  /// Get the app's documents directory for storing PDFs
  static Future<Directory> _getPrescriptionDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final prescriptionDir = Directory(path.join(appDocDir.path, _prescriptionFolder));
    
    if (!await prescriptionDir.exists()) {
      await prescriptionDir.create(recursive: true);
    }
    
    return prescriptionDir;
  }

  /// Copy uploaded PDF file to app's documents directory
  /// Returns the stored file path
  static Future<String> saveUploadedPDF(File sourceFile, int consultationId) async {
    try {
      final prescriptionDir = await _getPrescriptionDirectory();
      final fileName = 'prescription_$consultationId.pdf';
      final destinationFile = File(path.join(prescriptionDir.path, fileName));
      
      // Copy the file
      await sourceFile.copy(destinationFile.path);
      
      // Return the stored path (relative path for database storage)
      return 'prescriptions/$fileName';
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  /// Get the full file path from stored path
  static Future<File?> getPDFFile(String storedPath) async {
    try {
      // Check if it's an asset path
      if (storedPath.startsWith('assets/')) {
        // For assets, we can't return a File, but we can handle it in the UI
        return null;
      }
      
      // Check if it's a relative path (prescriptions/...)
      if (storedPath.startsWith('prescriptions/')) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final fullPath = path.join(appDocDir.path, storedPath);
        final file = File(fullPath);
        
        if (await file.exists()) {
          return file;
        }
      }
      
      // Try as absolute path
      final file = File(storedPath);
      if (await file.exists()) {
        return file;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if PDF path is an asset
  static bool isAssetPath(String? path) {
    return path != null && path.startsWith('assets/');
  }

  /// Get asset path for loading from assets
  static String? getAssetPath(String? storedPath) {
    if (isAssetPath(storedPath)) {
      return storedPath;
    }
    return null;
  }

  /// Copy PDF to downloads directory for sharing/downloading
  static Future<File?> copyToDownloads(File sourceFile, String fileName) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory(path.join(appDocDir.path, 'Downloads'));
      
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      final destination = File(path.join(downloadsDir.path, fileName));
      await sourceFile.copy(destination.path);
      return destination;
    } catch (e) {
      // Fallback to app documents root
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final destination = File(path.join(appDocDir.path, fileName));
        await sourceFile.copy(destination.path);
        return destination;
      } catch (e2) {
        return null;
      }
    }
  }
}

