import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isi_project/core/models/user_model.dart';
import 'package:isi_project/core/services/auth.dart';
import 'package:isi_project/core/services/db.dart';
import 'package:isi_project/locator.dart';

import '../../core/consts/routes.dart';
import '../../core/services/data.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final AuthService auth = locator<AuthService>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.getLoggedInUser().then((value) {
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
     return  Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            child: AspectRatio(aspectRatio: 1.7,
                child: Image.asset('assets/images/student.png',)),
          ),
         ],
      ),
    );
  }
}
