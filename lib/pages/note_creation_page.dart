import 'package:flutter/material.dart';
import 'package:offline_database_note_app/models/note_database.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';

class NoteCreationPage extends StatefulWidget {
  final Note? note;

  const NoteCreationPage({super.key, this.note});

  @override
  State<NoteCreationPage> createState() => _NoteCreationPageState();
}

class _NoteCreationPageState extends State<NoteCreationPage> {
  late var titleController = TextEditingController();
  late var textController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _textFocus = FocusNode();

  bool favoriteStatus = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note?.title ?? "");
    textController = TextEditingController(text: widget.note?.text ?? "");

    favoriteStatus = widget.note?.isFavorite ?? false;

    _textFocus.addListener(() {
      setState(() {});
    });
    _titleFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  bool _hasText() {
    return titleController.text.trim().isNotEmpty ||
        textController.text.trim().isNotEmpty;
  }

  void updateFavoriteStatus() {
    setState(() {
      favoriteStatus = !favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(_hasText())
            {
              if (widget.note != null) {
                context.read<NoteDatabase>().updateNote(
                  widget.note!.id,
                  textController.text,
                  titleController.text,
                  favoriteStatus,
                );
              } else {
                context.read<NoteDatabase>().addNote(
                  textController.text,
                  titleController.text,
                  favoriteStatus,
                );
              }
            }
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: updateFavoriteStatus,
              icon: Icon(
                favoriteStatus ? Icons.favorite : Icons.favorite_border,
                color: favoriteStatus ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: [
            TextField(
              focusNode: _titleFocus,
              controller: titleController,
              maxLines: 1,
              cursorColor: Colors.transparent,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 30),
              decoration: InputDecoration(

                hintText: "Title",
                hintStyle: TextStyle(
                  fontSize: 30,
                  color: _titleFocus.hasFocus ? Colors.black : Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                focusNode: _textFocus,
                controller: textController,
                keyboardType: TextInputType.multiline,
                maxLines: null, // 👈 unlimited lines
                expands: true,  // 👈 fills available space
                cursorColor: Colors.transparent,
                textAlignVertical: TextAlignVertical.top, // 👈 align text at the top
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Body",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: _textFocus.hasFocus ? Colors.black : Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
