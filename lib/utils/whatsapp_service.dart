import 'package:url_launcher/url_launcher.dart';

/// Service to handle WhatsApp deep linking
class WhatsAppService {
  /// Opens WhatsApp with a phone number and optional message
  /// 
  /// [phoneNumber] - Phone number in international format (e.g., "2135551234567")
  ///                  or local format (will be cleaned automatically)
  /// [message] - Optional pre-filled message
  /// 
  /// Returns true if WhatsApp was opened successfully, false otherwise
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      // Clean phone number (remove spaces, dashes, parentheses, plus signs)
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

      // Ensure number starts with country code (Algeria)
      if (cleanPhone.startsWith('0') && cleanPhone.length == 10) {
        cleanPhone = '213' + cleanPhone.substring(1);
      } else if (!cleanPhone.startsWith('213')) {
        // fallback: if user typed +213 or anything else, force to 213 prefix
        cleanPhone = cleanPhone.replaceFirst(RegExp('^(\+)?'), '213');
      }

      // Build WhatsApp URL
      String url = 'https://wa.me/$cleanPhone';
      if (message != null && message.isNotEmpty) {
        // URL encode the message
        final encodedMessage = Uri.encodeComponent(message);
        url += '?text=$encodedMessage';
      }
      
      final uri = Uri.parse(url);
      
      // Check if WhatsApp can be launched
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return launched;
      } else {
        print('❌ Cannot launch WhatsApp URL: $url');
        return false;
      }
    } catch (e) {
      print('❌ Error opening WhatsApp: $e');
      return false;
    }
  }
  
  /// Opens WhatsApp with a pre-filled message (without phone number)
  /// Useful for general WhatsApp contact
  static Future<bool> openWhatsAppWithMessage(String message) async {
    try {
      final encodedMessage = Uri.encodeComponent(message);
      final uri = Uri.parse('https://wa.me/?text=$encodedMessage');
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      print('❌ Error opening WhatsApp: $e');
      return false;
    }
  }
}

