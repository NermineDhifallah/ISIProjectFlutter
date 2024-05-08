import 'dart:convert';

import 'package:isi_project/core/models/user_model.dart';

class UserSignUpModel {
  String firstname;
  String lastname;
  String email;
  String password;
  List<String> group;

  UserSignUpModel({

    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.group,
  });

}

