import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:password_keeper/models/user.dart';
import 'package:password_keeper/pages/generate_password.dart';
import 'package:password_keeper/pages/login_page.dart';

class AppDrawer extends StatelessWidget {
  final User user;
  AppDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(),
            child:
                Center(child: Text(user.email, style: TextStyle(fontSize: 20))),
          ),
          ListTile(
            title: Text('Generate Password'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => GeneratePasswordPage())),
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              GetStorage box = GetStorage();
              box.erase();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
    ;
  }
}
