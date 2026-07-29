import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shraddha/data/content_source.dart';
import 'package:shraddha/data/db/database.dart';
import 'package:shraddha/data/models.dart';
import 'package:shraddha/data/repository.dart';
import 'package:shraddha/data/sync_service.dart';

void main() {
  group('recursive GitHub discovery', () {
    test('finds nested content shards and ignores unrelated JSON', () async {
      final source = GithubContentSource(
        'https://raw.githubusercontent.com/acme/upsc/main/data',
        gitTreeLoader: (treeish, {required recursive}) async {
          expect(treeish, 'main');
          expect(recursive, isTrue);
          return {
            'truncated': false,
            'tree': [
              {'path': 'data/subjects/polity/subject.json', 'type': 'blob'},
              {'path': 'data/subjects/polity/flashcards.json', 'type': 'blob'},
              {
                'path': 'data/subjects/polity/fundamentals/mcqs-002.json',
                'type': 'blob',
              },
              {
                'path': 'data/subjects/polity/fundamentals/notes.json',
                'type': 'blob',
              },
              {'path': 'data/subjects/history/flashcards.json', 'type': 'blob'},
            ],
          };
        },
      );

      final shards = await source.listContentShards('subjects/polity');

      expect(shards.map((shard) => shard.path), [
        'subjects/polity/flashcards.json',
        'subjects/polity/fundamentals/mcqs-002.json',
      ]);
      expect(shards.map((shard) => shard.type), [
        ContentShardType.flashcards,
        ContentShardType.mcqs,
      ]);
    });

    test('walks Git trees when a recursive response is truncated', () async {
      final source = GithubContentSource(
        'https://raw.githubusercontent.com/acme/upsc/main/data',
        gitTreeLoader: (treeish, {required recursive}) async {
          if (treeish == 'main' && recursive) {
            return {'truncated': true, 'tree': const []};
          }
          return switch (treeish) {
            'main' => {
              'tree': [
                {'path': 'data', 'type': 'tree', 'sha': 'data-tree'},
              ],
            },
            'data-tree' => {
              'tree': [
                {'path': 'subjects', 'type': 'tree', 'sha': 'subjects-tree'},
              ],
            },
            'subjects-tree' => {
              'tree': [
                {'path': 'polity', 'type': 'tree', 'sha': 'polity-tree'},
              ],
            },
            'polity-tree' => {
              'tree': [
                {'path': 'flashcards-001.json', 'type': 'blob', 'sha': 'fc'},
                {'path': 'deeper', 'type': 'tree', 'sha': 'deeper-tree'},
              ],
            },
            'deeper-tree' => {
              'tree': [
                {'path': 'mcqs-001.json', 'type': 'blob', 'sha': 'mcq'},
              ],
            },
            _ => throw StateError('Unexpected tree: $treeish'),
          };
        },
      );

      final shards = await source.listContentShards('subjects/polity');

      expect(shards.map((shard) => shard.path), [
        'subjects/polity/deeper/mcqs-001.json',
        'subjects/polity/flashcards-001.json',
      ]);
    });

    test('keeps the flat layout for non-GitHub raw sources', () async {
      final source = GithubContentSource('https://content.example.com/upsc');

      final shards = await source.listContentShards('subjects/polity');

      expect(shards.map((shard) => shard.path), [
        'subjects/polity/flashcards.json',
        'subjects/polity/mcqs.json',
      ]);
    });

    test('normalizes a GitHub tree URL with a content subfolder', () {
      expect(
        normalizeRepoUrl('https://github.com/acme/upsc/tree/main/data-repo'),
        'https://raw.githubusercontent.com/acme/upsc/main/data-repo',
      );
    });
  });

  group('resilient shard imports', () {
    late AppDatabase database;
    late ContentRepository repository;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      repository = ContentRepository(database);
    });

    tearDown(() => database.close());

    test('imports later shards after one shard fails', () async {
      final source = _FixtureSource(
        shardPaths: {
          'subjects/polity': const [
            ContentShard(
              path: 'subjects/polity/flashcards-001.json',
              type: ContentShardType.flashcards,
            ),
            ContentShard(
              path: 'subjects/polity/mcqs-001.json',
              type: ContentShardType.mcqs,
            ),
            ContentShard(
              path: 'subjects/polity/flashcards-002.json',
              type: ContentShardType.flashcards,
            ),
          ],
        },
        shardBodies: {
          'subjects/polity/flashcards-001.json': _flashcardsJson(['fc-1']),
          'subjects/polity/flashcards-002.json': _flashcardsJson(['fc-2']),
        },
        failedShardPaths: const {'subjects/polity/mcqs-001.json'},
      );

      final report = await repository.importFrom(source);

      expect(report.isComplete, isFalse);
      expect(report.shardCount, 2);
      expect(report.flashcardCount, 2);
      expect(report.mcqCount, 0);
      expect(report.failures.single.path, 'subjects/polity/mcqs-001.json');
      expect(await repository.flashcardsForSubject('polity'), hasLength(2));
    });

    test('imports a valid shard larger than the recommended size', () async {
      final ids = List.generate(101, (index) => 'fc-$index');
      final source = _FixtureSource(
        shardPaths: {
          'subjects/polity': const [
            ContentShard(
              path: 'subjects/polity/flashcards-big.json',
              type: ContentShardType.flashcards,
            ),
          ],
        },
        shardBodies: {
          'subjects/polity/flashcards-big.json': _flashcardsJson(ids),
        },
      );

      final report = await repository.importFrom(source);

      expect(report.isComplete, isTrue);
      expect(report.flashcardCount, 101);
      expect(await repository.flashcardsForSubject('polity'), hasLength(101));
    });

    test(
      'keeps the version incomplete after a partial sync and retries',
      () async {
        SharedPreferences.setMockInitialValues({
          SyncService.contentVersionKey: 1,
        });
        final prefs = await SharedPreferences.getInstance();
        final source = _FixtureSource(
          contentVersion: 2,
          shardPaths: {
            'subjects/polity': const [
              ContentShard(
                path: 'subjects/polity/flashcards-001.json',
                type: ContentShardType.flashcards,
              ),
              ContentShard(
                path: 'subjects/polity/mcqs-001.json',
                type: ContentShardType.mcqs,
              ),
            ],
          },
          shardBodies: {
            'subjects/polity/flashcards-001.json': _flashcardsJson(['fc-1']),
          },
          failedShardPaths: const {'subjects/polity/mcqs-001.json'},
        );
        final service = SyncService(
          repository: repository,
          prefs: prefs,
          githubSourceFactory: (_) => source,
        );

        final first = await service.syncFromGithub();
        final second = await service.syncFromGithub();

        expect(first.isPartial, isTrue);
        expect(first.skippedFileCount, 1);
        expect(prefs.getInt(SyncService.contentVersionKey), 1);
        expect(second.isPartial, isTrue);
        expect(source.manifestRequests, 2);
        expect(source.shardRequests['subjects/polity/flashcards-001.json'], 2);
      },
    );
  });
}

