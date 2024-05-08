import 'package:flutter/material.dart';
import 'package:isi_project/ui/pages/home_admin/announcement_admin_view.dart';
import 'package:isi_project/ui/pages/home_admin/group_admin_view.dart';
import 'package:isi_project/ui/pages/home_admin/tag_admin_view.dart';
import 'package:isi_project/ui/pages/home_admin/user_admin_view.dart';

class HomeAdminView extends StatefulWidget {
  const HomeAdminView({super.key});

  @override
  State<HomeAdminView> createState() => _HomeAdminViewState();
}

class _HomeAdminViewState extends State<HomeAdminView> {

  int index = 0;

  void onIndexChanged(int? i){
    if (i!=null){
      setState(() {
        index = i;
      });
    }
  }

  static const tabs = [
    AnnouncementAdminView(),
    GroupAdminView(),
    TagAdminView(),
    UserAdminView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type:  BottomNavigationBarType.fixed,
        onTap: onIndexChanged,
        items: const [
           BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: "Announcements",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: "Tags",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Users",
          ),
        ],
      ),
      body: tabs[index],
    );
  }
}
