
import 'package:hive/hive.dart';

part 'system_log.g.dart';

@HiveType(typeId: 0)
class SystemLog{
  @HiveField(0)
  String? datetime;

  @HiveField(1)
  String? log;

}