import '../database/database.dart';

class SyncService {
  SyncService(this.database);

  final AppDatabase database;

  Future<void> sync() async {
    // Drive/Firestore synchronization is intentionally isolated here so it can
    // be scheduled without coupling the UI to cloud SDK implementations.
  }
}
