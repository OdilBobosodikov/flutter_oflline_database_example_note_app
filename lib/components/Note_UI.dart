import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/note_database.dart';
import '../pages/note_creation_page.dart';
import '../themes/color.dart';

class NoteUi extends StatelessWidget {
  final int index;
  final Note note;
  final void Function() updateFunc;
  const NoteUi({super.key, required this.index, required this.note, required this.updateFunc});

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<NoteDatabase>().deleteNote(note.id);
              Navigator.of(context).pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = NoteColor.colors[index % NoteColor.colors.length];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NoteCreationPage(note: note),
        ));
      },
      onLongPress: () {
        showDeleteDialog(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: noteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.title?.isNotEmpty == true ? note.title! : "Untitled",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(

                  onPressed: updateFunc,
                  icon: Icon(
                    size: 22,
                    note.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: note.isFavorite ? Colors.red : Colors.black54,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                note.text?.isNotEmpty == true ? note.text! : "No content",
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('MMMM d, HH:mm').format(note.lastModified),
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


