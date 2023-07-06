import 'package:flutter/material.dart';
import 'package:wordpress1/uiView/home.dart';
import 'globals.dart' as globals;


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  globals.appNavigator = GlobalKey<NavigatorState>();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: globals.appNavigator,
      home: Home(),
    );
  }
}
