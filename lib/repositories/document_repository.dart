import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../models/document_struct.dart';

class DocumentRepository {
  DocumentRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Stream<List<Document>> watchDocuments(
      {String query = '', DocumentType? type}) {
    final statement = _database.select(_database.documents)
      ..orderBy([(document) => OrderingTerm.desc(document.updatedAt)]);
    if (type != null) {
      statement.where((document) => document.type.equals(type.name));
    }
    final normalizedQuery = _normalize(query);
    return statement.watch().map((documents) {
      if (normalizedQuery.isEmpty) return documents;

      final words = normalizedQuery.split(' ');
      return documents.where((document) {
        final title = _normalize(document.title);
        return words.every(title.contains);
      }).toList();
    });
  }

  static String _normalize(String value) {
    const replacements = {
      'à': 'a',
      'á': 'a',
      'ạ': 'a',
      'ả': 'a',
      'ã': 'a',
      'â': 'a',
      'ầ': 'a',
      'ấ': 'a',
      'ậ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ă': 'a',
      'ằ': 'a',
      'ắ': 'a',
      'ặ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'è': 'e',
      'é': 'e',
      'ẹ': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ê': 'e',
      'ề': 'e',
      'ế': 'e',
      'ệ': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ì': 'i',
      'í': 'i',
      'ị': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ò': 'o',
      'ó': 'o',
      'ọ': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ô': 'o',
      'ồ': 'o',
      'ố': 'o',
      'ộ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ơ': 'o',
      'ờ': 'o',
      'ớ': 'o',
      'ợ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ù': 'u',
      'ú': 'u',
      'ụ': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ư': 'u',
      'ừ': 'u',
      'ứ': 'u',
      'ự': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ỳ': 'y',
      'ý': 'y',
      'ỵ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'đ': 'd',
    };

    final lower = value.trim().toLowerCase();
    final withoutDiacritics = lower.split('').map((character) {
      return replacements[character] ?? character;
    }).join();
    return withoutDiacritics.replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<void> save({
    String? id,
    required String title,
    String? description,
    required DocumentType type,
    String? filePath,
  }) async {
    final now = DateTime.now();
    await _database.into(_database.documents).insertOnConflictUpdate(
          DocumentsCompanion.insert(
            id: id ?? _uuid.v4(),
            title: title.trim(),
            description: Value(description?.trim()),
            type: type.name,
            filePath: Value(filePath),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> delete(String id) =>
      (_database.delete(_database.documents)..where((row) => row.id.equals(id)))
          .go();
}
