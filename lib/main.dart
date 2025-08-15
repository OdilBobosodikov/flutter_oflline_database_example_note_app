import 'package:flutter/material.dart';
import 'package:offline_database_note_app/models/note_database.dart';
import 'package:offline_database_note_app/pages/note_creation_page.dart';
import 'package:offline_database_note_app/pages/note_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(
    ChangeNotifierProvider(create: (context) => NoteDatabase(),
    child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NotePage(),
      routes: {
        "/note_creation_page": (context) => const NoteCreationPage(),
      },
    );
  }
}
