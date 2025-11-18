import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/features/common/domain/entities/profile_data.dart';
import 'package:asd/features/common/domain/repositories/profile_repository.dart';
import 'package:asd/features/common/data/providers/profile_dependencies.dart';

enum ProfileStatus { initial, loading, loaded, updating, error }

class ProfileState {
  final ProfileStatus status;
  final ProfileData? data;
  final String? errorMessage;
  final Failure? failure;

  const ProfileState({
    required this.status,
    this.data,
    this.errorMessage,
    this.failure,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileData? data,
    String? errorMessage,
    Failure? failure,
  }) {
    return ProfileState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          data == other.data &&
          errorMessage == other.errorMessage &&
          failure == other.failure;

  @override
  int get hashCode =>
      status.hashCode ^
      data.hashCode ^
      errorMessage.hashCode ^
      failure.hashCode;
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository)
    : super(const ProfileState(status: ProfileStatus.initial));

  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _repository.getProfileData();

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        failure: failure,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (profileData) => state = state.copyWith(
        status: ProfileStatus.loaded,
        data: profileData,
      ),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? profileImageUrl,
    UserPreferences? preferences,
  }) async {
    state = state.copyWith(status: ProfileStatus.updating);

    final currentData = state.data;
    if (currentData == null) return;

    final updatedUser = currentData.user.copyWith(name: name, email: email);

    final updatedPreferences = preferences ?? currentData.preferences;

    final updatedProfileData = ProfileData(
      user: updatedUser,
      statistics: currentData.statistics,
      recentAssessments: currentData.recentAssessments,
      children: currentData.children,
      preferences: updatedPreferences,
    );

    final result = await _repository.updateProfileData(updatedProfileData);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        failure: failure,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (_) => state = state.copyWith(
        status: ProfileStatus.loaded,
        data: updatedProfileData,
      ),
    );
  }

  Future<void> uploadProfileImage(String imagePath) async {
    state = state.copyWith(status: ProfileStatus.updating);

    final result = await _repository.uploadProfileImage(imagePath);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        failure: failure,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (imageUrl) async {
        final currentData = state.data;
        if (currentData != null) {
          await updateProfile(profileImageUrl: imageUrl);
        }
      },
    );
  }

  Future<void> addChild(ChildProfile child) async {
    state = state.copyWith(status: ProfileStatus.updating);

    final result = await _repository.addChild(child);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        failure: failure,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (_) async {
        final currentData = state.data;
        if (currentData != null) {
          final updatedChildren = [...currentData.children, child];
          final updatedProfileData = ProfileData(
            user: currentData.user,
            statistics: currentData.statistics,
            recentAssessments: currentData.recentAssessments,
            children: updatedChildren,
            preferences: currentData.preferences,
          );

          state = state.copyWith(
            status: ProfileStatus.loaded,
            data: updatedProfileData,
          );
        }
      },
    );
  }

  Future<void> updateChild(ChildProfile child) async {
    state = state.copyWith(status: ProfileStatus.updating);

    final result = await _repository.updateChild(child);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        failure: failure,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (_) async {
        final currentData = state.data;
        if (currentData != null) {
          final updatedChildren = currentData.children
              .map((c) => c.id == child.id ? child : c)
              .toList();
          final updatedProfileData = ProfileData(
            user: currentData.user,
            statistics: currentData.statistics,
            recentAssessments: currentData.recentAssessments,
            children: updatedChildren,
            preferences: currentData.preferences,
          );

          state = state.copyWith(
            status: ProfileStatus.loaded,
            data: updatedProfileData,
          );
        }
      },
    );
  }

  Future<void> deleteChild(String childId) async {
    state = state.copyWith(status: ProfileStatus.updating);

    final result = await _repository.deleteChild(childId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        failure: failure,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (_) async {
        final currentData = state.data;
        if (currentData != null) {
          final updatedChildren = currentData.children
              .where((c) => c.id != childId)
              .toList();
          final updatedProfileData = ProfileData(
            user: currentData.user,
            statistics: currentData.statistics,
            recentAssessments: currentData.recentAssessments,
            children: updatedChildren,
            preferences: currentData.preferences,
          );

          state = state.copyWith(
            status: ProfileStatus.loaded,
            data: updatedProfileData,
          );
        }
      },
    );
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  void clearError() {
    state = state.copyWith(
      status: ProfileStatus.loaded,
      errorMessage: null,
      failure: null,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'เกิดข้อผิดพลาดในการเชื่อมต่อเครือข่าย กรุณาลองใหม่อีกครั้ง';
      case ServerFailure:
        return 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ กรุณาลองใหม่ภายหลัง';
      case ValidationFailure:
        return 'ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบและลองใหม่';
      case NotFoundFailure:
        return 'ไม่พบข้อมูลที่ค้นหา';
      case PermissionDeniedFailure:
        return 'คุณไม่มีสิทธิในการดำเนินการนี้';
      default:
        return 'เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาติดต่อผู้ดูแลระบบ';
    }
  }
}

// Provider instances - now using centralized dependencies
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});

final profileDataStreamProvider = StreamProvider<ProfileData?>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileDataStream();
});
