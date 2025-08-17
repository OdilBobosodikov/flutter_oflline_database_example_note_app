import 'package:flutter/material.dart';
import 'package:offline_database_note_app/components/Note_UI.dart';
import 'package:offline_database_note_app/models/note_database.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../themes/color.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  void readNotes() => context.watch<NoteDatabase>().fetchNotes();

  void updateFavoriteStatus(int id, bool isFavorite) =>
      context.watch<NoteDatabase>().updateFavoriteStatus(id, isFavorite);

  @override
  Widget build(BuildContext context) {
    readNotes();
    final noteDatabase = context.watch<NoteDatabase>();

    List<Note> notes = noteDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 4,
        title: Text(
          "📝 My Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        padding: const EdgeInsets.all(12),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteUi(
            index: index,
            note: notes[index],
            updateFunc: () => {
              context.read<NoteDatabase>().updateFavoriteStatus(
                notes[index].id,
                !notes[index].isFavorite,
              ),
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed("/note_creation_page");
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("New Note", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
      ),
    );
  }
}
