import 'package:shared_preferences/shared_preferences.dart';

import 'content_source.dart';
import 'repository.dart';

typedef GithubContentSourceFactory = ContentSource Function(String baseUrl);

class SyncResult {
  final bool updated;
  final int subjectCount;
  final int shardCount;
  final int flashcardCount;
  final int mcqCount;
  final int skippedFileCount;
  final bool isPartial;
  final int contentVersion;
  final String message;

  const SyncResult({
    required this.updated,
    required this.subjectCount,
    required this.shardCount,
    required this.flashcardCount,
    required this.mcqCount,
    required this.skippedFileCount,
    required this.isPartial,
    required this.contentVersion,
    required this.message,
  });
}

/// Coordinates first-run seeding and GitHub content syncs.
class SyncService {
  static const repoUrlKey = 'content_repo_url';
  static const contentVersionKey = 'content_version';
  static const seededKey = 'seeded';
  static const lastSyncKey = 'last_sync_iso';
  static const defaultRepoUrl =
      'https://raw.githubusercontent.com/anima-regem/shraddha/main/data-repo';

  final ContentRepository repository;
  final SharedPreferences prefs;
  final GithubContentSourceFactory _githubSourceFactory;

  SyncService({
    required this.repository,
    required this.prefs,
    GithubContentSourceFactory? githubSourceFactory,
  }) : _githubSourceFactory =
           githubSourceFactory ?? ((baseUrl) => GithubContentSource(baseUrl));

  /// Uses Shraddha's published content source until a learner chooses another.
  String get repoUrl => prefs.getString(repoUrlKey) ?? defaultRepoUrl;
  int get contentVersion => prefs.getInt(contentVersionKey) ?? 0;
  DateTime? get lastSync {
    final iso = prefs.getString(lastSyncKey);
    return iso == null ? null : DateTime.tryParse(iso);
  }

  Future<void> setRepoUrl(String? url) async {
    if (url == null || url.trim().isEmpty) {
      await prefs.remove(repoUrlKey);
    } else {
      await prefs.setString(repoUrlKey, url.trim());
    }
  }

  /// Seeds bundled content on first launch so the app works offline
  /// out of the box.
  Future<void> seedIfNeeded() async {
    if (prefs.getBool(seededKey) == true && await repository.hasContent) {
      return;
    }
    final source = AssetContentSource();
    final manifest = await source.fetchManifest();
    final report = await repository.importFrom(source, manifest: manifest);
    if (!report.isComplete) {
      throw StateError('Could not seed all bundled study content.');
    }
    await prefs.setBool(seededKey, true);
    await prefs.setInt(contentVersionKey, manifest.contentVersion);
  }

  /// Pulls from the configured GitHub repo. Skips download when the remote
  /// contentVersion matches the local one, unless [force] is true.
  Future<SyncResult> syncFromGithub({bool force = false}) async {
    final base = normalizeRepoUrl(repoUrl);
    if (base == null) {
      return const SyncResult(
        updated: false,
        subjectCount: 0,
        shardCount: 0,
        flashcardCount: 0,
        mcqCount: 0,
        skippedFileCount: 0,
        isPartial: false,
        contentVersion: 0,
        message: 'Could not understand the repository URL.',
      );
    }

    final source = _githubSourceFactory(base);
    final manifest = await source.fetchManifest();
    if (!force && manifest.contentVersion == contentVersion) {
      await prefs.setString(lastSyncKey, DateTime.now().toIso8601String());
      return SyncResult(
        updated: false,
        subjectCount: manifest.subjects.length,
        shardCount: 0,
        flashcardCount: 0,
        mcqCount: 0,
        skippedFileCount: 0,
        isPartial: false,
        contentVersion: manifest.contentVersion,
        message: 'Already up to date (v${manifest.contentVersion}).',
      );
    }

    final report = await repository.importFrom(source, manifest: manifest);
    await prefs.setString(lastSyncKey, DateTime.now().toIso8601String());
    if (report.isComplete) {
      await prefs.setInt(contentVersionKey, manifest.contentVersion);
    }
    final partial = !report.isComplete;
    return SyncResult(
      updated: report.hasImportedContent,
      subjectCount: report.subjectCount,
      shardCount: report.shardCount,
      flashcardCount: report.flashcardCount,
      mcqCount: report.mcqCount,
      skippedFileCount: report.failures.length,
      isPartial: partial,
      contentVersion: partial ? contentVersion : manifest.contentVersion,
      message: partial
          ? 'Partial sync: ${report.subjectCount} subjects, '
                '${report.shardCount} files; ${report.failures.length} skipped. '
                'Try again.'
          : 'Synced ${report.subjectCount} subjects · ${report.shardCount} files '
                '(v${manifest.contentVersion}).',
    );
  }
}
