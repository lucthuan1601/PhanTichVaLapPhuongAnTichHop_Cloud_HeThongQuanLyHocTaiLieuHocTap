import 'dart:typed_data';

import 'package:googleapis/drive/v3.dart';

class DriveService {
  DriveService(this._drive);

  final DriveApi _drive;

  Future<File> uploadAttachment(Uint8List bytes, String name, String mimeType) {
    return _drive.files.create(
      File(name: name, mimeType: mimeType),
      uploadMedia: Media(Stream.value(bytes), bytes.length),
    );
  }

  Future<File> uploadDatabase(Uint8List bytes) {
    return uploadAttachment(
        bytes, 'study_documents.sqlite', 'application/x-sqlite3');
  }
}
