
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:securetech_connect/Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Size size = await DesktopWindow.getWindowSize();
  const Size desiredSize = Size(1300, 1000);
  // print(size);
  await DesktopWindow.setWindowSize(desiredSize);
await DesktopWindow.setFullScreen(false);
    await DesktopWindow.setMinWindowSize(desiredSize);
    await DesktopWindow.setMaxWindowSize(desiredSize);
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL',
  //   anonKey: 'YOUR_SUPABASE_ANON_KEY',
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String computerName = '';
//   String ipAddress = '';
//   String currentTime = '';
//   String apiValue = 'Fetching...';
//   bool isActivated = false;
//   final SupabaseClient supabase = Supabase.instance.client;
//   final String activationFilePath = 'C:/SecureTech/activation.techkey';
  
//   @override
//   void initState() {
//     super.initState();
//     fetchSystemDetails();
//     fetchAPIValue();
//     checkAuthStatus();
//     checkActivationFile();
//     monitorChromeProcess();
//   }
  
    // final info = NetworkInfoPlus();
    // final info = NetworkInfo();
//     String? ip = await info.getWifiIP();
//     setState(() {
//       computerName = Platform.localeName;
//       ipAddress = ip ?? 'Unknown';
//       currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
//     });
//   }
  
//   void fetchAPIValue() async {
//     try {
//       final data = await supabase.from('your_table_name').select('your_column_name').single();
//       setState(() {
//         apiValue = data['your_column_name'].toString();
//       });
//     } catch (e) {
//       setState(() {
//         apiValue = 'No Data';
//       });
//     }
//   }

//   void checkAuthStatus() async {
//     final session = supabase.auth.currentSession;
//     if (session == null) {
//       // await supabase.auth.signInWithOAuth(Provider.google);
//     }
//   }
  
//   void checkActivationFile() {
//     setState(() {
//       isActivated = File(activationFilePath).existsSync();
//     });
//   }
  
 
  
//   void installChromeExtension() async {
//     await Process.run('powershell', [
//       '-ExecutionPolicy', 'Bypass', '-File', 'C:/SecureTech/install_extension.ps1'
//     ]);
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Techy EXE UI')),
//         body: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Computer Name: $computerName'),
//               Text('IP Address: $ipAddress'),
//               Text('Current Time: $currentTime'),
//               SizedBox(height: 20),
//               Text('API Value: $apiValue'),
//               SizedBox(height: 20),
//               Text(isActivated ? 'Activated' : 'Activation Required',
//                style: TextStyle(color: isActivated ? Colors.green : Colors.red)),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: checkActivationFile,
//                 child: Text('Check Activation File'),
//               ),
//               ElevatedButton(
//                 onPressed: isActivated ? installChromeExtension : null,
//                 child: Text('Initiate Connection'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
