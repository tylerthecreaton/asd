import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/assessment_result.dart';
import '../entities/questionnaire.dart';
import '../entities/response.dart' as response_entity;

abstract class QuestionnaireRepository {
  Future<Either<Failure, Questionnaire>> fetchQuestionnaire(String identifier);
  Future<Either<Failure, List<Questionnaire>>> fetchQuestionnaires();
  Future<Either<Failure, AssessmentResult>> submitResponses({
    required String identifier,
    required List<response_entity.Response> responses,
  });
  Future<Either<Failure, List<AssessmentResult>>> fetchResults();
  Future<Either<Failure, AssessmentResult>> fetchResultById(String id);
}
