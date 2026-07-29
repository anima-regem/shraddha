import 'dart:convert';

import 'package:drift/drift.dart';

import 'content_source.dart';
import 'db/database.dart';
import 'models.dart';
import 'srs.dart' as srs;
import 'stats_logic.dart';

class ContentImportFailure {
  final String path;
  final String message;

  const ContentImportFailure({required this.path, required this.message});
}

/// Summary of a best-effort content import. A report with failures has already
/// persisted every valid subject and shard that was reached before or after the
/// failed request.
class ContentImportReport {
  final int subjectCount;
  final int shardCount;
  final int flashcardCount;
  final int mcqCount;
  final List<ContentImportFailure> failures;

  const ContentImportReport({
    required this.subjectCount,
    required this.shardCount,
    required this.flashcardCount,
    required this.mcqCount,
    required this.failures,
  });

  bool get isComplete => failures.isEmpty;
  bool get hasImportedContent => subjectCount > 0 || shardCount > 0;
}

/// Loads content into Drift and exposes queries used by the UI.
class ContentRepository {
  final AppDatabase db;

  ContentRepository(this.db);

  // ---------------------------------------------------------------- content

  /// Imports each subject and content shard independently so successful files
  /// remain available offline when another request or JSON payload fails.
  Future<ContentImportReport> importFrom(
    ContentSource source, {
    ContentManifest? manifest,
  }) async {
    final resolvedManifest = manifest ?? await source.fetchManifest();
    var importedSubjects = 0;
    var importedShards = 0;
    var importedFlashcards = 0;
    var importedMcqs = 0;
    final failures = <ContentImportFailure>[];

    for (final entry in resolvedManifest.subjects) {
      final subjectJsonPath = '${entry.path}/subject.json';
      SubjectMeta meta;
      try {
        meta = SubjectMeta.fromJsonString(
          await source.fetchSubjectJson(entry.path),
        );
        await _upsertSubject(meta);
        importedSubjects++;
      } catch (error) {
        failures.add(
          ContentImportFailure(
            path: subjectJsonPath,
            message: _errorMessage(error),
          ),
        );
        continue;
      }

      List<ContentShard> shards;
      try {
        shards = await source.listContentShards(entry.path);
      } catch (error) {
        failures.add(
          ContentImportFailure(path: entry.path, message: _errorMessage(error)),
        );
        continue;
      }

      for (final shard in shards) {
        try {
          final sourceJson = await source.fetchContentShard(shard);
          switch (shard.type) {
            case ContentShardType.flashcards:
              final items = parseFlashcardsShard(
                subjectId: meta.id,
                source: sourceJson,
              );
              await _upsertFlashcards(items);
              importedFlashcards += items.length;
            case ContentShardType.mcqs:
              final items = parseMcqsShard(
                subjectId: meta.id,
                source: sourceJson,
              );
              await _upsertMcqs(items);
              importedMcqs += items.length;
          }
          importedShards++;
        } catch (error) {
          failures.add(
            ContentImportFailure(
              path: shard.path,
              message: _errorMessage(error),
            ),
          );
        }
      }
    }

    return ContentImportReport(
      subjectCount: importedSubjects,
      shardCount: importedShards,
      flashcardCount: importedFlashcards,
      mcqCount: importedMcqs,
      failures: failures,
    );
  }

  Future<void> _upsertSubject(SubjectMeta meta) => db.transaction(() async {
    await db
        .into(db.subjects)
        .insertOnConflictUpdate(
          SubjectsCompanion(
            id: Value(meta.id),
            name: Value(meta.name),
            icon: Value(meta.icon),
            colorHex: Value(meta.colorHex),
            topicsJson: Value(jsonEncode(meta.topics)),
          ),
        );
  });

  Future<void> _upsertFlashcards(List<FlashcardItem> items) =>
      db.transaction(() async {
        for (final card in items) {
          await db
              .into(db.flashcards)
              .insertOnConflictUpdate(
                FlashcardsCompanion(
                  id: Value(card.id),
                  subjectId: Value(card.subjectId),
                  topic: Value(card.topic),
                  front: Value(card.front),
                  back: Value(card.back),
                  tagsJson: Value(jsonEncode(card.tags)),
                ),
              );
        }
      });

