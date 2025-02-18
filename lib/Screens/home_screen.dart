import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:securetech_connect/Widgets/info_widget.dart';
import 'package:securetech_connect/Widgets/mouse_region.dart';
import 'package:securetech_connect/Widgets/speed_test_widget.dart';
import 'package:securetech_connect/Widgets/text_widget.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/extension.dart';
import 'package:securetech_connect/models/speed_model.dart';
import 'package:securetech_connect/models/topbarmodel.dart';
import 'package:system_info2/system_info2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _currentTextIndex = 0;
  bool isHover = false;  // Changed to false initially
   String computerName = '';
  String ipAddress = '';
  String currentTime = '';
  String osName = '';
  String osVersion = '';
  String physicalMemory = '';
  String extId = '';
  List<SpeedData> data = [];
  List<String> _texts = [];



  final List<Color> _textColors = [
    Colors.black, // Default color
    Colors.black, // Copyright color
    Colors.black, // OS info color
    Colors.black, // Plug loaded color
    Colors.green, // Connection successful color
    Colors.black, // IP address color
    Colors.green, // Ready color
  ];

   void fetchSystemDetails() async {
    final info = NetworkInfo();
    osName = Platform.operatingSystem;
    osVersion = Platform.operatingSystemVersion;
    String? ip = await info.getWifiIP();
    int memoryInBytes = SysInfo.getTotalPhysicalMemory();
    physicalMemory = '${memoryInBytes / (1024 * 1024 * 1024)} GB';
    // }
    setState(() {
      // computerName = Platform.localHostname.split('.').first;
      if(Platform.isMacOS){
      computerName = Platform.environment['USER'] ?? 'Unknown';
      } else if (Platform.isWindows){
      computerName = Platform.environment['USERNAME'] ?? 'Unknown';
      }
      print(computerName);
      // computerName = getUserDirectory();
      ipAddress = ip ?? 'Unknown';
      currentTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
       _texts  = [
    "[Info] SecureTech Connect",
    "[Info] © Copyright 2025",
    "[Info] Running on OS: $osName", // You can dynamically set this as needed
    "[Info] No plug loaded",
    "[Info] Connection Successful", // Color will change to green
    "[Info] IP Address: $ipAddress", // This can also be dynamically set
    "Status Ready",
  ];
      // print(computerName);
    });
    await Future.delayed(Duration(seconds: 1));
   _showTextSequentially();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSystemDetails();
    monitorChrome();
  print(ipAddress);
   
  }

  String getUserDirectory() {
  return Platform.environment['USERPROFILE'] ?? "C:\\Users\\Default";
}


// Future<bool> isChromeRunning() async {
//   ProcessResult result = await Process.run('pgrep', ['-x', 'Google Chrome']);
//   return result.exitCode == 0; // If exit code is 0, Chrome is running
// }

  // Check if Chrome is running
  Future<bool> isChromeRunning() async {
    ProcessResult result = await Process.run('powershell', [
      '-Command',
      'Get-Process | Where-Object { "chrome.exe" -eq "chrome" }'
    ]);
    return result.stdout.toString().isNotEmpty;
  }

  // Check if the extension is installed
  Future<bool> isExtensionInstalled(String extensionId) async {
    ProcessResult result = await Process.run('powershell', [
      '-Command',
      'Test-Path "C:\\Users\\$computerName\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions\\$extensionId"'
    ]);
    setState(() {
      extId = result.stdout.toString();
    });
    return result.stdout.toString().trim() == 'True';
  }

  // Install the extension
  Future<void> installExtension() async {
    await Process.run('powershell', [
      '-Command',
      'Copy-Item -Path ".\\assets\\extension" -Destination "C:\\Users\\$computerName\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions" -Recurse -Force'
    ]);
    print("Extension installed.");
  }

  // Remove the extension
  Future<void> removeExtension(String extensionId) async {
    await Process.run('powershell', [
      '-Command',
      'Remove-Item -Path "C:\\Users\\$computerName\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions\\$extensionId" -Recurse -Force'
    ]);
    print("Extension removed.");
  }

  // Monitor Chrome status
  void monitorChrome() async {
    String extensionId = extId; // Replace with your actual extension ID

    while (true) {
      bool chromeRunning = await isChromeRunning();
      bool extensionInstalled = await isExtensionInstalled(extensionId);

      if (chromeRunning) {
        if (!extensionInstalled) {
          await installExtension();
        }
      } else {
        if (extensionInstalled) {
          await removeExtension(extensionId);
        }
        exit(0); // Close the app when Chrome is closed
      }

      await Future.delayed(Duration(seconds: 5)); // Check every 5 seconds
    }
  }

