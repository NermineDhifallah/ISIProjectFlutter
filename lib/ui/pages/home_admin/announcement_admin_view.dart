import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isi_project/core/models/group_model.dart';
import 'package:isi_project/core/services/db.dart';
import 'package:isi_project/locator.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../core/consts/routes.dart';
import '../../../core/models/announcement_model.dart';
import '../../../core/models/tag_model.dart';
import '../../../core/services/auth.dart';

class AnnouncementAdminView extends StatefulWidget {
  const AnnouncementAdminView({super.key});

  @override
  State<AnnouncementAdminView> createState() => _AnnouncementAdminViewState();
}

class _AnnouncementAdminViewState extends State<AnnouncementAdminView> {
  final DbService dbService = locator<DbService>();
  final AuthService auth = locator<AuthService>();
  late Future<List<AnnouncementModel>> _futureAnnouncements;

  @override
  void initState() {
    super.initState();
    _futureAnnouncements = dbService.getAllAnnouncements();
  }

  Future<void> _showAddAnnouncementDialog(BuildContext context) async {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    var result = await Future.wait<List>(
        [dbService.getAllTags(), dbService.getAllGroups()]);
    List<TagModel> tags = result.first as List<TagModel>;

    List<GroupModel> groups = result.last as List<GroupModel>;

    List<GroupModel> selectedGroups = [];

    String? selectedTag;
    Priority? selectedPriority;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new announcement'),
          content: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2),
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)))),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)))),
                      )),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Groups"),
                      title: const Text("Groups"),
                      items: groups
                          .map((e) => MultiSelectItem<GroupModel>(e, e.name))
                          .toList(),
                      onConfirm: (values) {
                        selectedGroups =
                            values.map((e) => e as GroupModel).toList();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            selectedGroups.remove(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: DropdownButtonFormField<String>(
                      value: selectedTag,
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      decoration: const InputDecoration(
                          hintText: 'Tag',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)))),
                      items: tags.map((TagModel tag) {
                        return DropdownMenuItem<String>(
                          value: tag.name,
                          child: Text(tag.name),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedTag = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: DropdownButtonFormField<Priority>(
                      value: selectedPriority,
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      decoration: const InputDecoration(
                        hintText: 'Priority',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                      items: Priority.values.map((Priority priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(priority == Priority.standard
                              ? 'Standard'
                              : 'Urgent'),
                        );
                      }).toList(),
                      onChanged: (Priority? value) {
                        setState(() {
                          selectedPriority = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  await dbService.createAnnouncement(AnnouncementModel(
                    id: DateTime.timestamp().toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    groupsIds: selectedGroups.map((e) => e.id).toList(),
                    tag: selectedTag != null ? selectedTag! : "",
                    priority: Priority.standard,
                    createdAt: DateTime.now(),
                  ));
                  Navigator.of(context).pop();
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
        automaticallyImplyLeading: false,
        title: const Text("Announcements"),
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
        future: _futureAnnouncements,
        builder: (context, AsyncSnapshot<List<AnnouncementModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                AnnouncementModel announcement = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              color: Colors.purple.withOpacity(0.3),
                            ),
                            child: Text(
                              announcement.tag,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(announcement.description),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await dbService
                                  .deleteAnnouncement(announcement.id);
                              setState(() {
                                _futureAnnouncements =
                                    dbService.getAllAnnouncements();
                              });
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
          await _showAddAnnouncementDialog(context);
          setState(() {
            _futureAnnouncements = dbService.getAllAnnouncements();
          });
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
