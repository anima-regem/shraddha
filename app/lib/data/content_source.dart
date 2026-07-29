import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models.dart';

enum ContentShardType { flashcards, mcqs }

/// A single content JSON file discovered below a manifest subject folder.
class ContentShard {
  final String path;
  final ContentShardType type;

  const ContentShard({required this.path, required this.type});
}

/// Lets tests provide deterministic Git tree responses without networking.
typedef GitTreeLoader =
    Future<Map<String, dynamic>> Function(
      String treeish, {
      required bool recursive,
    });

/// Abstracts the subject metadata and individual content shards regardless of
/// whether they are bundled with the app or fetched remotely.
abstract class ContentSource {
  Future<ContentManifest> fetchManifest();
  Future<String> fetchSubjectJson(String subjectPath);
  Future<List<ContentShard>> listContentShards(String subjectPath);
  Future<String> fetchContentShard(ContentShard shard);
}

/// Reads bundled, legacy flat content so the app continues to work offline on
/// first launch. Remote GitHub sources add recursive discovery separately.
class AssetContentSource implements ContentSource {
  static const _root = 'assets/seed';

  @override
  Future<ContentManifest> fetchManifest() async =>
      ContentManifest.fromJsonString(
        await rootBundle.loadString('$_root/manifest.json'),
      );

  @override
  Future<String> fetchSubjectJson(String subjectPath) =>
      rootBundle.loadString('$_root/$subjectPath/subject.json');

  @override
  Future<List<ContentShard>> listContentShards(String subjectPath) async => [
    ContentShard(
      path: '$subjectPath/flashcards.json',
      type: ContentShardType.flashcards,
    ),
    ContentShard(path: '$subjectPath/mcqs.json', type: ContentShardType.mcqs),
  ];

  @override
  Future<String> fetchContentShard(ContentShard shard) =>
      rootBundle.loadString('$_root/${shard.path}');
}

/// Describes a public GitHub source whose raw base can be used for file
/// downloads and whose Git tree can be used for recursive discovery.
class GithubRepoLocation {
  final String owner;
  final String repository;
  final String ref;
  final String contentRootPath;

  const GithubRepoLocation({
    required this.owner,
    required this.repository,
    required this.ref,
    required this.contentRootPath,
  });

  static GithubRepoLocation? fromRawBase(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.host != 'raw.githubusercontent.com') return null;
    final parts = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (parts.length < 3) return null;
    return GithubRepoLocation(
      owner: parts[0],
      repository: parts[1],
      ref: parts[2],
      contentRootPath: parts.skip(3).join('/'),
    );
  }
}

/// Fetches a GitHub content root. Public GitHub sources are discovered from
/// their Git tree; other raw HTTP sources retain the legacy flat-file layout.
class GithubContentSource implements ContentSource {
  final String baseUrl;
  final Dio _dio;
  final GitTreeLoader? _gitTreeLoader;
  final GithubRepoLocation? _githubLocation;
  Future<List<_GitTreeEntry>>? _treeEntries;

