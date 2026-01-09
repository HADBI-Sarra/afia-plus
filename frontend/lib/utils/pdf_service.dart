import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:afia_plus_app/config/supabase_config.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to handle PDF file operations (upload, download, view)
class PDFService {
  static const String _prescriptionFolder = 'prescriptions';

  /// Upload PDF to Supabase Storage
  /// Returns the public URL of the uploaded file
  static Future<String> uploadToSupabase(
    File pdfFile,
    int consultationId,
  ) async {
    try {
      final fileName = 'prescription_$consultationId.pdf';
      final fileBytes = await pdfFile.readAsBytes();

      // Upload to Supabase Storage
      await SupabaseConfig.storage
          .from(SupabaseConfig.prescriptionsBucket)
          .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(
              upsert: true, // Replace if exists
              contentType: 'application/pdf',
            ),
          );

      // Get public URL
      final publicUrl = SupabaseConfig.storage
          .from(SupabaseConfig.prescriptionsBucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload PDF to cloud: $e');
    }
  }

  /// Download PDF from Supabase Storage URL and save locally
  /// Returns the local file
  static Future<File> downloadFromSupabase(
    String publicUrl,
    int consultationId,
  ) async {
    try {
      // Download the file
      final response = await http.get(Uri.parse(publicUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }

      // Save to local directory
      final prescriptionDir = await _getPrescriptionDirectory();
      final fileName = 'prescription_$consultationId.pdf';
      final localFile = File(path.join(prescriptionDir.path, fileName));

      await localFile.writeAsBytes(response.bodyBytes);

      return localFile;
    } catch (e) {
      throw Exception('Failed to download PDF: $e');
    }
  }

  /// Check if a PDF is already cached locally
  static Future<File?> getCachedPDF(int consultationId) async {
    try {
      final prescriptionDir = await _getPrescriptionDirectory();
      final fileName = 'prescription_$consultationId.pdf';
      final localFile = File(path.join(prescriptionDir.path, fileName));

      if (await localFile.exists()) {
        return localFile;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get the app's documents directory for storing PDFs
  static Future<Directory> _getPrescriptionDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final prescriptionDir = Directory(
      path.join(appDocDir.path, _prescriptionFolder),
    );

    if (!await prescriptionDir.exists()) {
      await prescriptionDir.create(recursive: true);
    }

    return prescriptionDir;
  }

  /// Copy uploaded PDF file to app's documents directory
  /// Returns the stored file path
  static Future<String> saveUploadedPDF(
    File sourceFile,
    int consultationId,
  ) async {
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

  /// Check if path is a Supabase URL
  static bool isSupabaseUrl(String? path) {
    return path != null &&
        (path.startsWith('http://') || path.startsWith('https://'));
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
