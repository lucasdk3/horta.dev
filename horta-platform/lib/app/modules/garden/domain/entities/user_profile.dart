import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String country;
  final bool isAdmin;
  final int xp;
  final int level;
  final List<String> badges;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.country = '',
    this.isAdmin = false,
    this.xp = 0,
    this.level = 1,
    this.badges = const [],
  });

  /// XP needed to reach the next level
  int get xpToNextLevel => level * 100;

  /// Progress percentage (0.0 – 1.0)
  double get progressPercent =>
      (xp / xpToNextLevel).clamp(0.0, 1.0).toDouble();

  /// Botanical stage label — mirrors React's garden.stage translation keys
  String get stageName {
    if (level >= 5) return 'Árvore';
    if (level >= 2) return 'Broto';
    return 'Semente';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        uid: json['uid'] ?? '',
        email: json['email'] ?? '',
        displayName: json['displayName'] ?? json['email'] ?? '',
        photoUrl: json['photoURL'] ?? json['photoUrl'],
        country: json['country'] ?? '',
        isAdmin: json['isAdmin'] ?? false,
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        badges: List<String>.from(json['badges'] ?? []),
      );

  @override
  List<Object?> get props =>
      [uid, email, displayName, isAdmin, xp, level, badges];
}

class SurveyRequest extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? suggestedCategory;
  final String requesterId;
  final String requesterEmail;
  final String status; // 'pending' | 'approved' | 'rejected'
  final DateTime? createdAt;

  const SurveyRequest({
    required this.id,
    required this.title,
    required this.description,
    this.suggestedCategory,
    required this.requesterId,
    required this.requesterEmail,
    this.status = 'pending',
    this.createdAt,
  });

  factory SurveyRequest.fromJson(Map<String, dynamic> json) => SurveyRequest(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        suggestedCategory: json['suggestedCategory'],
        requesterId: json['requesterId'] ?? '',
        requesterEmail: json['requesterEmail'] ?? '',
        status: json['status'] ?? 'pending',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );

  @override
  List<Object?> get props =>
      [id, title, description, status, requesterId, createdAt];
}
