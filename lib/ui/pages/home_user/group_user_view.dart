import 'package:flutter/material.dart';
import '../../../core/consts/routes.dart';
import '../../../core/models/group_model.dart';
import '../../../core/services/auth.dart';
import '../../../core/services/data.dart';
import '../../../core/services/db.dart';
import '../../../locator.dart';

class GroupUserView extends StatefulWidget {
  const GroupUserView({super.key});

  @override
  State<GroupUserView> createState() => _GroupUserViewState();
}

class _GroupUserViewState extends State<GroupUserView> {

  final DbService dbService = locator<DbService>();
  final DataService dataService = locator<DataService>();
  final AuthService auth = locator<AuthService>();
  late Future<List<GroupModel>> _futureGroups;
  late Future<List<GroupModel>> _secondFuture;

  @override
  void initState() {
    super.initState();
    _futureGroups = dataService.getUserSubscribedGroups();
    _secondFuture = dataService.getUserUnsubscribedGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _futureGroups,
              builder: (context, AsyncSnapshot<List<GroupModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return _buildGroupListView(snapshot.data!);
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              // Define your second future here
              future: _secondFuture,
              builder: (context, AsyncSnapshot<List<GroupModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Handle the data from the second future here
                  return _buildSecondListView(snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupListView(List<GroupModel> groups) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          GroupModel group = groups[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                      group.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {dataService.userUnsubscribeGroup(group.id);
                          setState(() {
                            _futureGroups = dataService.getUserSubscribedGroups();
                            _secondFuture = dataService.getUserUnsubscribedGroups();
                            });
                        },
                      child: const Text("Unsubscribe"),
                    )

                  ],
                ),

                Text(group.description),
              ],
            ),
          );
        },
      ),
    );
  }

// Define your function to build the UI for the second Future's data
  Widget _buildSecondListView(List<GroupModel> data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.brown,
          width: 4,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          GroupModel group = data[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                      group.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {dataService.userSubscribeGroup(group.id);
                      setState(() {
                        _futureGroups = dataService.getUserSubscribedGroups();
                        _secondFuture = dataService.getUserUnsubscribedGroups();
                      });
                      },
                      child: const Text("Subscribe"),
                    )
                  ],
                ),

                Text(group.description),

              ],
            ),
          );
        },
      ),
    );
    // Implement your UI logic here
  }
}
