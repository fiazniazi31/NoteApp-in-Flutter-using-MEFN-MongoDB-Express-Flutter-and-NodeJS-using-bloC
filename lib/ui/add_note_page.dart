import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_mongo_db/cubit/note/cubit/note_cubit.dart';
import 'package:note_app_mongo_db/models/NoteModel.dart';
import 'package:note_app_mongo_db/ui/widgets/common/common.dart';
import 'package:note_app_mongo_db/ui/widgets/customButton.dart';
import 'package:note_app_mongo_db/ui/widgets/customTextField.dart';

class AddNotePage extends StatefulWidget {
  final String uid;
  const AddNotePage({super.key, required this.uid});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
        title: Text("Add Your Note Here"),
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
                title: "Add Note",
                onTap: addNote,
              )
            ],
          ),
        ),
      ),
    );
  }

  void addNote() {
    if (titleControler.text.isEmpty) {
      showSnachBarMsg("Enter title", context);
      return;
    }
    if (descriptionController.text.isEmpty) {
      showSnachBarMsg("Enter Description", context);
      return;
    }
    context
        .read<NoteCubit>()
        .addNote(NoteModel(
          title: titleControler.text,
          description: descriptionController.text,
          creatorId: widget.uid,
        ))
        .then((value) {
      clear();
    });
  }

  void clear() {
    titleControler.clear();
    descriptionController.clear();
    showSnachBarMsg("New Note Add Successfully", context);
    setState(() {});
  }
}
