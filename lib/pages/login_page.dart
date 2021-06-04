import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:password_keeper/helpers/database_helper.dart';
import 'package:password_keeper/models/user.dart';

import 'passwords_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => Duration(milliseconds: 2250);

  DatabaseHelper _databaseHelper;

  User user;

  GetStorage box = GetStorage();
  @override
  void initState() {
    super.initState();
    _databaseHelper = new DatabaseHelper();
    _databaseHelper.initializeDatabase();
  }

  Future<String> _login(LoginData data) async {
    try {
      user = await _databaseHelper.getUser(data.name, data.password);
      return user != null ? null : "Invalid email or password!";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String> _signUp(LoginData data) async {
    try {
      user = User(data.name, data.password);
      var id = await _databaseHelper.createUser(user);
      if (id != null) {
        user.setId = id;
        box.write('user', user.toMap());
      }
      return id != null ? null : "Error creating a new user!";
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Password Keeper',
      // logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _login,
      onSignup: _signUp,
      hideForgotPasswordButton: true,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: Icons.fingerprint,
          callback: () async {
            print('start google sign in');
            await Future.delayed(loginTime);
            print('stop google sign in');
            return "null";
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PasswordsPage(user),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
