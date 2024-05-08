import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:isi_project/core/consts/routes.dart';
import 'package:isi_project/core/services/auth.dart';
import 'package:isi_project/locator.dart';

import '../../../core/models/user_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthService authService = locator<AuthService>();

  void onSubmit(BuildContext context) async {
    if(formkey.currentState!.validate()){
      try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
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

      }catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Wrong Email or Password'))
          );
        }
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
        title: const Text("Login"),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),

      ),
      body: Form(
        key: formkey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))
                    )
              ),
            )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Required Field";
                    }
                    if(value.length<6) {
                      return "Password must be 6 characters or longer.";
                    }
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))
                      )
                  ),
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => onSubmit(context),
                  child: const Text("Login"),
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(onTap: () => Navigator.of(context).pushNamed(Routes.signUp),
                  child: const Text("Don't have an account ?",
                    style: TextStyle(
                      color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),

                )
            ),
          ],
        ),
      ),
    );
  }
}
