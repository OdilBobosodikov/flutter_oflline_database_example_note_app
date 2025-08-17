import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:offline_database_note_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Note> currentNotes = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  Future<void> addNote(String textFromUser, String titleFromUser, bool isFavorite) async {
    final newNote = Note();
    newNote.text = textFromUser;
    newNote.title = titleFromUser;
    newNote.lastModified = DateTime.now();
    newNote.isFavorite = isFavorite;

    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> updateNote(int id, String newText, String newTitle, bool isFavorite) async
  {
    final existingNote = await isar.notes.get(id);
    if(existingNote != null)
    {
      existingNote.text = newText;
      existingNote.title = newTitle;
      existingNote.lastModified = DateTime.now();
      existingNote.isFavorite = isFavorite;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> deleteNote(int id) async
  {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }

  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    await isar.writeTxn(() async {
      final existingNote = await isar.notes.get(id);
      if (existingNote != null) {
        existingNote.isFavorite = isFavorite;
        await isar.notes.put(existingNote);
      }
    });
    await fetchNotes();
  }
}
