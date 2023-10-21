import 'package:mem/core/date_and_time/date_and_time_period.dart';
import 'package:mem/framework/entity.dart';
import 'package:mem/framework/database_tuple_entity.dart';

import 'entity_value.dart';

class MemV2 extends Entity {
  final String name;
  final DateTime? doneAt;
  final DateAndTimePeriod? period;

  MemV2(this.name, this.doneAt, this.period);

  factory MemV2.fromV1(Mem v1) => v1.isSaved()
      ? SavedMemV2.fromV1(v1)
      : MemV2(
          v1.name,
          v1.doneAt,
          v1.period,
        );
}

class SavedMemV2<I> extends MemV2 with SavedDatabaseTuple<I> {
  SavedMemV2(super.name, super.doneAt, super.period);

  Mem toV1() => Mem(
        name: name,
        doneAt: doneAt,
        period: period,
        id: id as int,
        createdAt: createdAt,
        updatedAt: updatedAt,
        archivedAt: archivedAt,
      );

  factory SavedMemV2.fromV1(Mem v1) => SavedMemV2(
        v1.name,
        v1.doneAt,
        v1.period,
      )
        ..id = v1.id
        ..createdAt = v1.createdAt as DateTime
        ..updatedAt = v1.updatedAt
        ..archivedAt = v1.archivedAt;
}

class Mem extends EntityValue {
  String name;
  DateTime? doneAt;
  DateAndTimePeriod? period;

  Mem({
    required this.name,
    this.doneAt,
    this.period,
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          archivedAt: archivedAt,
        );

  bool isDone() => doneAt != null;

  @override
  String toString() =>
      {
        'name': name,
        'doneAt': doneAt,
        'period': period,
      }.toString() +
      super.toString();

  // FIXME エレガントじゃない
  Mem copied() => Mem(
        name: name,
        doneAt: doneAt,
        period: period,
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        archivedAt: archivedAt,
      );
}
