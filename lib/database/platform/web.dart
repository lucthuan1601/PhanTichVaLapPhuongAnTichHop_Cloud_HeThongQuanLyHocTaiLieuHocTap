// Drift's IndexedDB backend is retained for compatibility with the current
// dependency set; migration to the Wasm backend can be done independently.
// ignore_for_file: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() => WebDatabase('study_documents');
