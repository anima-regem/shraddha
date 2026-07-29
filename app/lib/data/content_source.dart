import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models.dart';

/// Raw JSON strings for one subject folder.
typedef RawSubjectFiles = ({
  String subjectJson,
  String flashcardsJson,
  String mcqsJson,
});

/// Abstracts where content JSON comes from (bundled seed vs GitHub).
abstract class ContentSource {
  Future<ContentManifest> fetchManifest();
  Future<RawSubjectFiles> fetchSubject(String path);
}

/// Reads the seed content bundled with the app under assets/seed/.
class AssetContentSource implements ContentSource {
  static const _root = 'assets/seed';

  @override
  Future<ContentManifest> fetchManifest() async =>
      ContentManifest.fromJsonString(
          await rootBundle.loadString('$_root/manifest.json'));

  @override
  Future<RawSubjectFiles> fetchSubject(String path) async => (
        subjectJson: await rootBundle.loadString('$_root/$path/subject.json'),
        flashcardsJson:
            await rootBundle.loadString('$_root/$path/flashcards.json'),
        mcqsJson: await rootBundle.loadString('$_root/$path/mcqs.json'),
      );
}

/// Fetches content from a GitHub repo via raw.githubusercontent.com.
///
/// [baseUrl] example: https://raw.githubusercontent.com/user/repo/main
class GithubContentSource implements ContentSource {
  final String baseUrl;
  final Dio _dio;

  GithubContentSource(this.baseUrl, {Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              responseType: ResponseType.plain,
            ));

  String get _base => baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;

  Future<String> _get(String path) async {
    final res = await _dio.get<String>('$_base/$path');
    final body = res.data;
    if (res.statusCode != 200 || body == null) {
      throw Exception('Failed to fetch $path (HTTP ${res.statusCode})');
    }
    return body;
  }

  @override
  Future<ContentManifest> fetchManifest() async =>
      ContentManifest.fromJsonString(await _get('manifest.json'));

  @override
  Future<RawSubjectFiles> fetchSubject(String path) async => (
        subjectJson: await _get('$path/subject.json'),
        flashcardsJson: await _get('$path/flashcards.json'),
        mcqsJson: await _get('$path/mcqs.json'),
      );
}

/// Converts a GitHub web URL (github.com/user/repo) into a raw base URL.
/// Returns null if the input cannot be interpreted.
String? normalizeRepoUrl(String input, {String branch = 'main'}) {
  var url = input.trim();
  if (url.isEmpty) return null;
  if (url.startsWith('https://raw.githubusercontent.com/')) {
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
  final match = RegExp(
          r'^(?:https?://)?(?:www\.)?github\.com/([\w.-]+)/([\w.-]+?)(?:\.git)?(?:/(?:tree|blob)/([\w./-]+))?/?$')
      .firstMatch(url);
  if (match != null) {
    final user = match.group(1)!;
    final repo = match.group(2)!;
    final ref = match.group(3) ?? branch;
    return 'https://raw.githubusercontent.com/$user/$repo/$ref';
  }
  return null;
}
