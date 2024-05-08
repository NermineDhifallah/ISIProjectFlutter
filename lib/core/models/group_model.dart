// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
  String id;
  String name;
  String description;
  List<String> usersIds;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.usersIds,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    usersIds: List<String>.from(json["usersIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "usersIds": List<dynamic>.from(usersIds.map((x) => x)),
  };
}
