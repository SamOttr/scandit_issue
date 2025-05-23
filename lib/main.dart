import 'package:flutter/material.dart';
import 'package:scandit_issue/scandit/scandit_page.dart';
import 'package:scandit_issue/scandit/services/scandit_service.dart';
import 'package:scandit_issue/scandit/utils/scandit_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final scanditConfig = ScanditConfig(scanditkey: "ARZzhi+WCfh6BEpNYESU6DoVGhNvGNq9a0wdJER5oN1uWHlR/x3Kg1518I9sEJp2nU9+pKAtJ1QEGN0djm9KQ51K0/4hbqZiq2urTyRr/6HaefPwQmTy0F5GmOQUWOpseUiArTN8Jj0tVo+jUnJV1Lk3eYZcOixW7yevGqsXW1I3s5oSpTvXncciv0jhngpCn5uVeWjgWPeWjkm0V3Wr1M2Lewb7MuDYdSHgDBZ3q/awvb1BH1QouQKjb+PyRDevZpXjDA//sZsPagcF+3eLGUghlvAPclZL7/Q6dGYXabBUNhKEmtBikNc9go05jQqFeFk1qTDlWZzXjpyO7qlW4MVoQyDL7Ks/Lqiq22bkgGtA0IuuaRMmps1A2WoXVeLNXDGtLgMNqgIAgVUkW4bZyF4QGMA4YVNpf2xmVHOH1VOecKaNb2WE0OsFMgtyYUrdEbBtbYfB+0TQuqJ/0ZBI4XzB8E681zWeoqE3pI83FlFZNMPgz2VVZXi8Mix4tsnmKB5UFiy/iAvqznoqIHwUe7gA0tWQl1LLqGwo2j1cRvz9G9K1O6BMoVB5YsEaGJd0M3jZUs3xzQa/2Sz8hYAQwWUUel5Ftj/AdzI+8mTG4baDRumNkfK7HR14Zn/RBMr6E5Ei943ZuAHVj6HwIK/wMqKr78fvF9EQ+GpRWhsUWozTus9xoTsFqqHsYw5n4R7czD8lIZ/QFAcopNPUB0Roc2EkogMf8bgXMxQhz2BxOTBARU9JNpBh8vOCpH5I9CsfvW6LBrizg/oj9mCB6UCNhi+goqwUeqtsvg/nijPtW57u2fPdNtNDhSfjseQPAgJE5lT8gidJ2SCeWAISOyLy");
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
