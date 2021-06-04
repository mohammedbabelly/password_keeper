class Password {
  int _id;
  int _userId;
  String _title;
  String _password;
  String _email;
  String _note;
  String _date;

  Password(this._userId, this._title, this._password, this._email, this._date,
      [this._note]);

  Password.withId(this._id, this._userId, this._title, this._password,
      this._email, this._date,
      [this._note]);

  int get id => _id;
  int get userId => _userId;
  String get title => _title;
  String get password => _password;
  String get email => _email;
  String get note => _note;
  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set password(String newPassword) {
    this._password = newPassword;
  }

  set email(String newEmail) {
    this._email = newEmail;
  }

  set note(String newnote) {
    this._note = newnote;
  }

  set userId(int newuserId) {
    if (newuserId >= 1 && newuserId <= 2) {
      this._userId = newuserId;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['note'] = _note;
    map['title'] = _title;
    map['user_id'] = _userId;
    map['date'] = _date;
    map['email'] = _email;
    map['password'] = _password;

    return map;
  }

  // Extract a Note object from a Map object
  Password.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._note = map['note'];
    this._title = map['title'];
    this._userId = map['user_id'];
    this._date = map['date'];
    this._email = map['email'];
    this._password = map['password'];
  }
}
