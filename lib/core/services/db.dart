import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isi_project/core/models/tag_model.dart';
import 'package:isi_project/core/services/auth.dart';
import 'package:isi_project/locator.dart';

import '../models/announcement_model.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class DbService{
  FirebaseFirestore db = FirebaseFirestore.instance;




   // GRUD User
  Future<UserModel> createUser(UserModel user) async {
    try {
      await db.collection('users').doc(user.uid).set(user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<UserModel> users = [];
      querySnapshot.docs.forEach((doc) {
        users.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
      });
      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUser(String uid, UserModel newUser) async {
    try {
      await db.collection('users').doc(uid).set(newUser.toJson());
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await db.collection('users').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  // CRUD Group

  Future<GroupModel> createGroup(GroupModel group) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(group.id).set(group.toJson());
      return group;
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupModel?> getGroup(String groupId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
      if (snapshot.exists) {
        return GroupModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GroupModel>> getAllGroups() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('groups').get();
      List<GroupModel> groups = [];
      querySnapshot.docs.forEach((doc) {
        groups.add(GroupModel.fromJson(doc.data() as Map<String, dynamic>));
      });
      return groups;
    } catch (e) {
      // Gérer l'erreur
      print("Erreur lors de la récupération des groupes : $e");
      throw e;
    }
  }

  Future<GroupModel> updateGroup(String groupId, GroupModel newGroup) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(newGroup.toJson());
      return newGroup;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).delete();
    } catch (e) {
      rethrow;
    }
  }


  // GRUD Announcement
  Future<AnnouncementModel> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await FirebaseFirestore.instance.collection('announcements').doc(announcement.id).set(announcement.toJson());
      return announcement;
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }

  Future<AnnouncementModel?> getAnnouncement(String announcementId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('announcements').doc(announcementId).get();
      if (snapshot.exists) {
        return AnnouncementModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }

  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('announcements').get();
      List<AnnouncementModel> announcements = querySnapshot.docs.map((doc) => AnnouncementModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return announcements;
    } catch (e) {
      // Gérer l'erreur
      print("Erreur lors de la récupération des annonces : $e");
      throw e;
    }
  }


  Future<AnnouncementModel> updateAnnouncement(String announcementId, AnnouncementModel newAnnouncement) async {
    try {
      await FirebaseFirestore.instance.collection('announcements').doc(announcementId).update(newAnnouncement.toJson());
      return newAnnouncement;
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await FirebaseFirestore.instance.collection('announcements').doc(announcementId).delete();
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }



  // GRUD Tags
  Future<TagModel> createTag(TagModel tag) async {
    try {
      await FirebaseFirestore.instance.collection('tags').doc(tag.id).set(tag.toJson());
      return tag;
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }

  Future<TagModel?> getTag(String tagId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('tags').doc(tagId).get();
      if (snapshot.exists) {
        return TagModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }


  Future<List<TagModel>> getAllTags() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tags').get();
      List<TagModel> tags = [];
      querySnapshot.docs.forEach((doc) {
        tags.add(TagModel.fromJson(doc.data() as Map<String, dynamic>));
      });
      return tags;
    } catch (e) {
      // Gérer l'erreur
      print("Erreur lors de la récupération des tags : $e");
      throw e;
    }
  }

  Future<TagModel> updateTag(String tagId, TagModel newTag) async {
    try {
      await FirebaseFirestore.instance.collection('tags').doc(tagId).update(newTag.toJson());
      return newTag;
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }

  Future<void> deleteTag(String tagId) async {
    try {
      await FirebaseFirestore.instance.collection('tags').doc(tagId).delete();
    } catch (e) {
      // Rethrow the caught exception
      rethrow;
    }
  }


}