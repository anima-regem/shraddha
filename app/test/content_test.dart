import 'package:flutter_test/flutter_test.dart';
import 'package:shraddha/data/content_source.dart';
import 'package:shraddha/data/models.dart';

void main() {
  group('normalizeRepoUrl', () {
    test('converts github.com URL to raw base', () {
      expect(
        normalizeRepoUrl('https://github.com/alice/upsc-content'),
        'https://raw.githubusercontent.com/alice/upsc-content/main',
      );
    });

    test('handles branch in tree URL', () {
      expect(
        normalizeRepoUrl('https://github.com/alice/upsc-content/tree/dev'),
        'https://raw.githubusercontent.com/alice/upsc-content/dev',
      );
    });

    test('passes through raw URLs, stripping trailing slash', () {
      expect(
        normalizeRepoUrl('https://raw.githubusercontent.com/a/b/main/'),
        'https://raw.githubusercontent.com/a/b/main',
      );
    });

    test('accepts bare github.com without scheme', () {
      expect(
        normalizeRepoUrl('github.com/alice/repo'),
        'https://raw.githubusercontent.com/alice/repo/main',
      );
    });

    test('rejects garbage', () {
      expect(normalizeRepoUrl('not a url'), isNull);
      expect(normalizeRepoUrl(''), isNull);
    });
  });

  group('content parsing', () {
    test('parses a full subject bundle', () {
      final bundle = SubjectBundle.fromJsonStrings(
        subjectJson:
            '{"id":"polity","name":"Polity","icon":"account_balance","color":"#6C5CE7","topics":["Constitution"]}',
        flashcardsJson:
            '{"subjectId":"polity","cards":[{"id":"fc1","topic":"Constitution","front":"Q?","back":"A.","tags":["x"]}]}',
        mcqsJson:
            '{"subjectId":"polity","questions":[{"id":"q1","topic":"Constitution","question":"Which?","options":["a","b","c","d"],"answerIndex":2,"explanation":"Because.","difficulty":"easy","year":2020}]}',
      );
      expect(bundle.meta.id, 'polity');
      expect(bundle.flashcards, hasLength(1));
      expect(bundle.flashcards.first.subjectId, 'polity');
      expect(bundle.mcqs.first.answerIndex, 2);
      expect(bundle.mcqs.first.year, 2020);
    });

    test('parses manifest', () {
      final manifest = ContentManifest.fromJsonString(
        '{"schemaVersion":1,"contentVersion":7,"subjects":[{"id":"polity","path":"subjects/polity"}]}',
      );
      expect(manifest.contentVersion, 7);
      expect(manifest.subjects.single.path, 'subjects/polity');
    });
  });
}
