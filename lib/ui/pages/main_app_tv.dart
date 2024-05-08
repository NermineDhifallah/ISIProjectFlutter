import 'package:flutter/material.dart';
import 'package:isi_project/core/consts/routes.dart';

import '../../routerTv.dart';

class MainAppTv extends StatelessWidget {
  const MainAppTv({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISI Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      initialRoute: Routes.homeTv,
    );
  }
}
