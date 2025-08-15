import 'package:flutter/material.dart';

class NoteCreationPage extends StatefulWidget {
  const NoteCreationPage({super.key});

  @override
  State<NoteCreationPage> createState() => _NoteCreationPageState();
}

class _NoteCreationPageState extends State<NoteCreationPage> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _textFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(() {
      setState(() {});
    });
    _titleFocus.addListener(() {
      setState(() {}); // Rebuild when focus changes
    });
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              style: TextStyle(fontSize: 30),
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  fontSize: 30,
                  color: _titleFocus.hasFocus ? Colors.black : Colors.grey,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: InputBorder.none,
              ),
            ),


            TextField(
              focusNode: _textFocus,
              controller: textController,
              cursorColor: Colors.transparent,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Body",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: _textFocus.hasFocus ? Colors.black : Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
