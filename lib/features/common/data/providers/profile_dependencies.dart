import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asd/core/network/network_providers.dart';
import 'package:asd/core/network/api_client_provider.dart';
import 'package:asd/features/common/data/datasources/profile_remote_datasource.dart';
import 'package:asd/features/common/data/repositories/profile_repository_impl.dart';
import 'package:asd/features/common/domain/repositories/profile_repository.dart';

// Profile Remote DataSource Provider
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSourceImpl(apiClient);
});

// Profile Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ProfileRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});
