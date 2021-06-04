import 'package:encrypt/encrypt.dart';

var iv = IV.fromLength(16);

class AppEncrypter {
  String encrypt(String text, String email) {
    final key = Key.fromUtf8(List.filled(32, email).join().substring(0, 32));

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);

    print(encrypted.base64);
    return encrypted.base64;
  }

  String decrypt(String text, String email) {
    final key = Key.fromUtf8(List.filled(32, email).join().substring(0, 32));

    final encrypter = Encrypter(AES(key));
    var decrypted = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);

    print(decrypted);
    return decrypted;
  }
}
