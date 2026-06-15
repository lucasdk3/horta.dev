import 'package:equatable/equatable.dart';

class SurveyRequest extends Equatable {
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

  final String id;
  final String title;
  final String description;
  final String? suggestedCategory;
  final String requesterId;
  final String requesterEmail;
  final String status;
  final DateTime? createdAt;

  factory SurveyRequest.fromJson(Map<String, dynamic> json) => SurveyRequest(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        suggestedCategory: json['suggestedCategory'] as String?,
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
