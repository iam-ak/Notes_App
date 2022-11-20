import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/Note.dart';
import 'package:notes_app/pages/add_new_note_page.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController searchController=TextEditingController();
  String query="";

  @override
  void initState() {
    // TODO: implement initState
    NotesProvider().fetchNotes();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        centerTitle: true,
      ),
      body: (notesProvider.isLoadingNotes)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: (notesProvider.notes.length == 0)
                  ? Center(
                      child: Text("No notes yet"),
                    )
                  : ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              query=value;
                            });
                          },
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(
                            // ),
                            icon: Icon(Icons.search),
                            hintText: "search"
                          ),
                          controller: searchController,
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          itemCount: notesProvider.getFilteredNotes(query).length,
                          itemBuilder: (context, index) {
                            Note currentNote = notesProvider.getFilteredNotes(query)[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => AddNewNotePage(
                                        isUpdate: true,
                                        note: currentNote,
                                      ),
                                    ));
                              },
                              onLongPress: () {
                                notesProvider.deleteNote(currentNote);
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentNote.title!,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        currentNote.content!,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey[700]),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(currentNote.dateAdded.toString()),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AddNewNotePage(
                        isUpdate: false,
                      ),
                  fullscreenDialog: true));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
