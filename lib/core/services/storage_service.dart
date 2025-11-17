import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class StorageService {
  StorageService({required this.bucket});

  final String bucket;

  SupabaseClient get _client => SupabaseService.client;

  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    FileOptions? fileOptions,
  }) async {
    return _client.storage
        .from(bucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: fileOptions ?? const FileOptions(),
        );
  }
}
