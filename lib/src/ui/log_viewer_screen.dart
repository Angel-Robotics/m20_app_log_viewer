import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m20_app_log_viewer/src/controller/system_log_text_controller.dart';
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
    final systemLogTextController = Get.put(SystemLogTextController());
    final callerLogTextController = Get.put(CallerLogTextController());
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
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: TextField(
                                  controller: systemLogTextController.textEditingController,
                                  decoration: const InputDecoration(
                                    hintText: "Search",
                                    border: InputBorder.none,
                                    icon: Icon(Icons.search),
                                  ),
                                  onSubmitted: (result) {
                                    // print(result);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  DateTime? dt = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime.now(),
                                  );
                                  systemLogTextController.searchDateTime = dt;
                                  setState(() {});
                                },
                                child: const Text("날짜선택")),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  systemLogTextController.searchDateTime = null;
                                  systemLogTextController.textEditingController.clear();
                                  setState(() {});
                                },
                                child: const Text("초기화"))
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ValueListenableBuilder<Box<SystemLog>>(
                            valueListenable: Hive.box<SystemLog>('log_system_box').listenable(),
                            builder: (BuildContext context, value, Widget? child) {
                              var systemLogs = value.values.toList().cast<SystemLog>().reversed.toList();
                              // _systemLog = systemLogs;
                              if (systemLogTextController.textEditingController.text.isNotEmpty) {
                                systemLogs = systemLogs
                                    .where((element) => (element.log?.toUpperCase() ?? "").contains(
                                        systemLogTextController.textEditingController.text.trim().toUpperCase()))
                                    .toList();
                              }
                              if (systemLogTextController.searchDateTime != null) {
                                systemLogs = systemLogs
                                    .where((element) => (element.datetime?.split(" ").first.toUpperCase() ?? "")
                                        .contains(systemLogTextController.searchDateTime
                                            .toString()
                                            .split(" ")
                                            .first
                                            .toUpperCase()))
                                    .toList();
                              }

                              return ListView.separated(
                                itemCount: systemLogs.length,
                                controller: ScrollController(),
                                separatorBuilder: (context, index) => const Divider(height: 8, color: Colors.grey),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SelectableText(
                                            systemLogs[index].datetime ?? "-",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: SelectableText(
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<Box<RobotSWLog>>(
                      valueListenable: Hive.box<RobotSWLog>('log_robot_box').listenable(),
                      builder: (BuildContext context, value, Widget? child) {
                        var systemLogs = value.values.toList().cast<RobotSWLog>().reversed.toList();
                        return ListView.separated(
                          controller: ScrollController(),
                          separatorBuilder: (context, index) => const Divider(),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<Box<TabletExceptionLog>>(
                      valueListenable: Hive.box<TabletExceptionLog>('log_exception_box').listenable(),
                      builder: (BuildContext context, value, Widget? child) {
                        var systemLogs = value.values.toList().cast<TabletExceptionLog>().reversed.toList();
                        return ListView.separated(
                          controller: ScrollController(),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: TextField(
                                  controller: callerLogTextController.textEditingController,
                                  decoration: const InputDecoration(
                                    hintText: "Search",
                                    border: InputBorder.none,
                                    icon: Icon(Icons.search),
                                  ),
                                  onSubmitted: (result) {
                                    // print(result);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  DateTime? dt = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime.now(),
                                  );
                                  callerLogTextController.searchDateTime = dt;
                                  setState(() {});
                                },
                                child: const Text("날짜선택")),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  callerLogTextController.searchDateTime = null;
                                  callerLogTextController.textEditingController.clear();
                                  setState(() {});
                                },
                                child: const Text("초기화"))
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ValueListenableBuilder<Box<TabletCallerLog>>(
                            valueListenable: Hive.box<TabletCallerLog>('log_caller_box').listenable(),
                            builder: (BuildContext context, value, Widget? child) {
                              var systemLogs = value.values.toList().cast<TabletCallerLog>().reversed.toList();
                              // _systemLog = systemLogs;

                              if (callerLogTextController.textEditingController.text.isNotEmpty) {
                                systemLogs = systemLogs
                                    .where((element) => (element.exception?.toUpperCase() ?? "").contains(
                                    callerLogTextController.textEditingController.text.trim().toUpperCase()))
                                    .toList();
                              }
                              if (callerLogTextController.searchDateTime != null) {
                                systemLogs = systemLogs
                                    .where((element) => (DateTime.fromMillisecondsSinceEpoch(element.timestamp ?? 0).toString().split(" ").first.toUpperCase() )
                                    .contains(callerLogTextController.searchDateTime
                                    .toString()
                                    .split(" ")
                                    .first
                                    .toUpperCase()))
                                    .toList();
                              }
                              return ListView.separated(
                                controller: ScrollController(),
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
                                          child: SelectableText(
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
                          ),
                        ),
                      ],
                    ),
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
