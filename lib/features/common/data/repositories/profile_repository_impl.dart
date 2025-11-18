import 'package:dartz/dartz.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/features/common/domain/entities/profile_data.dart';
import 'package:asd/features/common/domain/repositories/profile_repository.dart';
import 'package:asd/features/authentication/domain/entities/user.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Either<Failure, ProfileData>> getProfileData() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data for now
      final mockProfileData = ProfileData(
        user: const User(
          id: '1',
          email: 'user@example.com',
          name: 'สมชิล ใจ',
        ),
        statistics: const UserStatistics(
          totalAssessments: 12,
          questionnaireCount: 8,
          videoAnalysisCount: 4,
          lastAssessmentDate: null,
          latestRiskLevel: RiskLevel.low,
          monthlyStats: [
            MonthlyAssessmentCount(
              month: 'มกราคม',
              questionnaireCount: 3,
              videoAnalysisCount: 1,
            ),
            MonthlyAssessmentCount(
              month: 'กุมภาพันธ์',
              questionnaireCount: 2,
              videoAnalysisCount: 1,
            ),
          ],
          riskDistribution: const RiskLevelDistribution(
            lowRiskCount: 8,
            mediumRiskCount: 3,
            highRiskCount: 1,
          ),
        ),
        recentAssessments: [
          AssessmentSummary(
            id: '1',
            type: AssessmentType.questionnaire,
            completedAt: DateTime.now().subtract(const Duration(days: 5)),
            riskLevel: RiskLevel.low,
            score: 2,
            childName: 'มิณฐรัตน์',
          ),
          AssessmentSummary(
            id: '2',
            type: AssessmentType.videoAnalysis,
            completedAt: DateTime.now().subtract(const Duration(days: 10)),
            riskLevel: RiskLevel.medium,
            score: 5,
            childName: 'มานิตา',
          ),
          AssessmentSummary(
            id: '3',
            type: AssessmentType.questionnaire,
            completedAt: DateTime.now().subtract(const Duration(days: 15)),
            riskLevel: RiskLevel.low,
            score: 1,
            childName: 'มิณฐรัตน์',
          ),
        ],
        children: [
          ChildProfile(
            id: '1',
            name: 'มิณฐรัตน์',
            birthDate: DateTime.now().subtract(const Duration(days: 730)),
            profileImageUrl: null,
            assessments: [],
          ),
          ChildProfile(
            id: '2',
            name: 'มานิตา',
            birthDate: DateTime.now().subtract(const Duration(days: 365)),
            profileImageUrl: null,
            assessments: [],
          ),
        ],
        preferences: const UserPreferences(
          language: 'th',
          notificationsEnabled: true,
          emailNotificationsEnabled: true,
          pushNotificationsEnabled: true,
          theme: 'light',
        ),
      );
      
      return Right(mockProfileData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<ProfileData?> getProfileDataStream() {
    // Mock stream implementation - return a stream that emits the current profile data
    return Stream.fromFuture(getProfileData().then(
      (result) => result.fold(
        (failure) => null,
        (profileData) => profileData,
      ),
    ));
  }

  @override
  Future<Either<Failure, ProfileData>> updateProfileData(ProfileData profileData) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock successful update
      return Right(profileData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // Mock successful upload
      final mockImageUrl = 'https://example.com/profile_image.jpg';
      return Right(mockImageUrl);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addChild(ChildProfile child) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock successful addition
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateChild(ChildProfile child) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock successful update
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChild(String childId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock successful deletion
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AssessmentSummary>>> getAssessmentHistory({
    String? childId,
    int? limit,
    int? offset,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock assessment history
      final mockAssessments = [
        AssessmentSummary(
          id: '1',
          type: AssessmentType.questionnaire,
          completedAt: DateTime.now().subtract(const Duration(days: 5)),
          riskLevel: RiskLevel.low,
          score: 2,
          childName: 'มิณฐรัตน์',
        ),
        AssessmentSummary(
          id: '2',
          type: AssessmentType.videoAnalysis,
          completedAt: DateTime.now().subtract(const Duration(days: 10)),
          riskLevel: RiskLevel.medium,
          score: 5,
          childName: 'มานิตา',
        ),
        AssessmentSummary(
          id: '3',
          type: AssessmentType.questionnaire,
          completedAt: DateTime.now().subtract(const Duration(days: 15)),
          riskLevel: RiskLevel.low,
          score: 1,
          childName: 'มิณฐรัตน์',
        ),
        AssessmentSummary(
          id: '4',
          type: AssessmentType.questionnaire,
          completedAt: DateTime.now().subtract(const Duration(days: 20)),
          riskLevel: RiskLevel.medium,
          score: 4,
          childName: 'มานิตา',
        ),
        AssessmentSummary(
          id: '5',
          type: AssessmentType.videoAnalysis,
          completedAt: DateTime.now().subtract(const Duration(days: 25)),
          riskLevel: RiskLevel.high,
          score: 8,
          childName: 'มิณฐรัตน์',
        ),
      ];
      
      return Right(mockAssessments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // Mock successful deletion
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}