  Future<void> _upsertMcqs(List<McqItem> items) => db.transaction(() async {
    for (final question in items) {
      await db
          .into(db.mcqs)
          .insertOnConflictUpdate(
            McqsCompanion(
              id: Value(question.id),
              subjectId: Value(question.subjectId),
              topic: Value(question.topic),
              question: Value(question.question),
              optionsJson: Value(jsonEncode(question.options)),
              answerIndex: Value(question.answerIndex),
              explanation: Value(question.explanation),
              difficulty: Value(question.difficulty),
              year: Value(question.year),
            ),
          );
    }
  });

  String _errorMessage(Object error) =>
      error.toString().replaceFirst(RegExp(r'^Exception: '), '');

  Future<bool> get hasContent async {
    final row = await (db.selectOnly(
      db.subjects,
    )..addColumns([db.subjects.id.count()])).getSingle();
    return (row.read(db.subjects.id.count()) ?? 0) > 0;
  }

  Stream<List<Subject>> watchSubjects() => (db.select(
    db.subjects,
  )..orderBy([(s) => OrderingTerm.asc(s.name)])).watch();

  Future<List<Mcq>> mcqsForSubject(String? subjectId) {
    final query = db.select(db.mcqs);
    if (subjectId != null) {
      query.where((m) => m.subjectId.equals(subjectId));
    }
    return query.get();
  }

  Future<List<Flashcard>> flashcardsForSubject(String subjectId) => (db.select(
    db.flashcards,
  )..where((f) => f.subjectId.equals(subjectId))).get();

  // ------------------------------------------------------------------- SRS

  /// Cards due now for a subject: never-seen cards plus cards whose due date
  /// has passed. Never-seen cards are capped by [newCardLimit].
  Future<List<Flashcard>> dueFlashcards(
    String subjectId, {
    int newCardLimit = 10,
    DateTime? now,
  }) async {
    final ts = now ?? DateTime.now();
    final all = await flashcardsForSubject(subjectId);
    final states = await (db.select(
      db.srsStates,
    )..where((s) => s.cardId.isIn(all.map((c) => c.id)))).get();
    final byId = {for (final s in states) s.cardId: s};

    final due = <Flashcard>[];
    final fresh = <Flashcard>[];
    for (final card in all) {
      final state = byId[card.id];
      if (state == null) {
        fresh.add(card);
      } else if (!state.due.isAfter(ts)) {
        due.add(card);
      }
    }
    return [...due, ...fresh.take(newCardLimit)];
  }

  /// Counts due cards per subject (for badges on the home screen).
  Future<Map<String, int>> dueCounts({DateTime? now}) async {
    final ts = now ?? DateTime.now();
    final all = await db.select(db.flashcards).get();
    final states = await db.select(db.srsStates).get();
    final byId = {for (final s in states) s.cardId: s};
    final counts = <String, int>{};
    for (final card in all) {
      final state = byId[card.id];
      final isDue = state == null || !state.due.isAfter(ts);
      if (isDue) counts[card.subjectId] = (counts[card.subjectId] ?? 0) + 1;
    }
    return counts;
  }

  /// Applies an SRS rating to a card and logs the review.
  Future<srs.SrsState> rateFlashcard({
    required Flashcard card,
    required srs.Rating rating,
    DateTime? now,
  }) async {
    final ts = now ?? DateTime.now();
    final existing = await (db.select(
      db.srsStates,
    )..where((s) => s.cardId.equals(card.id))).getSingleOrNull();

    final current = existing == null
        ? srs.SrsState.fresh(ts)
        : srs.SrsState(
            easeFactor: existing.easeFactor,
            intervalDays: existing.intervalDays,
            repetitions: existing.repetitions,
            lapses: existing.lapses,
            due: existing.due,
          );

    final next = srs.schedule(current, rating, ts);

    await db
        .into(db.srsStates)
        .insertOnConflictUpdate(
          SrsStatesCompanion(
            cardId: Value(card.id),
            easeFactor: Value(next.easeFactor),
            intervalDays: Value(next.intervalDays),
            repetitions: Value(next.repetitions),
            lapses: Value(next.lapses),
            due: Value(next.due),
          ),
        );

    await db
        .into(db.reviewLogs)
        .insert(
          ReviewLogsCompanion(
            itemId: Value(card.id),
            itemType: const Value('flashcard'),
            subjectId: Value(card.subjectId),
            topic: Value(card.topic),
            correct: Value(rating.index >= srs.Rating.good.index),
            rating: Value(rating.index),
            timestamp: Value(ts),
          ),
        );
    return next;
  }

