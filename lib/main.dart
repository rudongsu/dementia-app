import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'screen/dementia_main.dart';
import 'screen/signup.dart';
import 'qr.dart';
import 'screen/profile.dart';
import 'screen/splash_screen.dart';
import 'screen/meal.dart';
import 'screen/shopping.dart';
import 'screen/camera.dart';

Future main() async{
  runApp(new MaterialApp(
    home: new LoadingScreen(), //splash screen
    routes: <String, WidgetBuilder>{
      '/signup': (BuildContext context) =>  Signup(),
      //'/dementia': (BuildContext context) =>  patient(),
      '/QR': (BuildContext context) => qrscan(),
      '/main':  (BuildContext context) => login(),
      '/profile':  (BuildContext context) => ProfilePage(),
      '/meal': (BuildContext context) => MealPage(),
      '/shopping': (BuildContext context) => ShopItemsPage(),
      '/camera': (BuildContext context) => cameraScreen(),

      //care giver screen
    },
  )
  );
}

