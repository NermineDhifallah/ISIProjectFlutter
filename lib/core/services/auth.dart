import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:isi_project/core/services/db.dart';

import '../../locator.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../models/user_signUp_model.dart';

class AuthService{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  DbService db = locator<DbService>();

  Future<UserModel> signUpWithEmailAndPassword(UserSignUpModel user) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      String? fcmToken = await fcm.getToken();
      UserModel newUser = UserModel(uid:userCredential.user!.uid,firstname: user.firstname, lastname: user.lastname, email: user.email,fcmToken: fcmToken,role:Role.user,group: user.group );
      // Créer l'utilisateur dans Firestore après l'inscription réussie
      await db.createUser(newUser);
      for(var g in newUser.group){
        GroupModel? grp = await db.getGroup(g);
        if (grp != null) {
          GroupModel group = GroupModel(id: grp.id, name: grp.name, description: grp.description, usersIds: grp.usersIds);
          group.usersIds.add(newUser.uid);
          await db.updateGroup(g, group);
        } else {
        // Handle the case where the group is not found
        }
      }
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
     UserCredential credentials = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
     if (credentials.user != null){
          UserModel? userModel = await db.getUser(credentials.user!.uid);
          if(userModel != null && userModel.role == Role.user){
            String? fcmToken = await fcm.getToken();
            db.updateUser(userModel.uid, userModel.copyWith(fcmToken: fcmToken));
          }
          return userModel;
     }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
  Future<UserModel?> getLoggedInUser() async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return  db.getUser(user.uid);
    } else {
      print('No connected user');
      return null;
    }
  }



}