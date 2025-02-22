
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:securetech_connect/Screens/home_screen.dart';
import 'package:securetech_connect/Widgets/aniamte_text_widget.dart';

class EncryptionAnimation extends StatefulWidget {
  const EncryptionAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EncryptionAnimationState createState() => _EncryptionAnimationState();
}

class _EncryptionAnimationState extends State<EncryptionAnimation> {
  String _displayText = "Authenticating...";
  bool _isEncrypting = true;
  final Random _random = Random();
  List<String> _encryptionChars = List.filled(48, "");

  @override
  void initState() {
    super.initState();
    _startEncryptionAnimation();
  }

  void _startEncryptionAnimation() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
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

    Future.delayed(Duration(seconds: 5), () {
      _decryptText();
      Future.delayed(Duration(milliseconds: 1300)).then((v){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
      });
    });
  }

  void _decryptText() {
    setState(() {
      _isEncrypting = false;
      _displayText = "You're Authorized!";
      _encryptionChars = List.filled(48, "✔");
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 16 / 9,
              ),
              itemCount: 48,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _isEncrypting ? Colors.green.withValues(alpha: _random.nextDouble()) : Colors.greenAccent,
                    border: Border.all(color: Colors.green),
                  ),
                  child: Center(
                    child: Text(
                      _encryptionChars[index],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          TypewriterText(
           text: _displayText,
          color: Colors.green, size: 18,
          ),
        ],
    
    );
  }
}