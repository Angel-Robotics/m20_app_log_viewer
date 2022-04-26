import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m20_app_log_viewer/main.dart';
import 'package:m20_app_log_viewer/src/db/adapter/robot_sw_log.dart';
import 'package:m20_app_log_viewer/src/db/adapter/system_log.dart';
import 'package:m20_app_log_viewer/src/db/adapter/tablet_caller_log.dart';
import 'package:m20_app_log_viewer/src/db/adapter/tablet_exception_log.dart';
import 'package:m20_app_log_viewer/src/ui/log_viewer_screen.dart';
import 'package:path_provider/path_provider.dart';

class FileLoaderScreen extends StatefulWidget {
  const FileLoaderScreen({Key? key}) : super(key: key);

  @override
  _FileLoaderScreenState createState() => _FileLoaderScreenState();
}

class _FileLoaderScreenState extends State<FileLoaderScreen> {
  String loadingProcessText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M20 App Log Viewer"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ElevatedButton(
          //   onPressed: () async {
          //     print(await getDownloadsDirectory());
          //     // print(await getExternalStorageDirectory());
          //     print(await getTemporaryDirectory());
          //     print(await getLibraryDirectory());
          //     print(await getApplicationDocumentsDirectory());
          //     print(await getApplicationSupportDirectory());
          //   },
          //   child: const Text("데스크톱 패스 확인"),
          // ),
          // const SizedBox(
          //   height: 24,
          // ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Center(child: Text("시스템로그 읽기")),
                  ),
                )

              ],
            ),
          )),
          Divider(),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path ?? "");
                    print(file);

                    final bytes = file.readAsBytesSync();

                    // Decode the Zip file
                    final archive = ZipDecoder().decodeBytes(bytes);

                    // Extract the contents of the Zip archive to disk.
                    var d = await getDownloadsDirectory();
                    List<File> fileItems = [];
                    for (final file in archive) {
                      final filename = file.name;
                      fileItems.add(File('${d!.path}/' + filename));
                      if (file.isFile) {
                        final data = file.content as List<int>;

                        File('${d.path}/' + filename)
                          ..createSync(recursive: true)
                          ..writeAsBytesSync(data);
                      } else {
                        Directory('${d.path}/' + filename).create(recursive: true);
                      }
                    }

                    setState(() {
                      loadingProcessText = "";
                    });
                    for (var i in fileItems) {
                      String name = i.path.split("/").last;
                      String type = name.split("_")[1];
                      print("name: $name");
                      print("type: $type");

                      if (type == "robot") {
                        await restoreHiveBox<RobotSWLog>("log_robot_box", i.path);
                        print("Restore robot log");
                        loadingProcessText += "로봇 로그 읽기 완료\n";
                      } else if (type == "system") {
                        await restoreHiveBox<SystemLog>("log_system_box", i.path);
                        print("Restore log_system_box log");
                        loadingProcessText += "태블릿 시스템 로그 읽기 완료\n";
                      } else if (type == "exception") {
                        await restoreHiveBox<TabletExceptionLog>("log_exception_box", i.path);
                        print("Restore log_exception_box log");
                        loadingProcessText += "태블릿 예외 로그 읽기 완료\n";
                      } else if (type == "caller") {
                        await restoreHiveBox<TabletCallerLog>("log_caller_box", i.path);
                        print("Restore log_caller_box log");
                        loadingProcessText += "태블릿 함수 로그 읽기 완료\n";
                      }
                      setState(() {});
                    }
                    Get.to(const LogViewerScreen());
                  } else {
                    // User canceled the picker
                  }
                },
                child: const Text("원본 압축 파일 불러오기"),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(loadingProcessText),
        ],
      ),
    );
  }
}
