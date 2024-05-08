import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/consts/routes.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
              child: ElevatedButton(
                onPressed: () {Navigator.of(context).pushNamed(Routes.login);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                  Text("Sign In",style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),),
                ]
              ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
              child: ElevatedButton(
                onPressed: () {Navigator.of(context).pushNamed(Routes.signUp);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                  Text("Sign Up",style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),),
                ]
              ),
              ),
            ),


          ],
        ),
    );
  }
}