class _FixtureSource implements ContentSource {
  final int contentVersion;
  final Map<String, List<ContentShard>> shardPaths;
  final Map<String, String> shardBodies;
  final Set<String> failedShardPaths;
  int manifestRequests = 0;
  final Map<String, int> shardRequests = {};

  _FixtureSource({
    this.contentVersion = 2,
    required this.shardPaths,
    required this.shardBodies,
    this.failedShardPaths = const {},
  });

  @override
  Future<ContentManifest> fetchManifest() async {
    manifestRequests++;
    return ContentManifest.fromJsonString('''
      {"schemaVersion":1,"contentVersion":$contentVersion,"subjects":[
        {"id":"polity","path":"subjects/polity"}
      ]}
    ''');
  }

  @override
  Future<String> fetchSubjectJson(String subjectPath) async => jsonEncode({
    'id': 'polity',
    'name': 'Polity',
    'icon': 'account_balance',
    'color': '#6C5CE7',
    'topics': ['Constitution'],
  });

  @override
  Future<List<ContentShard>> listContentShards(String subjectPath) async =>
      shardPaths[subjectPath] ?? const [];

  @override
  Future<String> fetchContentShard(ContentShard shard) async {
    shardRequests.update(shard.path, (count) => count + 1, ifAbsent: () => 1);
    if (failedShardPaths.contains(shard.path)) {
      throw Exception('Offline for ${shard.path}');
    }
    final body = shardBodies[shard.path];
    if (body == null) throw Exception('No fixture for ${shard.path}');
    return body;
  }
}

String _flashcardsJson(List<String> ids) => jsonEncode({
  'subjectId': 'polity',
  'cards': [
    for (final id in ids)
      {
        'id': id,
        'topic': 'Constitution',
        'front': 'Question $id',
        'back': 'Answer $id',
        'tags': ['test'],
      },
  ],
});
