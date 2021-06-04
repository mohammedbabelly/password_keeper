import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:password_keeper/pages/login_page.dart';

void main() async {
  await GetStorage.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Password Keeper',
    home: LoginPage(),
    theme: ThemeData.dark(),
  ));
}
