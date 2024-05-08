import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isi_project/core/services/data.dart';

import '../../../core/consts/routes.dart';
import '../../../core/models/announcement_model.dart';
import '../../../core/services/auth.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';

class AnnouncementUserView extends StatefulWidget {
  const AnnouncementUserView({super.key});

  @override
  State<AnnouncementUserView> createState() => _AnnouncementUserViewState();
}

class _AnnouncementUserViewState extends State<AnnouncementUserView> {
  final DbService dbService = locator<DbService>();
  final DataService dataService = locator<DataService>();
  final AuthService auth = locator<AuthService>();
  late Future<List<AnnouncementModel>> _futureAnnouncements;

  @override
  void initState() {
    super.initState();
    _futureAnnouncements = dataService.getAllUserAnnouncements();
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                vertical: 5, horizontal: 10),
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
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