  GithubContentSource(this.baseUrl, {Dio? dio, GitTreeLoader? gitTreeLoader})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              responseType: ResponseType.plain,
            ),
          ),
      _gitTreeLoader = gitTreeLoader,
      _githubLocation = GithubRepoLocation.fromRawBase(baseUrl);

  String get _base => baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;

  Future<String> _getRaw(String path) async {
    final response = await _dio.get<String>('$_base/$path');
    final body = response.data;
    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to fetch $path (HTTP ${response.statusCode})');
    }
    return body;
  }

  @override
  Future<ContentManifest> fetchManifest() async =>
      ContentManifest.fromJsonString(await _getRaw('manifest.json'));

  @override
  Future<String> fetchSubjectJson(String subjectPath) =>
      _getRaw('$subjectPath/subject.json');

  @override
  Future<List<ContentShard>> listContentShards(String subjectPath) async {
    final location = _githubLocation;
    if (location == null) return _legacyFlatShards(subjectPath);

    final subjectRoot = _joinPath(location.contentRootPath, subjectPath);
    final prefix = '$subjectRoot/';
    final rootPrefix = location.contentRootPath.isEmpty
        ? ''
        : '${location.contentRootPath}/';
    final shards = <ContentShard>[];

    for (final entry in await _allTreeEntries()) {
      if (entry.type != 'blob' || !entry.path.startsWith(prefix)) continue;
      final relativePath = rootPrefix.isEmpty
          ? entry.path
          : entry.path.substring(rootPrefix.length);
      final kind = _shardTypeFor(relativePath);
      if (kind != null) {
        shards.add(ContentShard(path: relativePath, type: kind));
      }
    }
    shards.sort((a, b) => a.path.compareTo(b.path));
    return shards;
  }

  @override
  Future<String> fetchContentShard(ContentShard shard) => _getRaw(shard.path);

  List<ContentShard> _legacyFlatShards(String subjectPath) => [
    ContentShard(
      path: '$subjectPath/flashcards.json',
      type: ContentShardType.flashcards,
    ),
    ContentShard(path: '$subjectPath/mcqs.json', type: ContentShardType.mcqs),
  ];

  ContentShardType? _shardTypeFor(String relativePath) {
    final fileName = relativePath.split('/').last.toLowerCase();
    if (!fileName.endsWith('.json')) return null;
    if (fileName.startsWith('flashcards')) {
      return ContentShardType.flashcards;
    }
    if (fileName.startsWith('mcqs')) return ContentShardType.mcqs;
    return null;
  }

  Future<List<_GitTreeEntry>> _allTreeEntries() =>
      _treeEntries ??= _loadTreeEntries();

  Future<List<_GitTreeEntry>> _loadTreeEntries() async {
    final location = _githubLocation!;
    final response = await _fetchGitTree(location.ref, recursive: true);
    if (response['truncated'] != true) return _treeEntriesFrom(response);
    return _walkContentRootTree();
  }

  Future<List<_GitTreeEntry>> _walkContentRootTree() async {
    final location = _githubLocation!;
    var treeish = location.ref;
    var repoPath = '';

    for (final segment in _pathSegments(location.contentRootPath)) {
      final entries = _treeEntriesFrom(
        await _fetchGitTree(treeish, recursive: false),
      );
      final next = entries.where(
        (entry) => entry.type == 'tree' && entry.path == segment,
      );
      if (next.isEmpty || next.first.sha == null) {
        throw Exception('Could not find GitHub content folder: $segment');
      }
      treeish = next.first.sha!;
      repoPath = _joinPath(repoPath, segment);
    }

    final discovered = <_GitTreeEntry>[];
    Future<void> walk(String currentTree, String currentPath) async {
      final entries = _treeEntriesFrom(
        await _fetchGitTree(currentTree, recursive: false),
      );
      for (final entry in entries) {
        final path = _joinPath(currentPath, entry.path);
        if (entry.type == 'blob') {
          discovered.add(_GitTreeEntry(path: path, type: entry.type));
        } else if (entry.type == 'tree' && entry.sha != null) {
          await walk(entry.sha!, path);
        }
      }
    }

    await walk(treeish, repoPath);
    return discovered;
  }

  Future<Map<String, dynamic>> _fetchGitTree(
    String treeish, {
    required bool recursive,
  }) async {
    final loader = _gitTreeLoader;
    if (loader != null) return loader(treeish, recursive: recursive);

    final location = _githubLocation!;
    final response = await _dio.get<dynamic>(
      'https://api.github.com/repos/${location.owner}/${location.repository}/git/trees/${Uri.encodeComponent(treeish)}',
      queryParameters: recursive ? const {'recursive': '1'} : null,
      options: Options(
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/vnd.github+json'},
      ),
    );
    if (response.statusCode != 200 || response.data is! Map) {
      throw Exception(
        'Failed to discover GitHub content (HTTP ${response.statusCode})',
      );
    }
    return Map<String, dynamic>.from(response.data as Map);
  }

  List<_GitTreeEntry> _treeEntriesFrom(Map<String, dynamic> response) {
    final tree = response['tree'];
    if (tree is! List) {
      throw const FormatException(
        'GitHub tree response is missing tree entries.',
      );
    }
    return tree.whereType<Map>().map((entry) {
      final value = Map<String, dynamic>.from(entry);
      return _GitTreeEntry(
        path: value['path'] as String,
        type: value['type'] as String,
        sha: value['sha'] as String?,
      );
    }).toList();
  }
}

class _GitTreeEntry {
  final String path;
  final String type;
  final String? sha;

  const _GitTreeEntry({required this.path, required this.type, this.sha});
}

String _joinPath(String left, String right) {
  if (left.isEmpty) return right;
  if (right.isEmpty) return left;
  return '$left/$right';
}

List<String> _pathSegments(String path) =>
    path.split('/').where((part) => part.isNotEmpty).toList();

/// Converts a GitHub or raw HTTP URL into a raw content base URL.
///
/// GitHub web URLs may optionally point at a branch and content subfolder,
/// e.g. github.com/user/repo/tree/main/data-repo.
String? normalizeRepoUrl(String input, {String branch = 'main'}) {
  var raw = input.trim();
  if (raw.isEmpty) return null;
  if (!raw.startsWith('http://') && !raw.startsWith('https://')) {
    raw = 'https://$raw';
  }

  final uri = Uri.tryParse(raw);
  if (uri == null || uri.host.isEmpty) return null;
  if (!RegExp(r'^[A-Za-z0-9.-]+$').hasMatch(uri.host)) return null;
  final host = uri.host.toLowerCase();
  if (host == 'raw.githubusercontent.com') {
    return raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
  }
  if (host == 'github.com' || host == 'www.github.com') {
    final parts = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (parts.length < 2) return null;
    final owner = parts[0];
    final repository = parts[1].replaceFirst(RegExp(r'\.git$'), '');
    var ref = branch;
    var contentRoot = '';
    if (parts.length > 2) {
      if (parts[2] != 'tree' || parts.length < 4) return null;
      ref = parts[3];
      contentRoot = parts.skip(4).join('/');
    }
    final suffix = contentRoot.isEmpty ? '' : '/$contentRoot';
    return 'https://raw.githubusercontent.com/$owner/$repository/$ref$suffix';
  }
  if (uri.scheme != 'http' && uri.scheme != 'https') return null;
  return raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
}
