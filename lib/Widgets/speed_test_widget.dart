import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securetech_connect/Widgets/text_widget.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/models/speed_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';  // For periodic updates
import 'dart:math';   // For generating random numbers

class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  List<SpeedData> data = [];  // List to store speed data
  bool isLoading = true;  // State to manage loading animation visibility
  int _time = 0;
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _startSpeedTestSimulation();
  }

  // Simulate speed test by generating random speeds
  void _startSpeedTestSimulation() {
    setState(() {
      isLoading = true;
    });

    // Start a 4-second delay before adding data to the graph
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        isLoading = false;  // Stop the loading animation
      });

      // Use a Stream to simulate continuous updates
      _streamSubscription = Stream.periodic(Duration(seconds: 6), (count) {
        // Generate random download and upload speeds between 10 to 100 Mbps
        downloadSpeed = Random().nextDouble() * 50;  // Random value between 0 and 100
        uploadSpeed = Random().nextDouble() * 20;    // Random value between 0 and 100

        setState(() {
          data.add(SpeedData(_time++, downloadSpeed, uploadSpeed));  // Add new data point
        });
      }).listen((event) {
        // The event is triggered every 2 seconds with a new data point
      });
    });
  }

  @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBgColor,
      body: Column(
        children: [
          // Show loading animation while fetching data
          if (isLoading)
            Expanded(
              child: Center(
                child: Lottie.asset('assets/icons/loading.json', width: 150, height: 150),
              ),
            )
          else
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  title: AxisTitle(text: 'Time (seconds)'),
                  interval: 1,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Speed (Mbps)'),
                ),
                series: <CartesianSeries>[
                  LineSeries<SpeedData, int>(
                    name: 'Download Speed',
                    dataSource: data,
                    xValueMapper: (SpeedData speed, _) => speed.time,
                    yValueMapper: (SpeedData speed, _) => speed.downloadSpeed,
                    markerSettings: MarkerSettings(isVisible: true),
                  ),
                  LineSeries<SpeedData, int>(
                    name: 'Upload Speed',
                    dataSource: data,
                    xValueMapper: (SpeedData speed, _) => speed.time,
                    yValueMapper: (SpeedData speed, _) => speed.uploadSpeed,
                    markerSettings: MarkerSettings(isVisible: true),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
