import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isi_project/core/models/group_model.dart';

import '../../../core/consts/routes.dart';
import '../../../core/services/auth.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';

class GroupAdminView extends StatefulWidget {
  const GroupAdminView({super.key});

  @override
  State<GroupAdminView> createState() => _GroupAdminViewState();
}

class _GroupAdminViewState extends State<GroupAdminView> {
  final DbService dbService = locator<DbService>();
  final AuthService auth = locator<AuthService>();
  late Future<List<GroupModel>> _futureGroups;

  @override
  void initState() {
    super.initState();
    _futureGroups = dbService.getAllGroups();
  }

  Future<void> _showAddGroupDialog(BuildContext context) async {

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new group'),
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
                  await dbService.createGroup(
                      GroupModel(
                          id: DateTime.timestamp().toString(),
                          name: nameController.text,
                          description: descriptionController.text,
                          usersIds: []
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
        title: const Text("Groups"),
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
        future: _futureGroups,
        builder: (context, AsyncSnapshot<List<GroupModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                GroupModel group = snapshot.data![index];
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
                      Text(group.name,style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),),
                      Text(group.description),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await dbService.deleteAnnouncement(group.id);
                              setState(() {
                                _futureGroups = dbService.getAllGroups();            });
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
          await _showAddGroupDialog(context);
          setState(() {
            _futureGroups = dbService.getAllGroups();            });
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
