import 'package:flutter/cupertino.dart';

import '../../../core/models/announcement_model.dart';
import '../../../core/services/data.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';

class SingleAnnouncement extends StatefulWidget {
  const SingleAnnouncement({super.key});

  @override
  State<SingleAnnouncement> createState() => _SingleAnnouncementState();
}

class _SingleAnnouncementState extends State<SingleAnnouncement> {
  
  final DbService dbService = locator<DbService>();
  final DataService dataService = locator<DataService>();
  late Future<AnnouncementModel> _futureAnnouncement;

  @override
  void initState() {
    super.initState();
   // _futureAnnouncement = dbService.getAnnouncement(announcementId);
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
