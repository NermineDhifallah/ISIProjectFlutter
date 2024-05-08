import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isi_project/core/models/tag_model.dart';

AnnouncementModel announcementModelFromJson(String str) => AnnouncementModel.fromJson(json.decode(str));

String announcementModelToJson(AnnouncementModel data) => json.encode(data.toJson());

class AnnouncementModel {
  String id;
  String title;
  String description;
  List<String> groupsIds;
  String tag;
  DateTime createdAt;
  Priority priority;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.groupsIds,
    required this.tag,
    required this.priority,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) => AnnouncementModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    groupsIds: List<String>.from(json["groupsIds"].map((x) => x)),
    tag: json["tag"],
    priority: Priority.values[json["priority"]],
    createdAt: (json["createdAt"] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "groupsIds": List<dynamic>.from(groupsIds.map((x) => x)),
    "tag": tag,
    "priority": priority.index,
    "createdAt": Timestamp.fromDate(createdAt),
  };
}



enum Priority{
  urgent, standard
}