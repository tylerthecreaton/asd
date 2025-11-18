import 'package:equatable/equatable.dart';
import 'package:asd/features/authentication/domain/entities/user.dart';
import 'package:asd/features/questionnaire/domain/entities/assessment_result.dart';

enum RiskLevel { low, medium, high }

enum AssessmentType { questionnaire, videoAnalysis }

class MonthlyAssessmentCount {
  final String month;
  final int questionnaireCount;
  final int videoAnalysisCount;

  const MonthlyAssessmentCount({
    required this.month,
    required this.questionnaireCount,
    required this.videoAnalysisCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyAssessmentCount &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          questionnaireCount == other.questionnaireCount &&
          videoAnalysisCount == other.videoAnalysisCount;

  @override
  int get hashCode => month.hashCode ^ questionnaireCount.hashCode ^ videoAnalysisCount.hashCode;
}

class RiskLevelDistribution {
  final int lowRiskCount;
  final int mediumRiskCount;
  final int highRiskCount;

  const RiskLevelDistribution({
    required this.lowRiskCount,
    required this.mediumRiskCount,
    required this.highRiskCount,
  });

  int get total => lowRiskCount + mediumRiskCount + highRiskCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiskLevelDistribution &&
          runtimeType == other.runtimeType &&
          lowRiskCount == other.lowRiskCount &&
          mediumRiskCount == other.mediumRiskCount &&
          highRiskCount == other.highRiskCount;

  @override
  int get hashCode =>
      lowRiskCount.hashCode ^ mediumRiskCount.hashCode ^ highRiskCount.hashCode;
}

class ChildProfile extends Equatable {
  final String id;
  final String name;
  final DateTime birthDate;
  final String? profileImageUrl;
  final List<AssessmentSummary> assessments;

  const ChildProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    this.profileImageUrl,
    this.assessments = const [],
  });

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
  }

  @override
  List<Object?> get props => [id, name, birthDate, profileImageUrl, assessments];
}

class AssessmentSummary extends Equatable {
  final String id;
  final AssessmentType type;
  final DateTime completedAt;
  final RiskLevel riskLevel;
  final int score;
  final String? childName;
  final String? childId;

  const AssessmentSummary({
    required this.id,
    required this.type,
    required this.completedAt,
    required this.riskLevel,
    required this.score,
    this.childName,
    this.childId,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    completedAt,
    riskLevel,
    score,
    childName,
    childId,
  ];
}

class UserStatistics extends Equatable {
  final int totalAssessments;
  final int questionnaireCount;
  final int videoAnalysisCount;
  final DateTime? lastAssessmentDate;
  final RiskLevel? latestRiskLevel;
  final List<MonthlyAssessmentCount> monthlyStats;
  final RiskLevelDistribution riskDistribution;

  const UserStatistics({
    required this.totalAssessments,
    required this.questionnaireCount,
    required this.videoAnalysisCount,
    this.lastAssessmentDate,
    this.latestRiskLevel,
    this.monthlyStats = const [],
    required this.riskDistribution,
  });

  @override
  List<Object?> get props => [
    totalAssessments,
    questionnaireCount,
    videoAnalysisCount,
    lastAssessmentDate,
    latestRiskLevel,
    monthlyStats,
    riskDistribution,
  ];
}

class UserPreferences extends Equatable {
  final String language;
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final String theme;

  const UserPreferences({
    required this.language,
    this.notificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.pushNotificationsEnabled = true,
    this.theme = 'light',
  });

  @override
  List<Object?> get props => [
    language,
    notificationsEnabled,
    emailNotificationsEnabled,
    pushNotificationsEnabled,
    theme,
  ];
}

class ProfileData extends Equatable {
  final User user;
  final UserStatistics statistics;
  final List<AssessmentSummary> recentAssessments;
  final List<ChildProfile> children;
  final UserPreferences preferences;

  const ProfileData({
    required this.user,
    required this.statistics,
    this.recentAssessments = const [],
    this.children = const [],
    required this.preferences,
  });

  @override
  List<Object?> get props => [
    user,
    statistics,
    recentAssessments,
    children,
    preferences,
  ];
}

class QuickAction extends Equatable {
  final QuickActionType type;
  final String title;
  final String subtitle;
  final String icon;
  final String route;

  const QuickAction({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  List<Object?> get props => [type, title, subtitle, icon, route];
}

enum QuickActionType {
  startQuestionnaire,
  startVideoAnalysis,
  viewAllResults,
  addChild,
  editProfile,
}

class SettingsOption extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String icon;
  final String route;
  final bool isToggle;
  final bool? toggleValue;

  const SettingsOption({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.route,
    this.isToggle = false,
    this.toggleValue,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    icon,
    route,
    isToggle,
    toggleValue,
  ];
}