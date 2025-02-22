
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class EncryptionScreen extends StatefulWidget {
  final String text;
  final bool isMatch; // ✅ Added flag for match status

  const EncryptionScreen({super.key, required this.text, required this.isMatch});

  @override
  _EncryptionScreenState createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  bool _isEncrypting = true;
  Random _random = Random();
  List<String> _encryptionChars = List.filled(30, "");

  @override
  void initState() {
    super.initState();
    _startEncryptionAnimation();
  }

  void _startEncryptionAnimation() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!_isEncrypting) {
        timer.cancel();
        return;
      }
      setState(() {
        for (int i = 0; i < _encryptionChars.length; i++) {
          _encryptionChars[i] = String.fromCharCode(_random.nextInt(94) + 33);
        }
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      _decryptText();
    });
  }

  void _decryptText() {
    setState(() {
      _isEncrypting = false;
      _encryptionChars = List.filled(30, widget.isMatch ? "✔" : "❌"); // ✅ Green ✔ or Red ❌
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog( // ✅ Changed to Dialog for Popup
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Encrypting Terminal",
              style: TextStyle(
                color: widget.isMatch ? Colors.green : Colors.red, // ✅ Match = Green, No Match = Red
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: widget.isMatch ? Colors.green : Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _isEncrypting
                          ? (widget.isMatch
                              ? Colors.green.withValues(alpha: 0.2 + _random.nextDouble() * 0.8)
                              : Colors.red.withValues(alpha: 0.2 + _random.nextDouble() * 0.8)) // ✅ Green or Red effect
                          : Colors.black,
                      border: Border.all(color: widget.isMatch ? Colors.green : Colors.red),
                    ),
                    child: Center(
                      child: Text(
                        _encryptionChars[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isEncrypting
                  ? "Encrypting..."
                  : widget.isMatch
                      ? "Decryption Successful! File Authorized"
                      : "No Match Found!", // ✅ Text changes based on match status
              style: TextStyle(
                color: widget.isMatch ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (!_isEncrypting)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
          ],
        ),
      ),
    );
  }
}