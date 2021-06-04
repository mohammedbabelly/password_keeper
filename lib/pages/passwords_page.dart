import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:password_keeper/helpers/database_helper.dart';
import 'package:password_keeper/models/password.dart';
import 'package:password_keeper/models/user.dart';
import 'package:password_keeper/widgets/drawer.dart';

import 'generate_password.dart';

class PasswordsPage extends StatefulWidget {
  final User curUser;
  PasswordsPage(this.curUser);
  @override
  _PasswordsPageState createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  DatabaseHelper _databaseHelper;
  TextEditingController titleController;
  TextEditingController passwordController;
  TextEditingController emailController;
  TextEditingController noteController;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _databaseHelper = new DatabaseHelper();
    _databaseHelper.initializeDatabase();
    titleController = new TextEditingController();
    passwordController = new TextEditingController();
    emailController = new TextEditingController();
    noteController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Passwords'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.pending_actions_sharp),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => GeneratePasswordPage())))
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async => await _showBottomSheet("Add a new password"),
          child: Icon(Icons.add)),
      drawer: AppDrawer(widget.curUser),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefs,
        child: FutureBuilder(
            future: _getPasswordsFromDb(),
            builder: (BuildContext context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                      ? Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : snapshot.data.isNotEmpty
                          ? ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildNoteCard(snapshot.data[index]);
                              },
                            )
                          : Center(
                              child: Text(
                                'Tap + to add a new password',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
            }));
  }

  Widget _buildNoteCard(Password object) => Card(
        elevation: 2.0,
        child: ListTile(
          leading: IconButton(
              icon: Icon(Icons.copy),
              onPressed: () async => await Clipboard.setData(
                      ClipboardData(text: object.password))
                  .whenComplete(() => _showSnackBar(context, "Copied", true))),
          title: Text(object.title),
          subtitle: Text(object.email),
          trailing: InkWell(
              child: Icon(Icons.delete, color: Colors.red),
              onTap: () async => await _deletePassword(context, object.id)),
          onTap: () async => _showBottomSheet("${object.title}", object),
        ),
      );

  Widget _buildTextField(TextEditingController controller, String label,
          {bool copy = false}) =>
      Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: TextField(
          controller: controller,
          cursorColor: Colors.white60,
          decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              suffixIcon: copy
                  ? IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(
                                ClipboardData(text: controller.text))
                            .whenComplete(
                                () => _showSnackBar(context, "Copied", true));
                      },
                    )
                  : Icon(Icons.add, color: Colors.black)),
        ),
      );

  void _showSnackBar(BuildContext context, String theMessage, bool succsess) {
    final snackBar = SnackBar(
        content: ListTile(
            title: Text(theMessage),
            leading: succsess
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.close, color: Colors.red)),
        backgroundColor: Color(0xff222222));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _showBottomSheet(String title, [Password password]) async {
    if (password != null) {
      print('update case');
      titleController.value =
          titleController.value.copyWith(text: password.title);
      passwordController.value =
          passwordController.value.copyWith(text: password.password);
      emailController.value =
          emailController.value.copyWith(text: password.email);
      noteController.value = noteController.value.copyWith(text: password.note);
    } else {
      titleController.clear();
      emailController.clear();
      passwordController.clear();
      noteController.clear();
    }
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.75,
              minChildSize: 0.75,
              expand: true,
              builder: (context, scrollController) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(title),
                        ),
                        _buildTextField(titleController, 'Title'),
                        _buildTextField(passwordController, 'Password',
                            copy: true),
                        _buildTextField(emailController, 'Email or Username'),
                        _buildTextField(noteController, 'Any Notes'),
                        TextButton.icon(
                            onPressed: () => _savePassword(password == null
                                ? Password(
                                    widget.curUser.id,
                                    titleController.text,
                                    passwordController.text,
                                    emailController.text,
                                    DateFormat.yMMMd().format(DateTime.now()))
                                : Password.withId(
                                    password.id,
                                    widget.curUser.id,
                                    titleController.text,
                                    passwordController.text,
                                    emailController.text,
                                    DateFormat.yMMMd().format(DateTime.now()),
                                    noteController.text,
                                  )),
                            icon: Icon(Icons.check),
                            label: Text(password == null ? "Save" : "Update"))
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Future<Null> onRefs() async => setState(() {});

  Future<List<Password>> _getPasswordsFromDb() async =>
      await _databaseHelper.getAllPassword();

  Future<void> _deletePassword(BuildContext context, int id) async {
    int result = await _databaseHelper.deletePassword(id);
    if (result != 0)
      setState(() {
        _showSnackBar(context, "Password deleted successfuly", true);
      });
    else
      _showSnackBar(context, "Could't delete!", false);
  }

  Future<void> _savePassword(Password _object) async {
    if ((_object.title.isEmpty ||
        _object.password.isEmpty ||
        _object.email.isEmpty)) {
      print('somthing is empty');
      print('title = ${_object.title}');
      print('password = ${_object.password}');
      print('email = ${_object.email}');
      return;
    }

    int result = _object.id != null
        ? await _databaseHelper.updatePassword(_object)
        : await _databaseHelper.createPassword(_object);

    if (result >= 0) {
      Navigator.pop(context, true);
      _showSnackBar(context, '${_object.title} password saved', true);
      setState(() {});
    } else {
      Navigator.pop(context, false);
      _showSnackBar(context, 'Error saving password!', false);
    }
  }
}
