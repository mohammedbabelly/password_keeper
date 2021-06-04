class User {
  int _id;
  String _email;
  String _masterpassword;
  User(
    this._email,
    this._masterpassword,
  );
  User.withId(
    this._id,
    this._email,
    this._masterpassword,
  );
  int get id => _id;
  String get email => _email;
  String get masterPassword => _masterpassword;

  set setId(newId) => _id = newId;
  set setEmail(newEmail) => _email = newEmail;
  set setMasterPassword(newPass) => _masterpassword = newPass;

  Map<String, dynamic> toMap() {
    return {
      'email': _email,
      'master_password': _masterpassword,
    };
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'] ?? 0;
    this._email = map['email'];
    this._masterpassword = map['master_password'];
  }
}
