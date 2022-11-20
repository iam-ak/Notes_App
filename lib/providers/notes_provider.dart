import 'package:flutter/material.dart';
import 'package:notes_app/services/api_services.dart';

import '../models/Note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  bool isLoadingNotes = true;

  NotesProvider() {
    fetchNotes();
  }

  void sortNotes() {
    notes.sort((f, s) => s.dateAdded!.compareTo(f.dateAdded!));
  }

  void addNote(Note note) async{
    notes.add(note);
    // sortNotes();
    notifyListeners();
    ApiServices.addNote(note);
  }

  void deleteNote(Note note) {
    int index =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(index);
    notifyListeners();
    ApiServices.deleteNote(note);
  }

  void updateNote(Note note) {
    int index =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[index] = note;
    notifyListeners();
    ApiServices.updateNote(note);
  }

  void fetchNotes() async {
    String userId = 'akshay@gmail.com';
    notes = await ApiServices.fetchNotes(userId);
    isLoadingNotes = false;
    // sortNotes();
    notifyListeners();
  }
  List<Note> getFilteredNotes(String query){
    return notes.where((element) => element.title!.toLowerCase().contains(query.toLowerCase()))
    .toList();
  }
}
