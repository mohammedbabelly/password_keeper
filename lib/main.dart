import 'package:flutter/material.dart';
import 'package:password_keeper/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Password Keeper',
    home: LoginPage(),
    theme: ThemeData.dark(),
  ));
}
