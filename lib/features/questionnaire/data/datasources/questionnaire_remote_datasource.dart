import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/assessment_result_model.dart';
import '../models/questionnaire_model.dart';

abstract class QuestionnaireRemoteDataSource {
  Future<List<QuestionnaireModel>> fetchQuestionnaires();
  Future<QuestionnaireModel> fetchQuestionnaire(String identifier);
  Future<AssessmentResultModel> submitResponses({
    required String identifier,
    required List<Map<String, dynamic>> answers,
  });
  Future<List<AssessmentResultModel>> fetchResults();
  Future<AssessmentResultModel> fetchResultById(String id);
}

class QuestionnaireRemoteDataSourceImpl
    implements QuestionnaireRemoteDataSource {
  QuestionnaireRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<QuestionnaireModel>> fetchQuestionnaires() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.questionnairesPath,
      );
      final items = response.data?['questionnaires'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(QuestionnaireModel.fromJson)
            .toList(growable: false);
      }
      throw const ServerException(message: 'Invalid questionnaires response');
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Unable to load questionnaires');
    }
  }

  @override
  Future<QuestionnaireModel> fetchQuestionnaire(String identifier) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.questionnaireDetailPath(identifier),
      );
      final questionnaire = response.data?['questionnaire'];
      if (questionnaire is Map<String, dynamic>) {
        return QuestionnaireModel.fromJson(questionnaire);
      }
      throw const ServerException(message: 'Questionnaire not found');
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Unable to load questionnaire');
    }
  }

  @override
  Future<AssessmentResultModel> submitResponses({
    required String identifier,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.questionnaireSubmissionPath(identifier),
        data: {'answers': answers},
      );
      final data = response.data?['result'];
      if (data is Map<String, dynamic>) {
        return AssessmentResultModel.fromJson(data);
      }
      throw const ServerException(message: 'Invalid submission response');
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Unable to submit questionnaire');
    }
  }

  @override
  Future<List<AssessmentResultModel>> fetchResults() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.resultsPath,
      );
      final items = response.data?['results'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(AssessmentResultModel.fromJson)
            .toList(growable: false);
      }
      throw const ServerException(message: 'Invalid results response');
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Unable to load results');
    }
  }

  @override
  Future<AssessmentResultModel> fetchResultById(String id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.resultDetailPath(id),
      );
      final data = response.data?['result'];
      if (data is Map<String, dynamic>) {
        return AssessmentResultModel.fromJson(data);
      }
      throw const ServerException(message: 'Result not found');
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Unable to load result detail');
    }
  }

  String _resolveErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    return error.message ?? 'Network error';
  }
}
