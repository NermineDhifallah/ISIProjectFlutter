import 'dart:convert';

TagModel announcementModelFromJson(String str) => TagModel.fromJson(json.decode(str));

String announcementModelToJson(TagModel data) => json.encode(data.toJson());

class TagModel {
  String id;
  String name;
  String description;

  TagModel({
    required this.id,
    required this.name,
    required this.description
  });

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description
  };
}