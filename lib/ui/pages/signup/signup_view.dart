import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isi_project/core/models/user_signUp_model.dart';
import 'package:isi_project/core/services/auth.dart';
import 'package:isi_project/locator.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../../core/consts/routes.dart';
import '../../../core/models/group_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/db.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthService authService = locator<AuthService>();

  final DbService dbService = locator<DbService>();
  late Future<List<GroupModel>> _futureGroups;

  List<GroupModel> selectedGroups = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureGroups = dbService.getAllGroups();
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      authService.signUpWithEmailAndPassword(UserSignUpModel(
          firstname: firstnameController.text,
          lastname: lastnameController.text,
          email: emailController.text,
          password: passwordController.text,
          group: selectedGroups.map((e) => e.id).toList()));
    }
    authService.getLoggedInUser().then((value) {
      if(value==null){
        Navigator.of(context).pushNamed(Routes.splashScreen);
      }else{
        if(value.role==Role.admin){
          Navigator.of(context).pushNamed(Routes.homeAdmin);
        }else{
          Navigator.of(context).pushNamed(Routes.homeUser);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextFormField(
                    controller: firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      final bool emailValid =
                          RegExp(r"^[a-zA-Z]+$").hasMatch(value);
                      if (!emailValid) {
                        return "Only alphabetic characters are allowed.";
                      }
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Firstname',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18)))),
                  )),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextFormField(
                    controller: lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      final bool emailValid =
                          RegExp(r"^[a-zA-Z]+$").hasMatch(value);
                      if (!emailValid) {
                        return "Only alphabetic characters are allowed.";
                      }
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Lastname',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18)))),
                  )),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      final bool emailValid =
                          RegExp(r"^[a-zA-Z.]+@etudiant-isi\.utm\.tn$")
                              .hasMatch(value);
                      if (!emailValid) {
                        return "You must use your académic email ";
                      }
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18)))),
                  )),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      if (value.length < 6) {
                        return "Password must be 6 characters or longer.";
                      }
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18)))),
                  )),
              FutureBuilder(
                future: _futureGroups,
                builder: (BuildContext context, snapshat) {
                  if (!snapshat.hasData) return SizedBox();
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Groups"),
                      title: const Text("Groups"),
                      items: snapshat.data!
                          .map((e) => MultiSelectItem<GroupModel>(e, e.name))
                          .toList(),
                      onConfirm: (values) {
                        selectedGroups =
                            values.map((e) => e as GroupModel).toList();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            selectedGroups.remove(value);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    child: const Text("Sign Up"),
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(Routes.login),
                    child: const Text(
                      "Already have an account ?",
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
