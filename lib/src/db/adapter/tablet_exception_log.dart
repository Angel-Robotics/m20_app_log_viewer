
import 'package:hive/hive.dart';

part 'tablet_exception_log.g.dart';

@HiveType(typeId: 13)
class TabletExceptionLog{
  @HiveField(0)
  String? exception;
  @HiveField(1)
  int? timestamp;
}