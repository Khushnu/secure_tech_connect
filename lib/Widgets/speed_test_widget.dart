import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securetech_connect/Widgets/text_widget.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/extension.dart';
import 'package:securetech_connect/models/speed_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';  // For periodic updates
import 'dart:math';   // For generating random numbers

class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  List<SpeedData> data = [];
  bool isLoading = true;
  int _time = 0;
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;
  double loss = 0.0;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _startSpeedTestSimulation();
  }

  void _startSpeedTestSimulation() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        isLoading = false;
      });

      _streamSubscription = Stream.periodic(Duration(seconds: 6), (count) {
        downloadSpeed = Random().nextDouble() * 50;
        uploadSpeed = Random().nextDouble() * 20;
        loss = Random().nextDouble() * 5; // Random packet loss value

        setState(() {
          data.add(SpeedData(_time++, downloadSpeed, uploadSpeed, loss));
        });
      }).listen((event) {});
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
     
     Column(
        children: [
          if (isLoading)
            Expanded(
              child: Center(
                child: Lottie.asset('assets/icons/loading.json', width: context.screenWidth * 0.3, height: context.screenHeight * 0.3),
              ),
            )
          else
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),  // Adjusted padding for responsiveness
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(child: _buildSpeedLabel("Download", downloadSpeed, Colors.blue)),
                      Flexible(child: _buildSpeedLabel("Upload", uploadSpeed, Colors.green)),
                      Flexible(child: _buildSpeedLabel("Loss", loss, Colors.red)),
                    ],
                  ),
                ),
                SizedBox(
                    height: context.screenHeight * 0.3,
                    width: context.screenWidth,
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(
                      title: AxisTitle(text: 'Time (seconds)', textStyle: TextStyle(fontSize: 10)),
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Speed (Mbps)', textStyle: TextStyle(fontSize: 10)),
                    ),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      textStyle: TextStyle(fontSize: 10),
                    ),
                    series: <CartesianSeries>[
                      LineSeries<SpeedData, int>(
                        name: 'Download (${downloadSpeed.toStringAsFixed(2)} Mbps)',
                        dataSource: data,
                        xValueMapper: (SpeedData speed, _) => speed.time,
                        yValueMapper: (SpeedData speed, _) => speed.downloadSpeed,
                        markerSettings: MarkerSettings(isVisible: true),
                        color: Colors.blue,
                      ),
                      LineSeries<SpeedData, int>(
                        name: 'Upload (${uploadSpeed.toStringAsFixed(2)} Mbps)',
                        dataSource: data,
                        xValueMapper: (SpeedData speed, _) => speed.time,
                        yValueMapper: (SpeedData speed, _) => speed.uploadSpeed,
                        markerSettings: MarkerSettings(isVisible: true),
                        color: Colors.green,
                      ),
                      LineSeries<SpeedData, int>(
                        name: 'Loss (${loss.toStringAsFixed(2)}%)',
                        dataSource: data,
                        xValueMapper: (SpeedData speed, _) => speed.time,
                        yValueMapper: (SpeedData speed, _) => speed.lossPakcet,
                        markerSettings: MarkerSettings(isVisible: true),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
     
         );
  }

  Widget _buildSpeedLabel(String label, double value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,  // Ensure minimal space usage
      children: [
        TextWidget(
          text: label,
          textSize: context.screenWidth < 850 ? 8 : 10,  // Adjust text size based on screen width
          fontWeight: FontWeight.bold,
          textColor: Colors.black,
        ),
        SizedBox(height: context.screenHeight * 0.01),  // Adjusted space between texts
        TextWidget(
          text: '${value.toStringAsFixed(2)} Mbps',
          textSize: context.screenWidth < 850 ? 8 : 10,  // Adjust text size based on screen width
          textColor: color,
        ),
      ],
    );
  }
}
