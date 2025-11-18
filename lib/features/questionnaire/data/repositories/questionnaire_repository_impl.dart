import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/assessment_result.dart';
import '../../domain/entities/questionnaire.dart';
import '../../domain/entities/response.dart' as response_entity;
import '../../domain/repositories/questionnaire_repository.dart';
import '../datasources/questionnaire_remote_datasource.dart';

class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  QuestionnaireRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final QuestionnaireRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Questionnaire>> fetchQuestionnaire(
    String identifier,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final questionnaire = await remoteDataSource.fetchQuestionnaire(
        identifier,
      );
      return Right(questionnaire);
    } on ServerException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Failed to load questionnaire'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Questionnaire>>> fetchQuestionnaires() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final questionnaires = await remoteDataSource.fetchQuestionnaires();
      return Right(questionnaires);
    } on ServerException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Failed to load questionnaires'),
      );
    }
  }

  @override
  Future<Either<Failure, AssessmentResult>> submitResponses({
    required String identifier,
    required List<response_entity.Response> responses,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final answers = responses
          .map(
            (response) => {
              'questionId': response.questionId,
              'answerIndex': response.answerIndex,
            },
          )
          .toList(growable: false);
      final result = await remoteDataSource.submitResponses(
        identifier: identifier,
        answers: answers,
      );
      return Right(result);
    } on ServerException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Failed to submit questionnaire'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AssessmentResult>>> fetchResults() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final results = await remoteDataSource.fetchResults();
      return Right(results);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to load results'));
    }
  }

  @override
  Future<Either<Failure, AssessmentResult>> fetchResultById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final result = await remoteDataSource.fetchResultById(id);
      return Right(result);
    } on ServerException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Failed to load result detail'),
      );
    }
  }
}
