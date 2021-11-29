import 'package:hive/hive.dart';

part 'robot_sw_log.g.dart';

@HiveType(typeId: 14)
class RobotSWLog {
  @HiveField(0)
  String? log;
  @HiveField(1)
  int? code;
  @HiveField(2)
  int? info0;
  @HiveField(3)
  int? info1;
  @HiveField(4)
  int? timestamp;
  @HiveField(5)
  String? level;
  @HiveField(6)
  String? source;
}
