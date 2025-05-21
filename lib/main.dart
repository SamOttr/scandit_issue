import 'package:flutter/material.dart';
import 'package:scandit_issue/scandit/scandit_page.dart';
import 'package:scandit_issue/scandit/services/scandit_service.dart';
import 'package:scandit_issue/scandit/utils/scandit_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final scanditConfig = ScanditConfig(scanditkey: "SCANDIT_KEY");
  final scanditService = await ScanditService.init(scanditConfig);
  runApp(MyApp(scanditService: scanditService));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.scanditService});

  final ScanditService scanditService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(scanditService: scanditService),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.scanditService});

  final ScanditService scanditService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ScanditPage(
                      scanditService: widget.scanditService,
                    ),
              ),
            );
          },
          child: Text("Launch Scandit"),
        ),
      ),
    );
  }
}
