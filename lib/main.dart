import 'package:flutter/material.dart';

import 'database/database.dart';
import 'database/platform/stub.dart'
    if (dart.library.io) 'database/platform/native.dart'
    if (dart.library.html) 'database/platform/web.dart';
import 'pages/document_list_page.dart';
import 'repositories/document_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase(openConnection());
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tài liệu học tập',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2FBF9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB2DFDB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
        ),
      ),
      home: DocumentListPage(repository: DocumentRepository(database)),
    );
  }
}
