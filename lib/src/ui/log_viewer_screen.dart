import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m20_app_log_viewer/src/db/adapter/system_log.dart';

import '../db/adapter/robot_sw_log.dart';
import '../db/adapter/tablet_caller_log.dart';
import '../db/adapter/tablet_exception_log.dart';

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({Key? key}) : super(key: key);

  @override
  _LogViewerScreenState createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("엔젤렉스 M20 앱 로그"),
        ),
        body: Column(
          children: [
            const TabBar(labelColor: Colors.black, unselectedLabelColor: Colors.grey, tabs: [
              Tab(
                text: "시스템",
              ),
              Tab(
                text: "로봇로그",
              ),
              Tab(
                text: "예외",
              ),
              Tab(
                text: "Call",
              ),
            ]),
            Expanded(
              child: TabBarView(
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
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    systemLogs[index].datetime ?? "-",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    systemLogs[index].log ?? "-",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<Box<RobotSWLog>>(
                    valueListenable: Hive.box<RobotSWLog>('log_robot_box').listenable(),
                    builder: (BuildContext context, value, Widget? child) {
                      var systemLogs = value.values.toList().cast<RobotSWLog>().reversed.toList();
                      return ListView.separated(
                        separatorBuilder: (context, index)=>const Divider(),
                        itemCount: systemLogs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "$index | ${systemLogs[index].timestamp} | ${DateTime.fromMillisecondsSinceEpoch(systemLogs[index].timestamp! * 1000).toUtc()} | ${systemLogs[index].level} | ${systemLogs[index].log} | ${systemLogs[index].info0} | ${systemLogs[index].info1}"),
                          );
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<Box<TabletExceptionLog>>(
                    valueListenable: Hive.box<TabletExceptionLog>('log_exception_box').listenable(),
                    builder: (BuildContext context, value, Widget? child) {
                      var systemLogs = value.values.toList().cast<TabletExceptionLog>().reversed.toList();
                      return ListView.separated(
                        itemCount: systemLogs.length,
                        itemBuilder: (context, index) {
                          // print(systemLogs[index]);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${systemLogs[index].timestamp} (${DateTime.fromMillisecondsSinceEpoch(systemLogs[index].timestamp!)})"
                                // "\n${systemLogs[index].exception}"
                                "\n${systemLogs[index].exception!.split("|").first}"
                                "\n${systemLogs[index].exception!.split("|").last}"),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(color: Colors.black);
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<Box<TabletCallerLog>>(
                    builder: (BuildContext context, value, Widget? child) {
                      var systemLogs = value.values.toList().cast<TabletCallerLog>().reversed.toList();
                      // _systemLog = systemLogs;
                      return ListView.separated(
                        itemCount: systemLogs.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 8,
                          color: Colors.grey,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    systemLogs[index].exception ?? "-",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Text(
                                  "${DateTime.fromMillisecondsSinceEpoch(systemLogs[index].timestamp ?? 0)} (${systemLogs[index].timestamp ?? 0})",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    valueListenable: Hive.box<TabletCallerLog>('log_caller_box').listenable(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
