import 'dart:convert';
import 'dart:math';

import '../models/Note.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static String baseUrl = "https://frozen-crag-45936.herokuapp.com/notes";
  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse(baseUrl + '/add');
    var response = await http.post(requestUri, body: note.toMap());
    var decodedResponse = jsonDecode(response.body.toString());
    print(decodedResponse);
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse(baseUrl + '/delete');
    var response = await http.post(requestUri, body: note.toMap());
    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
  }

  static Future<void> updateNote(Note note) async {
    Uri requestUri = Uri.parse(baseUrl + '/update');
    var response = await http.post(requestUri, body: note.toMap());
    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
  }

  static Future<List<Note>> fetchNotes(String userId) async {
    Uri requestUri = Uri.parse(baseUrl + '/list');
    var response = await http.post(requestUri, body: {"userId": userId});
    var decodedResponse = jsonDecode(response.body);
    // print(decodedResponse);

    List<Note> notes = [];
    for (var noteMap in decodedResponse) {
      var note = Note.fromMap(noteMap);
      notes.add(note);
    }
    return notes;
  }
}
