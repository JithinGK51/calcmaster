import 'package:hive/hive.dart';

part 'calculation_model.g.dart';

@HiveType(typeId: 2)
enum CalculationType {
  @HiveField(0)
  basic,
  @HiveField(1)
  scientific,
  @HiveField(2)
  algebra,
  @HiveField(3)
  geometry,
  @HiveField(4)
  statistics,
  @HiveField(5)
  finance,
  @HiveField(6)
  health,
  @HiveField(7)
  unitConverter,
  @HiveField(8)
  currencyConverter,
}

@HiveType(typeId: 3)
class CalculationHistory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String expression;

  @HiveField(2)
  String result;

  @HiveField(3)
  CalculationType type;

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  String? category;

  @HiveField(6)
  Map<String, dynamic>? metadata;

  @HiveField(7)
  bool isFavorite;

  CalculationHistory({
    required this.id,
    required this.expression,
    required this.result,
    required this.type,
    required this.timestamp,
    this.category,
    this.metadata,
    this.isFavorite = false,
  });

  CalculationHistory copyWith({
    String? id,
    String? expression,
    String? result,
    CalculationType? type,
    DateTime? timestamp,
    String? category,
    Map<String, dynamic>? metadata,
    bool? isFavorite,
  }) {
    return CalculationHistory(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'CalculationHistory(id: $id, expression: $expression, result: $result, type: $type, timestamp: $timestamp)';
  }
}