  // ------------------------------------------------------------------ MCQs

  Future<void> logMcqAnswer({
    required Mcq question,
    required bool correct,
    DateTime? now,
  }) => db
      .into(db.reviewLogs)
      .insert(
        ReviewLogsCompanion(
          itemId: Value(question.id),
          itemType: const Value('mcq'),
          subjectId: Value(question.subjectId),
          topic: Value(question.topic),
          correct: Value(correct),
          timestamp: Value(now ?? DateTime.now()),
        ),
      );

  Future<int> saveQuizResult(QuizResultsCompanion result) =>
      db.into(db.quizResults).insert(result);

  Future<List<QuizResult>> recentQuizResults({int limit = 10}) =>
      (db.select(db.quizResults)
            ..orderBy([(q) => OrderingTerm.desc(q.timestamp)])
            ..limit(limit))
          .get();

  // ------------------------------------------------------------- tracking

  Stream<List<ReviewLog>> watchLogsSince(DateTime since) => (db.select(
    db.reviewLogs,
  )..where((l) => l.timestamp.isBiggerOrEqualValue(since))).watch();

  Stream<int> watchTodayCount() {
    final today = dateOnly(DateTime.now());
    final count = db.reviewLogs.id.count();
    final query = db.selectOnly(db.reviewLogs)
      ..addColumns([count])
      ..where(db.reviewLogs.timestamp.isBiggerOrEqualValue(today));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// Per-subject MCQ accuracy: (attempts, correct).
  Future<Map<String, ({int attempts, int correct})>> subjectAccuracy() async {
    final logs = await (db.select(
      db.reviewLogs,
    )..where((l) => l.itemType.equals('mcq'))).get();
    final map = <String, ({int attempts, int correct})>{};
    for (final log in logs) {
      final prev = map[log.subjectId] ?? (attempts: 0, correct: 0);
      map[log.subjectId] = (
        attempts: prev.attempts + 1,
        correct: prev.correct + (log.correct ? 1 : 0),
      );
    }
    return map;
  }

  /// Weakest topics by MCQ accuracy (min 3 attempts).
  Future<
    List<({String subjectId, String topic, int attempts, double accuracy})>
  >
  weakTopics({int minAttempts = 3, int limit = 5}) async {
    final logs = await (db.select(
      db.reviewLogs,
    )..where((l) => l.itemType.equals('mcq'))).get();
    final grouped =
        <
          String,
          ({String subjectId, String topic, int attempts, int correct})
        >{};
    for (final log in logs) {
      final key = '${log.subjectId}|${log.topic}';
      final prev =
          grouped[key] ??
          (subjectId: log.subjectId, topic: log.topic, attempts: 0, correct: 0);
      grouped[key] = (
        subjectId: prev.subjectId,
        topic: prev.topic,
        attempts: prev.attempts + 1,
        correct: prev.correct + (log.correct ? 1 : 0),
      );
    }
    final rows =
        grouped.values
            .where((g) => g.attempts >= minAttempts)
            .map(
              (g) => (
                subjectId: g.subjectId,
                topic: g.topic,
                attempts: g.attempts,
                accuracy: g.correct / g.attempts * 100,
              ),
            )
            .toList()
          ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return rows.take(limit).toList();
  }

  /// Wipes all user progress (content stays).
  Future<void> resetProgress() async {
    await db.transaction(() async {
      await db.delete(db.reviewLogs).go();
      await db.delete(db.srsStates).go();
      await db.delete(db.quizResults).go();
    });
  }
}
