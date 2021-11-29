
import 'package:hive/hive.dart';

part 'tablet_caller_log.g.dart';

@HiveType(typeId: 16)
class TabletCallerLog{
  @HiveField(0)
  String? exception;
  @HiveField(1)
  int? timestamp;
}