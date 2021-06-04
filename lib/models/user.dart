class User {
  int _id;
  String _email;
  String _masterpassword;
  User(
    this._id,
    this._email,
    this._masterpassword,
  );
  int get id => _id;
  String get email => _email;
  String get masterPassword => _masterpassword;

  set email(newEmail) => _email = newEmail;
  set masterPassword(newPass) => _masterpassword = newPass;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'email': _email,
      'masterpassword': _masterpassword,
    };
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._email = map['_email'];
    this._masterpassword = map['_masterpassword'];
  }
}
