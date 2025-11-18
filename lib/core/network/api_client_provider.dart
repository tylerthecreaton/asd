import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/providers/storage_providers.dart';
import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(tokenStorage: ref.watch(tokenStorageProvider));
});
