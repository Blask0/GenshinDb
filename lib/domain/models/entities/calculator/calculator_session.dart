import 'package:hive/hive.dart';

part 'calculator_session.g.dart';

@HiveType(typeId: 1)
class CalculatorSession extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int position;

  @HiveField(2)
  DateTime createdAt;

  CalculatorSession(this.name, this.position) : createdAt = DateTime.now();
}