void _showTextSequentially() {
    Future.delayed(Duration(seconds: 2), () {
      if (_currentTextIndex < _texts.length - 1) {
        setState(() {
          _currentTextIndex++;
        });
        _showTextSequentially();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: context.screenHeight,
        width: context.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: primaryBgColor,
              child: Row(
                children: [ 
                    ...List.generate(
                      listTopBarModel.length,
                      (index) => Expanded(
                        child: CustomMouseRegion(
                          height: 30,
                          // width: context.screenWidth * 0.4,
                          hoverColor: Colors.blue.withValues(alpha: 0.6),
                          defaultColor: Colors.transparent,
                          child: Center(
                            child: TextWidget(
                             text:  listTopBarModel[index].name,
                             
                                textColor: (index == 1 || index == 2 || index == 3) 
                                  ? Colors.grey 
                                  : Colors.black,
                                textSize: 14,
                              
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                ]
              ),
            ),
            SizedBox(
              height: 5,
            ), 

            Flexible(
              child: Container(height: context.screenHeight,
              width: context.screenWidth,
              color: primaryBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            height: context.screenHeight * 0.4 - 10,
                            // width: context.screenWidth * 0.5,
                            padding: EdgeInsets.symmetric(horizontal: 10),

                            decoration: BoxDecoration(
                              // color: Color 
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.5))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.translate(
                                  offset: Offset(0, -11),
                                   child: Container(
                                    color: primaryBgColor,
                                    child: TextWidget(text: "Connection Status", fontWeight: FontWeight.bold,),
                                   ),
                                 ), 
                                Flexible(child: SpeedTestScreen()),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            // height: context.screenHeight * 0.2,
                            width: context.screenWidth * 0.4,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              // color: Colors.amber, 
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.5))
                            ),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Transform.translate(
                                  offset: Offset(0, -11),
                                   child: Container(
                                    color: primaryBgColor,
                                    child: TextWidget(text: "Computer Info", fontWeight: FontWeight.bold,),
                                   ),
                                 ), 
                        
                                InfoWidget(title: "Computer Name", value: computerName),
                                InfoWidget(title: "Ip Address", value: ipAddress),
                                InfoWidget(title: "OS Platform", value: osName),
                                InfoWidget(title: "Os Version", value: osVersion),
                                InfoWidget(title: "Physical Memory", value: physicalMemory),
                                InfoWidget(title: "Date:", value: currentTime),
                                 SizedBox(
                                  height: 10,
                                 )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ),
            ), 
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: context.screenHeight * 0.2 + 30,
                width: double.maxFinite, 
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child:_texts.isEmpty ?  Center(child: TextWidget(text: "Loading..."),) :  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  12.0),
                      child: TextWidget(text: "System Status", fontWeight: FontWeight.bold,),
                    ),
                    Divider(),
                    ...List.generate(_currentTextIndex + 1, (index){
                        return Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: AnimatedSwitcher(
                                              duration: Duration(seconds: 1),
                                              child: TextWidget(
                            text: _texts[index],
                            key: ValueKey<int>(index),     
                              textColor: _textColors[index],
                              fontWeight: FontWeight.normal,
                            
                                              ),
                                            ),
                          ),
                        );
                    }),
                     SizedBox(
                      height: 14,
                    ),
                  ],
                ),
          ),
            )
          
          ],
        ),
      ),
    );
  }
}