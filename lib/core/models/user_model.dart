import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String uid;
  String firstname;
  String lastname;
  String email;
  String? fcmToken;
  Role role;
  List<String> group;

  UserModel({
  required this.uid,
  required this.firstname,
  required this.lastname,
  required this.email,
  this.fcmToken,
  required this.role,
  required this.group,
  });

  UserModel copyWith({
    String? uid,
    String? firstname,
    String? lastname,
    String? email,
    String? fcmToken,
    Role? role,
    List<String>? group,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
      group: group ?? this.group,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    fcmToken: json["fcmToken"],
    role: Role.values[json["role"]],
    group: List<String>.from(json["group"].map((x) => x)),

  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "fcmToken": fcmToken,
    "role": role.index,
    "group": List<dynamic>.from(group.map((x) => x)),
  };
}

enum Role {
  user, admin
}