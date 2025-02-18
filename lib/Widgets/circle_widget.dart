import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/models/speed_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math';

class CircularChartData extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<CircularChartData> {
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;
  bool isLoading = true;
  late StreamSubscription _streamSubscription;
  List<SpeedData> data = [];
  int _time = 0;

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
        setState(() {
          downloadSpeed = Random().nextDouble() * 100;
          uploadSpeed = Random().nextDouble() * 50;
          data.add(SpeedData(_time++, downloadSpeed, uploadSpeed, 0));
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
    return Scaffold(
      backgroundColor: primaryBgColor,
      body: Center(
        child: isLoading
            ? Lottie.asset('assets/icons/loading.json', width: 150, height: 150)
            : Container(
                width: 300,
                height: 300,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries<SpeedData, String>>[
                    PieSeries<SpeedData, String>(
                      dataSource: data,
                      xValueMapper: (SpeedData speed, _) => 'Time $_time',
                      yValueMapper: (SpeedData speed, _) => speed.downloadSpeed,
                      name: 'Download Speed',
                    ),
                    PieSeries<SpeedData, String>(
                      dataSource: data,
                      xValueMapper: (SpeedData speed, _) => 'Time $_time',
                      yValueMapper: (SpeedData speed, _) => speed.uploadSpeed,
                      name: 'Upload Speed',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
