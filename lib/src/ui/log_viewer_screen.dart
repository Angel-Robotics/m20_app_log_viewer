import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m20_app_log_viewer/src/db/adapter/system_log.dart';


class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({Key? key}) : super(key: key);

  @override
  _LogViewerScreenState createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: PageView(
        children: [
          ValueListenableBuilder<Box<SystemLog>>(
            valueListenable: Hive.box<SystemLog>('log_system_box').listenable(),
            builder: (BuildContext context, value, Widget? child) {
              var systemLogs = value.values.toList().cast<SystemLog>().reversed.toList();
              // _systemLog = systemLogs;
              return ListView.separated(
                itemCount: systemLogs.length,
                separatorBuilder: (context, index) => const Divider(height: 8, color: Colors.grey),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        systemLogs[index].log ?? "-",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        systemLogs[index].datetime ?? "-",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              );
            },

          ),
        ],
      ),
    );
  }
}
