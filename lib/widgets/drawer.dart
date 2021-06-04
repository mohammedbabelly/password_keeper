import 'package:flutter/material.dart';
import 'package:password_keeper/models/user.dart';

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
            title: Text('Item 1'),
            onTap: () {},
          ),
        ],
      ),
    );
    ;
  }
}
