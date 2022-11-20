import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/Note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewNotePage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  AddNewNotePage({super.key, required this.isUpdate, this.note});

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentControler = TextEditingController();
  FocusNode noteFocus = FocusNode();
  void addNewNote() {
    Note note = Note(
      id: Uuid().v1(),
      userId: 'akshay@gmail.com',
      title: titleController.text,
      content: contentControler.text,
      dateAdded: DateTime.now(),
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(note);
  }
  void updateNote(){
    widget.note!.title=titleController.text;
    widget.note!.content=contentControler.text;
    Provider.of<NotesProvider>(context,listen: false).updateNote(widget.note!);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isUpdate == true) {
      titleController.text = widget.note!.title!;
      contentControler.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Note"),
        actions: [
          IconButton(
              onPressed: () {
                if (titleController.text == "") {
                  return;
                }
                if (widget.isUpdate==true){
                  updateNote();
                }
                else {
                  addNewNote();
                }
                Navigator.pop(context);
              },
              icon: Icon(Icons.check)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onSubmitted: (value) {
                if (value != "") {
                  noteFocus.requestFocus();
                }
              },
              autofocus: !widget.isUpdate,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: contentControler,
                focusNode: noteFocus,
                maxLines: null,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: "content",
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
