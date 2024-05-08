import 'package:flutter/material.dart';
import 'package:isi_project/ui/pages/firstScreen.dart';
import 'package:isi_project/ui/pages/home_admin/home_admin_view.dart';
import 'package:isi_project/ui/pages/home_user/home_user_view.dart';
import 'package:isi_project/ui/pages/login/login_view.dart';
import 'package:isi_project/ui/pages/signup/signup_view.dart';
import 'package:isi_project/ui/pages/splash_screen.dart';
import 'package:isi_project/ui/pages/tv_pages/home_tv.dart';

import 'core/consts/routes.dart';


Route<dynamic> generateRoute(RouteSettings settings) => switch(settings.name){
  Routes.homeUser => getPageRoute(const HomeUserView()),
  Routes.splashScreen => getPageRoute(const SplashScreenView()),
  Routes.signUp => getPageRoute(const SignupView()),
  Routes.login => getPageRoute(const LoginView()),
  Routes.homeAdmin => getPageRoute(const HomeAdminView()),
  Routes.homeTv => getPageRoute(const HomeTv()),
  Routes.firstScreen => getPageRoute(const FirstScreen()),
  _ => getPageRoute(const SplashScreenView())
};

MaterialPageRoute getPageRoute(Widget viewToShow) {
  return MaterialPageRoute(builder: (context) {
    return viewToShow;
    });
}