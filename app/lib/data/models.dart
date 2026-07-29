import 'dart:convert';

/// Content models parsed from the GitHub data repo / bundled seed JSON.

class SubjectMeta {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final List<String> topics;

  const SubjectMeta({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.topics,
  });

  factory SubjectMeta.fromJson(Map<String, dynamic> json) => SubjectMeta(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String? ?? 'menu_book',
        colorHex: json['color'] as String? ?? '#7C4DFF',
        topics: (json['topics'] as List? ?? []).cast<String>(),
      );
}

class FlashcardItem {
  final String id;
  final String subjectId;
  final String topic;
  final String front;
  final String back;
  final List<String> tags;

  const FlashcardItem({
    required this.id,
    required this.subjectId,
    required this.topic,
    required this.front,
    required this.back,
    required this.tags,
  });

  factory FlashcardItem.fromJson(String subjectId, Map<String, dynamic> json) =>
      FlashcardItem(
        id: json['id'] as String,
        subjectId: subjectId,
        topic: json['topic'] as String? ?? 'General',
        front: json['front'] as String,
        back: json['back'] as String,
        tags: (json['tags'] as List? ?? []).cast<String>(),
      );
}

class McqItem {
  final String id;
  final String subjectId;
  final String topic;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final String difficulty;
  final int? year;

  const McqItem({
    required this.id,
    required this.subjectId,
    required this.topic,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
    required this.difficulty,
    this.year,
  });

  factory McqItem.fromJson(String subjectId, Map<String, dynamic> json) =>
      McqItem(
        id: json['id'] as String,
        subjectId: subjectId,
        topic: json['topic'] as String? ?? 'General',
        question: json['question'] as String,
        options: (json['options'] as List).cast<String>(),
        answerIndex: json['answerIndex'] as int,
        explanation: json['explanation'] as String? ?? '',
        difficulty: json['difficulty'] as String? ?? 'medium',
        year: json['year'] as int?,
      );
}

/// A fully parsed subject bundle (subject.json + flashcards.json + mcqs.json).
class SubjectBundle {
  final SubjectMeta meta;
  final List<FlashcardItem> flashcards;
  final List<McqItem> mcqs;

  const SubjectBundle({
    required this.meta,
    required this.flashcards,
    required this.mcqs,
  });

  factory SubjectBundle.fromJsonStrings({
    required String subjectJson,
    required String flashcardsJson,
    required String mcqsJson,
  }) {
    final meta =
        SubjectMeta.fromJson(jsonDecode(subjectJson) as Map<String, dynamic>);
    final fcMap = jsonDecode(flashcardsJson) as Map<String, dynamic>;
    final mcqMap = jsonDecode(mcqsJson) as Map<String, dynamic>;
    return SubjectBundle(
      meta: meta,
      flashcards: (fcMap['cards'] as List? ?? [])
          .map((e) =>
              FlashcardItem.fromJson(meta.id, e as Map<String, dynamic>))
          .toList(),
      mcqs: (mcqMap['questions'] as List? ?? [])
          .map((e) => McqItem.fromJson(meta.id, e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ContentManifest {
  final int schemaVersion;
  final int contentVersion;
  final List<({String id, String path})> subjects;

  const ContentManifest({
    required this.schemaVersion,
    required this.contentVersion,
    required this.subjects,
  });

  factory ContentManifest.fromJsonString(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return ContentManifest(
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      contentVersion: json['contentVersion'] as int? ?? 0,
      subjects: (json['subjects'] as List? ?? [])
          .map((e) => (
                id: (e as Map<String, dynamic>)['id'] as String,
                path: e['path'] as String,
              ))
          .toList(),
    );
  }
}
