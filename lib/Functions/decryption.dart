import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt; 
 
 String decryptPassword(String encryptedPassword) {
  final encrypt.Key key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars key
  final encrypt.IV iv = encrypt.IV.fromUtf8('1234567890123456'); // 16 chars IV

    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final encryptedBytes = base64Decode(encryptedPassword);
      final encrypted = encrypt.Encrypted(encryptedBytes);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return "Failed to decrypt: $e";
    }
  }