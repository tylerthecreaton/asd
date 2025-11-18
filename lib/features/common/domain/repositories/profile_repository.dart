import 'package:dartz/dartz.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/features/common/domain/entities/profile_data.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileData>> getProfileData();
  Stream<ProfileData?> getProfileDataStream();
  Future<Either<Failure, ProfileData>> updateProfileData(ProfileData profileData);
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);
  Future<Either<Failure, void>> addChild(ChildProfile child);
  Future<Either<Failure, void>> updateChild(ChildProfile child);
  Future<Either<Failure, void>> deleteChild(String childId);
  Future<Either<Failure, List<AssessmentSummary>>> getAssessmentHistory({
    String? childId,
    int? limit,
    int? offset,
  });
  Future<Either<Failure, void>> deleteAccount();
}