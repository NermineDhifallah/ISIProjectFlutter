import 'package:flutter/material.dart';
import 'package:isi_project/core/models/user_model.dart';

import '../../../core/consts/routes.dart';
import '../../../core/services/auth.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';
import '../../shared/text_icon_widget.dart';

class UserAdminView extends StatefulWidget {
  const UserAdminView({super.key});

  @override
  State<UserAdminView> createState() => _UserAdminViewState();
}

class _UserAdminViewState extends State<UserAdminView> {
  final DbService dbService = locator<DbService>();
  final AuthService auth = locator<AuthService>();
  late Future<List<UserModel>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = dbService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Users List"),
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
        future: _futureUsers,
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UserModel user = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextIconWidget(
                                iconData: Icons.person, text: user.firstname),
                            TextIconWidget(
                                iconData: Icons.person, text: user.lastname),
                            TextIconWidget(
                                iconData: Icons.email, text: user.email),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await dbService.deleteUser(user.uid);
                                setState(() {
                                  _futureUsers = dbService.getAllUsers();
                                });
                              },
                            )
                          ],
                        ),
                      ]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
