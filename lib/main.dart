import 'package:flutter/material.dart';
import 'package:namer_app/backend/backend.dart';
import 'screen/main_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Item App',
      theme: ThemeData (
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        buttonTheme: ButtonThemeData(
           buttonColor: Colors.red,
           shape: RoundedRectangleBorder(),
           textTheme: ButtonTextTheme.accent,
        ), 
      ),
      home: MainPage(Backend(), http.Client()),
    );
  }
}






