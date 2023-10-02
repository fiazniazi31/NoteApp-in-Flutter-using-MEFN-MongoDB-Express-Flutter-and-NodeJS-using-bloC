import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_app_mongo_db/cubit/auth/cubit/auth_cubit.dart';
import 'package:note_app_mongo_db/cubit/note/cubit/note_cubit.dart';
import 'package:note_app_mongo_db/models/NoteModel.dart';
import 'package:note_app_mongo_db/router/page_const.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<NoteCubit>().getMyNotes(
          NoteModel(creatorId: widget.uid),

          ///
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, PageConst.addNotePage,
              arguments: widget.uid);
        },
      ),
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.profilePage,
                      arguments: widget.uid);
                },
                child: Icon(Icons.person_2_outlined)),
            SizedBox(
              width: 20,
            ),
            Text("My Notes"),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          InkWell(
              onTap: () {
                context.read<NoteCubit>().getMyNotes(
                      NoteModel(creatorId: widget.uid),
                    );
              },
              child: Icon(Icons.refresh)),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {
                context.read<AuthCubit>().loggedOut();
              },
              child: Icon(Icons.logout_outlined)),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, noteState) {
          if (noteState is NoteLoaded) {
            final Notes = noteState.notes;

            Notes.sort((a, b) => DateTime.fromMillisecondsSinceEpoch(
                    b.createAt!.toInt())
                .compareTo(
                    DateTime.fromMillisecondsSinceEpoch(a.createAt!.toInt())));

            return Notes.isEmpty
                ? addNoteMsgWidget()
                : ListView.builder(
                    itemCount: Notes.length,
                    itemBuilder: (context, index) {
                      final note = Notes[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageConst.updateNotePage,
                                arguments: note);
                          },
                          title: Text("${note.title}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${note.description}"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(DateFormat("dd MMMM yyy hh:mm a").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      note.createAt!.toInt())))
                            ],
                          ),
                          trailing: InkWell(
                              onTap: () {
                                context
                                    .read<NoteCubit>()
                                    .deleteNote(NoteModel(noteId: note.noteId))
                                    .then((value) {
                                  context.read<NoteCubit>().getMyNotes(
                                      NoteModel(creatorId: widget.uid));
                                });
                              },
                              child: Icon(Icons.delete)),
                        ),
                      );
                    },
                  );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  addNoteMsgWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add Notes",
            style: TextStyle(
                fontSize: 30,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(.5)),
          )
        ],
      ),
    );
  }
}
