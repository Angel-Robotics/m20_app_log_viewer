import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/db/adapter/robot_sw_log.dart';
import 'src/db/adapter/system_log.dart';
import 'src/db/adapter/tablet_caller_log.dart';
import 'src/db/adapter/tablet_exception_log.dart';
import 'src/ui/file_loader_screen.dart';

Future<void> restoreHiveBox<T>(String boxName, String backupPath) async {
  final box = await Hive.openBox<T>(boxName);
  final boxPath = box.path;
  await box.close();

  try {
    await File(backupPath).copy(boxPath!);
  } finally {
    await Hive.openBox<T>(boxName);
  }
}

void main() {
  Hive.initFlutter().then((value) {
    Hive.registerAdapter(SystemLogAdapter());
    Hive.registerAdapter(TabletExceptionLogAdapter());
    Hive.registerAdapter(RobotSWLogAdapter());
    Hive.registerAdapter(TabletCallerLogAdapter());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'M20 App Log Viewer',
      debugShowCheckedModeBanner: false,
      home: FileLoaderScreen()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
