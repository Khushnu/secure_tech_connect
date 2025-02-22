import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';


class EncryptionScreen extends StatefulWidget {
  @override
  _EncryptionScreenState createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  String _displayText = "Encrypting...";
  bool _isEncrypting = true;
  Random _random = Random();
  List<String> _encryptionChars = List.filled(30, "");

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
    });
  }

  void _decryptText() {
    setState(() {
      _isEncrypting = false;
      _displayText = "Decryption Successful!";
      _encryptionChars = List.filled(30, "✔");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Encryption Terminal",
            style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                childAspectRatio: 16/9
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _isEncrypting ? Colors.green.withOpacity(_random.nextDouble()) : Colors.black,
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
          Text(
            _displayText,
            style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:securetech_connect/colors.dart';
// import 'package:securetech_connect/models/speed_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'dart:async';
// import 'dart:math';

// class CircularChartData extends StatefulWidget {
//   @override
//   _SpeedTestScreenState createState() => _SpeedTestScreenState();
// }

// class _SpeedTestScreenState extends State<CircularChartData> {
//   double downloadSpeed = 0.0;
//   double uploadSpeed = 0.0;
//   bool isLoading = true;
//   late StreamSubscription _streamSubscription;
//   List<SpeedData> data = [];
//   int _time = 0;

//   @override
//   void initState() {
//     super.initState();
//     _startSpeedTestSimulation();
//   }

//   void _startSpeedTestSimulation() {
//     setState(() {
//       isLoading = true;
//     });

//     Future.delayed(Duration(seconds: 6), () {
//       setState(() {
//         isLoading = false;
//       });

//       _streamSubscription = Stream.periodic(Duration(seconds: 6), (count) {
//         setState(() {
//           downloadSpeed = Random().nextDouble() * 100;
//           uploadSpeed = Random().nextDouble() * 50;
//           data.add(SpeedData(_time++, downloadSpeed, uploadSpeed, 0));
//         });
//       }).listen((event) {});
//     });
//   }

//   @override
//   void dispose() {
//     _streamSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryBgColor,
//       body: Center(
//         child: isLoading
//             ? Lottie.asset('assets/icons/loading.json', width: 150, height: 150)
//             : Container(
//                 width: 300,
//                 height: 300,
//                 child: SfCircularChart(
//                   legend: Legend(isVisible: true),
//                   series: <CircularSeries<SpeedData, String>>[
//                     PieSeries<SpeedData, String>(
//                       dataSource: data,
//                       xValueMapper: (SpeedData speed, _) => 'Time $_time',
//                       yValueMapper: (SpeedData speed, _) => speed.downloadSpeed,
//                       name: 'Download Speed',
//                     ),
//                     PieSeries<SpeedData, String>(
//                       dataSource: data,
//                       xValueMapper: (SpeedData speed, _) => 'Time $_time',
//                       yValueMapper: (SpeedData speed, _) => speed.uploadSpeed,
//                       name: 'Upload Speed',
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
