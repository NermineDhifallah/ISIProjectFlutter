import 'package:cloud_firestore/cloud_firestore.dart';

import '../../locator.dart';
import '../models/announcement_model.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import 'auth.dart';
import 'db.dart';

class DataService{
  AuthService auth = locator<AuthService>();
  DbService db = locator<DbService>();


  Future<List<AnnouncementModel>> getAllUserAnnouncements() async {
    try {
      UserModel? user = await auth.getLoggedInUser();
      if(user !=null){
        List<String> grp = user.group.map((e) => e).toList();
        if(grp != null){
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('announcements').where('groupsIds',arrayContainsAny: grp).get();
          List<AnnouncementModel> announcements = querySnapshot.docs.map((doc) => AnnouncementModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
          return announcements;
        }
        else{
          return [];
        }}
      else return [];

    } catch (e) {
      // Gérer l'erreur
      print("Erreur lors de la récupération des annonces pour l'utilisateur : $e");
      throw e;
    }
  }


  Future<List<GroupModel>> getUserSubscribedGroups() async {
    try {
      UserModel? user = await auth.getLoggedInUser();
      if(user !=null){
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('groups').where('usersIds', arrayContains: user.uid).get();
          List<GroupModel> groups = [];
          querySnapshot.docs.forEach((doc) {
            groups.add(GroupModel.fromJson(doc.data() as Map<String, dynamic>));
          });
          return groups;
            }
        else{
          return [];
        }
    } catch (e) {
      // Gérer l'erreur
      print("Erreur lors de la récupération des groupes dont les quels l'utilisateur est inscrit : $e");
      throw e;
    }
  }

  Future<List<GroupModel>> getUserUnsubscribedGroups() async {
      try {
        UserModel? user = await auth.getLoggedInUser();
        if(user !=null){
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('groups').get();
            List<GroupModel> groups = querySnapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return GroupModel.fromJson(data);
            }).toList();

            List<GroupModel> filteredGroups = groups.where((group) => !group.usersIds.contains(user.uid)).toList();

            return filteredGroups;

              }
          else{
            return [];
          }
      } catch (e) {
        // Gérer l'erreur
        print("Erreur lors de la récupération des groupes dont les quels l'utilisateur n'est pas inscrit  : $e");
        throw e;
      }
    }

    Future<GroupModel?> userUnsubscribeGroup(String id) async {
      try {
        UserModel? user = await auth.getLoggedInUser();
        if(user !=null) {
          GroupModel? grp = await db.getGroup(id);
          UserModel? usertoupdate = await db.getUser(user.uid);
          if(usertoupdate != null){
            UserModel newUser = UserModel(uid: usertoupdate.uid,
                firstname: usertoupdate.firstname,
                lastname: usertoupdate.lastname,
                email: usertoupdate.email,
                role: usertoupdate.role,
                group: usertoupdate.group);

                newUser.group.remove(id);
                db.updateUser(usertoupdate.uid, newUser);
          }
          if (grp != null) {
            GroupModel updateGrp = GroupModel(id: grp.id,
                name: grp.name,
                description: grp.description,
                usersIds: grp.usersIds);
            updateGrp.usersIds.remove(user.uid);
            db.updateGroup(grp.id, updateGrp);

            return updateGrp;
          }

        }
      } catch (e) {
        // Gérer l'erreur
        print("Erreur lors de déinscrir d'un groupe : $e");
        throw e;
      }
    }

    Future<GroupModel?> userSubscribeGroup(String id) async {
      try {
        UserModel? user = await auth.getLoggedInUser();
        if(user !=null) {
          GroupModel? grp = await db.getGroup(id);
          UserModel? usertoupdate = await db.getUser(user.uid);
          if(usertoupdate != null){
            UserModel newUser = UserModel(uid: usertoupdate.uid,
                firstname: usertoupdate.firstname,
                lastname: usertoupdate.lastname,
                email: usertoupdate.email,
                role: usertoupdate.role,
                group: usertoupdate.group);

            newUser.group.add(id);
            db.updateUser(usertoupdate.uid, newUser);
          }
          if (grp != null) {
            GroupModel updateGrp = GroupModel(id: grp.id,
                name: grp.name,
                description: grp.description,
                usersIds: grp.usersIds);
            updateGrp.usersIds.add(user.uid);
            db.updateGroup(grp.id, updateGrp);

            return updateGrp;
          }
        }
      } catch (e) {
        // Gérer l'erreur
        print("Erreur lors de s'inscrir à un groupe : $e");
        throw e;
      }
    }





}