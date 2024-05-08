import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/announcement_model.dart';
import '../../../core/services/data.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';

class HomeTv extends StatefulWidget {
  const HomeTv({super.key});

  @override
  State<HomeTv> createState() => _HomeTvState();
}

class _HomeTvState extends State<HomeTv> {
  final DbService dbService = locator<DbService>();
  final DataService dataService = locator<DataService>();
  late Future<List<AnnouncementModel>> _futureAnnouncements;

  @override
  void initState() {
    super.initState();
    _futureAnnouncements = dbService.getAllAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
        title: const Text("Announcements",style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600
        ),),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(announcement.title,style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900
                          ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal:20),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                              color: Colors.purple.withOpacity(0.3),
                            ),
                            child: Text(announcement.tag,style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(announcement.description,style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w400
                        ),),
                      ),

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
