import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get colorHex => text()();
  TextColumn get topicsJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Flashcards extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  TextColumn get topic => text()();
  TextColumn get front => text()();
  TextColumn get back => text()();
  TextColumn get tagsJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Mcqs extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  TextColumn get topic => text()();
  TextColumn get question => text()();
  TextColumn get optionsJson => text()();
  IntColumn get answerIndex => integer()();
  TextColumn get explanation => text()();
  TextColumn get difficulty => text()();
  IntColumn get year => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SrsStates extends Table {
  TextColumn get cardId => text()();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get due => dateTime()();

  @override
  Set<Column> get primaryKey => {cardId};
}

class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemId => text()();
  TextColumn get itemType => text()(); // 'flashcard' | 'mcq'
  TextColumn get subjectId => text()();
  TextColumn get topic => text()();
  BoolColumn get correct => boolean()();
  IntColumn get rating => integer().nullable()();
  DateTimeColumn get timestamp => dateTime()();
}

class QuizResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectId => text().nullable()();
  TextColumn get mode => text()(); // 'practice' | 'mock'
  IntColumn get total => integer()();
  IntColumn get correctCount => integer()();
  IntColumn get wrongCount => integer()();
  IntColumn get skippedCount => integer()();
  RealColumn get score => real()();
  RealColumn get maxScore => real()();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get timestamp => dateTime()();
}

@DriftDatabase(
  tables: [Subjects, Flashcards, Mcqs, SrsStates, ReviewLogs, QuizResults],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'shraddha'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
