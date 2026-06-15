import 'package:equatable/equatable.dart';

class SurveyResponse extends Equatable {
  final String id;
  final String surveyId;
  final String respondentId;
  final String respondentEmail;
  final String country;
  final Map<String, dynamic> answers;
  final DateTime? createdAt;

  const SurveyResponse({
    required this.id,
    required this.surveyId,
    required this.respondentId,
    required this.respondentEmail,
    required this.country,
    required this.answers,
    this.createdAt,
  });

  factory SurveyResponse.fromJson(Map<String, dynamic> json) => SurveyResponse(
        id: json['id'] ?? '',
        surveyId: json['surveyId'] ?? '',
        respondentId: json['respondentId'] ?? '',
        respondentEmail: json['respondentEmail'] ?? '',
        country: json['country'] ?? '',
        answers: Map<String, dynamic>.from(json['answers'] ?? {}),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'surveyId': surveyId,
        'respondentId': respondentId,
        'respondentEmail': respondentEmail,
        'country': country,
        'answers': answers,
      };

  @override
  List<Object?> get props =>
      [id, surveyId, respondentId, country, answers, createdAt];
}
