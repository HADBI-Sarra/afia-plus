import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration and initialization
class SupabaseConfig {
  static const String supabaseUrl = 'https://usyjkxfolmfyzrtxvivl.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzeWpreGZvbG1meXpydHh2aXZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY0NDk2NDcsImV4cCI6MjA1MjAyNTY0N30.L4IrSo1zTj6Ue3VbXOY-CdJwf0rz4M-VGWzQHcDz-Tc';

  // Service role key for storage operations (bypasses RLS)
  static const String supabaseServiceKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzeWpreGZvbG1meXpydHh2aXZsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzAyOTc4NCwiZXhwIjoyMDgyNjA1Nzg0fQ.EkJIG8_CavLL--tpnbJnZWZdzyogH35o3X2HFvPazyo';

  /// Prescription storage bucket name
  static const String prescriptionsBucket = 'prescriptions';

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  /// Get Supabase client instance (for general use)
  static SupabaseClient get client => Supabase.instance.client;

  /// Get Storage client with service role (for uploads - bypasses RLS)
  static SupabaseStorageClient get storage {
    // Create a client with service role key for storage operations
    final serviceClient = SupabaseClient(supabaseUrl, supabaseServiceKey);
    return serviceClient.storage;
  }
}
