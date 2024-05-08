import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isi_project/core/models/tag_model.dart';

import '../../../core/consts/routes.dart';
import '../../../core/services/auth.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';

class TagAdminView extends StatefulWidget {
  const TagAdminView({super.key});

  @override
  State<TagAdminView> createState() => _TagAdminViewState();
}

class _TagAdminViewState extends State<TagAdminView> {

  final DbService dbService = locator<DbService>();
  final AuthService auth = locator<AuthService>();
  late Future<List<TagModel>> _futureTags;

  @override
  void initState() {
    super.initState();
    _futureTags = dbService.getAllTags();
  }

  Future<void> _showAddTagDialog(BuildContext context) async {

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new tag'),
          content: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(18))
                            )
                        ),
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(18))
                            )
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if(formkey.currentState!.validate()){
                  await dbService.createTag(
                      TagModel(
                          id: DateTime.timestamp().toString(),
                          name: nameController.text,
                          description: descriptionController.text,
                      )
                  );
                  Navigator.of(context).pop();// Fermer la boîte de dialogue
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
        title: const Text("Tags"),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
        actions:  [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            onSelected: (String result) async {
              if (result =='disconnect'){
                await auth.signOut();
                Navigator.of(context).pushNamed(Routes.splashScreen);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'disconnect',
                child: Text('Disconnect'),
              ),
            ],
          ),

        ],
      ),
      body: FutureBuilder(
        future: _futureTags,
        builder: (context, AsyncSnapshot<List<TagModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                TagModel tag = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tag.name,style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),),
                      Text(tag.description),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await dbService.deleteAnnouncement(tag.id);
                              setState(() {
                                _futureTags = dbService.getAllTags();            });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddTagDialog(context);
          setState(() {
            _futureTags = dbService.getAllTags();    });
        },
        elevation: 0,
        focusElevation: 0.1,
        hoverElevation: 0.1,
        highlightElevation: 0.1,
        disabledElevation: 0,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
        child: const Icon(Icons.add),
      ),
    );
  }
}
