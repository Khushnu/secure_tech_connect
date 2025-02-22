import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:securetech_connect/Widgets/aniamte_text_widget.dart';
import 'package:securetech_connect/Widgets/background_widget.dart';
import 'package:securetech_connect/Widgets/button_widget.dart';
import 'package:securetech_connect/Widgets/password_aniamte_widget.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.screenHeight,
        width: context.screenWidth,
        child: TechAiBackgroundScreen(child: Column(
          children: [
            SizedBox(height: 20,),
              TypewriterText(text: "SecureTech Connect", 
              ), 
            SizedBox(height: 50,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  controller: passwordText,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    enabledBorder: OutlineInputBorder(      
                      borderRadius: BorderRadius.circular(10), 
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))
                    ), 
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), 
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))
                    ), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), 
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))
                    )
                  ),
                ),
              ), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: AnimatedSubmitButton(onPressed: (){
                  showDialog(context: context, 
                  builder: (_)=>
                  StatefulBuilder(builder: (_, stateDialog){
                    return Dialog(
                      backgroundColor: primaryBgColor,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                      ),
                      child: Container(
                        height: context.screenHeight * 0.3 + 50,
                        width: context.screenWidth * 0.4,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: primaryBgColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10), 
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Flexible(child: EncryptionAnimation())
                          ],
                        ),
                      ),
                    );
                  })
                  );
                }),
              )
          ],
        ))
      ),
    );
  }
}