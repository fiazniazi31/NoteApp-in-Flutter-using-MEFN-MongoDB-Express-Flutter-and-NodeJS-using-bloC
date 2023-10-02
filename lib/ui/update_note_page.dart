import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_mongo_db/cubit/note/cubit/note_cubit.dart';
import 'package:note_app_mongo_db/models/NoteModel.dart';
import 'package:note_app_mongo_db/ui/widgets/common/common.dart';
import 'package:note_app_mongo_db/ui/widgets/customButton.dart';
import 'package:note_app_mongo_db/ui/widgets/customTextField.dart';

class UpdateNotePage extends StatefulWidget {
  final NoteModel note;
  const UpdateNotePage({super.key, required this.note});

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleControler.value = TextEditingValue(text: widget.note.title!);
    descriptionController.value =
        TextEditingValue(text: widget.note.description!);
    super.initState();
  }

  @override
  void dispose() {
    titleControler.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Note"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              CustomTextField(
                hint: "Title",
                controller: titleControler,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 10,
                  controller: descriptionController,
                  decoration: InputDecoration(
                      hintText: "Description", border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                title: "Update Note",
                onTap: updateNote,
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateNote() {
    if (titleControler.text.isEmpty) {
      showSnachBarMsg("Enter title", context);
      return;
    }
    if (descriptionController.text.isEmpty) {
      showSnachBarMsg("Enter Description", context);
      return;
    }
    context.read<NoteCubit>().updateNote(NoteModel(
        title: titleControler.text,
        description: descriptionController.text,
        noteId: widget.note.noteId,
        createAt: DateTime.now().millisecondsSinceEpoch));
    showSnachBarMsg("Note Updated Success Fully", context);
  }
}
