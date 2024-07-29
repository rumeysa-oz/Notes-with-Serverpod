import 'package:notes_client/notes_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'loading_screen.dart';
import 'note_dialog.dart';

var client = Client('http://localhost:8080/')..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Notes',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Note>? _notes;
  Exception? _connectionException;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _deleteNote(Note note) async {
    try {
      await client.notes.deleteNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _createNote(Note note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _updateNote(Note note) async {
    try {
      await client.notes.updateNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _notes == null
          ? LoadingScreen(
              exception: _connectionException,
              onTryAgain: _loadNotes,
            )
          : ListView.builder(
              itemCount: _notes!.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.solid, color: Colors.black54, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.all(3.0),
                  child: ListTile(
                    title: Text(_notes![index].text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 35, 206, 44)),
                          onPressed: () {
                            _showNoteDialog(context, _notes![index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 226, 60, 60)),
                          onPressed: () {
                            var note = _notes![index];

                            setState(() {
                              _notes!.remove(note);
                            });

                            _deleteNote(note);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: _notes == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                showNoteDialog(
                  context: context,
                  onSaved: (text) {
                    var note = Note(
                      text: text,
                    );

                    setState(() {
                      _notes!.add(note);
                    });

                    _createNote(note);
                  },
                );
              },
              backgroundColor: Colors.grey,
              child: const Icon(Icons.add),
            ),
    );
  }

  void _showNoteDialog(BuildContext context, Note note) {
    showNoteDialog(
      context: context,
      text: note.text,
      onSaved: (text) {
        setState(() {
          note.text = text;
          _updateNote(note);
          // Find the index of the updated note
          int index = _notes!.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            // Replace the old note with the updated one
            _notes![index] = note;
          }
        });
      },
    );
  }
}
