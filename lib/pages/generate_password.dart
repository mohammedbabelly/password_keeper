import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_password_generator/random_password_generator.dart';

class GeneratePasswordPage extends StatefulWidget {
  @override
  _GeneratePasswordPageState createState() => _GeneratePasswordPageState();
}

class _GeneratePasswordPageState extends State<GeneratePasswordPage> {
  bool _isWithLetters = true;
  bool _isWithUppercase = false;
  bool _isWithNumbers = false;
  bool _isWithSpecial = false;
  double _numberCharPassword = 8;
  String newPassword = '';
  Color _color = Colors.blue;
  String isOk = '';
  TextEditingController _passwordLength = TextEditingController();
  double _length = 0;
  final password = RandomPasswordGenerator();
  @override
  void initState() {
    super.initState();
  }

  checkBox(String name, Function onTap, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(name),
        Checkbox(value: value, onChanged: onTap),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Password Generator')),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              checkBox('Upper Case', (bool value) {
                _isWithUppercase = value;
                setState(() {});
              }, _isWithUppercase),
              checkBox('Lower Case', (bool value) {
                _isWithLetters = value;
                setState(() {});
              }, _isWithLetters)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              checkBox('Symbols', (bool value) {
                _isWithSpecial = value;
                setState(() {});
              }, _isWithSpecial),
              checkBox('Numbers', (bool value) {
                _isWithNumbers = value;
                setState(() {});
              }, _isWithNumbers)
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Slider(
            value: _length,
            min: 0,
            max: 50,
            divisions: 50,
            label: _length.round().toString(),
            onChanged: (double value) {
              _length = value;
              newPassword = password.randomPassword(
                  letters: _isWithLetters,
                  numbers: _isWithNumbers,
                  passwordLength: _length,
                  specialChar: _isWithSpecial,
                  uppercase: _isWithUppercase);
              double passwordstrength =
                  password.checkPassword(password: newPassword);
              if (passwordstrength < 0.3) {
                _color = Colors.red;
                isOk = 'This password is weak!';
              } else if (passwordstrength < 0.7) {
                _color = Colors.blue;
                isOk = 'This password is Good';
              } else {
                _color = Colors.green;
                isOk = 'This passsword is Strong';
              }

              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          if (newPassword.isNotEmpty && newPassword != null)
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                    leading: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () async => await Clipboard.setData(
                                ClipboardData(text: newPassword))
                            .whenComplete(
                                () => _showSnackBar(context, "Copied", true))),
                    title: Text(
                      newPassword,
                      style: TextStyle(color: _color, fontSize: 25),
                    )),
              ),
            ))
        ],
      )),
      bottomNavigationBar: Container(
        height: 30,
        child: Center(child: Text(isOk, style: TextStyle(color: _color))),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String theMessage, bool succsess) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 1),
        content: ListTile(
            title: Text(theMessage),
            leading: succsess
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.close, color: Colors.red)),
        backgroundColor: Color(0xff222222));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
