import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/questionnaire_remote_datasource.dart';
import '../../data/repositories/questionnaire_repository_impl.dart';
import '../../domain/repositories/questionnaire_repository.dart';

final questionnaireRemoteDataSourceProvider =
    Provider<QuestionnaireRemoteDataSource>((ref) {
      return QuestionnaireRemoteDataSourceImpl(ref.watch(apiClientProvider));
    });

final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>((
  ref,
) {
  return QuestionnaireRepositoryImpl(
    remoteDataSource: ref.watch(questionnaireRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});
