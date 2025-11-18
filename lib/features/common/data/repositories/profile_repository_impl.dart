import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/core/network/network_info.dart';
import 'package:asd/features/common/domain/entities/profile_data.dart';
import 'package:asd/features/common/domain/repositories/profile_repository.dart';
import 'package:asd/features/common/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, ProfileData>> getProfileData() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // Fetch user profile data
      final userModel = await remoteDataSource.getProfile();

      // Fetch user statistics
      final statsModel = await remoteDataSource.getUserStats();

      // Convert to domain entities
      final profileData = ProfileData(
        user: userModel,
        statistics: statsModel.toUserStatistics(),
        recentAssessments: [], // Will be fetched from assessment history
        children:
            [], // TODO: Implement children management when backend is ready
        preferences: const UserPreferences(
          language: 'th',
          notificationsEnabled: true,
          emailNotificationsEnabled: true,
          pushNotificationsEnabled: true,
          theme: 'light',
        ),
      );

      return Right(profileData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthenticationFailure('Unauthorized'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to fetch profile data'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<ProfileData?> getProfileDataStream() {
    // Mock stream implementation - return a stream that emits the current profile data
    return Stream.fromFuture(
      getProfileData().then(
        (result) =>
            result.fold((failure) => null, (profileData) => profileData),
      ),
    );
  }

  @override
  Future<Either<Failure, ProfileData>> updateProfileData(
    ProfileData profileData,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // Update user profile (currently only name is supported by backend)
      final updatedUser = await remoteDataSource.updateProfile(
        name: profileData.user.name,
      );

      // Return updated profile data
      final updatedProfileData = ProfileData(
        user: updatedUser,
        statistics: profileData.statistics,
        recentAssessments: profileData.recentAssessments,
        children: profileData.children,
        preferences: profileData.preferences,
      );

      return Right(updatedProfileData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthenticationFailure('Unauthorized'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to update profile'));
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
