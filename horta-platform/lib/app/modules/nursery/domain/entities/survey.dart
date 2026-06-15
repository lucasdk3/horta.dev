import 'package:equatable/equatable.dart';

class LocalizedText extends Equatable {
  final String pt;
  final String en;
  final String es;

  const LocalizedText({required this.pt, required this.en, required this.es});

  String get(String lang) {
    switch (lang) {
      case 'pt':
        return pt.isNotEmpty ? pt : en;
      case 'es':
        return es.isNotEmpty ? es : en;
      default:
        return en;
    }
  }

  factory LocalizedText.fromJson(Map<String, dynamic> json) => LocalizedText(
        pt: json['pt'] ?? '',
        en: json['en'] ?? '',
        es: json['es'] ?? '',
      );

  Map<String, dynamic> toJson() => {'pt': pt, 'en': en, 'es': es};

  @override
  List<Object?> get props => [pt, en, es];
}

enum QuestionType { text, choice, rating }

class QuestionOption extends Equatable {
  final String value;
  final LocalizedText label;

  const QuestionOption({required this.value, required this.label});

  factory QuestionOption.fromJson(Map<String, dynamic> json) => QuestionOption(
        value: json['value'] ?? '',
        label: LocalizedText.fromJson(json['label'] ?? {}),
      );

  @override
  List<Object?> get props => [value, label];
}

class SurveyQuestion extends Equatable {
  final String id;
  final QuestionType type;
  final LocalizedText label;
  final List<QuestionOption> options;

  const SurveyQuestion({
    required this.id,
    required this.type,
    required this.label,
    this.options = const [],
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] ?? 'text';
    final type = QuestionType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => QuestionType.text,
    );
    return SurveyQuestion(
      id: json['id'] ?? '',
      type: type,
      label: LocalizedText.fromJson(json['label'] ?? {}),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((o) => QuestionOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, type, label, options];
}

class Survey extends Equatable {
  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final String category;
  final List<String> tags;
  final List<SurveyQuestion> questions;
  final bool active;
  final DateTime? createdAt;

  const Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.tags = const [],
    this.questions = const [],
    this.active = true,
    this.createdAt,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        id: json['id'] ?? '',
        title: LocalizedText.fromJson(json['title'] ?? {}),
        description: LocalizedText.fromJson(json['description'] ?? {}),
        category: json['category'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        questions: (json['questions'] as List<dynamic>? ?? [])
            .map((q) => SurveyQuestion.fromJson(q as Map<String, dynamic>))
            .toList(),
        active: json['active'] ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );

  @override
  List<Object?> get props => [id, title, description, category, tags, active];
}
