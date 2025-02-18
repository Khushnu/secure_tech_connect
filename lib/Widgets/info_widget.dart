import 'package:flutter/material.dart';
import 'package:securetech_connect/Widgets/text_widget.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final String value;
  const InfoWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Container(
                              //  height: 30,
                              //  width: context.screenWidth * 0.3,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withValues(alpha: 0.7),
                                boxShadow: [
                                  BoxShadow(color: Colors.white, blurRadius: 10)
                                ]
                              ),
                               child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextWidget(text: title, textSize: 14, fontWeight: FontWeight.bold,),
                                  TextWidget(text: value , textSize: 12,),
                                ],
                               ),
                             );
  }
}