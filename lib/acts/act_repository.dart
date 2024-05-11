import 'package:mem/core/act.dart';
import 'package:mem/core/date_and_time/date_and_time.dart';
import 'package:mem/core/date_and_time/date_and_time_period.dart';
import 'package:mem/databases/table_definitions/acts.dart';
import 'package:mem/databases/table_definitions/base.dart';
import 'package:mem/framework/repository/order_by.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/framework/repository/database_tuple_repository.dart';
import 'package:mem/framework/repository/condition/conditions.dart';

enum ActOrderBy { descStart, descEnd }

extension _ActOrderByExt on ActOrderBy {
  OrderBy get toQuery {
    switch (index) {
      case 0:
        return Descending(defColActsStart);
      case 1:
        return Descending(defColActsEnd);

      default:
        throw Exception(); // coverage:ignore-line
    }
  }
}

class ActRepository extends DatabaseTupleRepository<Act, SavedAct, int> {
  Future<SavedAct?> findOneBy(
    int memId,
    bool latest,
  ) =>
      v(
        () async {
          final oneOrNothing = await super.ship(
            condition: Equals(defFkActsMemId.name, memId),
            orderBy: [
              if (latest) ActOrderBy.descEnd.toQuery,
              if (latest) ActOrderBy.descStart.toQuery,
            ],
            limit: 1,
          );

          return oneOrNothing.length == 1 ? oneOrNothing.single : null;
        },
        {
          "memId": memId,
          "latest": latest,
        },
      );

  @override
  Future<int> count({
    int? memId,
    Condition? condition,
  }) =>
      v(
        () => super.count(
          condition: And(
            [
              if (memId != null) Equals(defPkId.name, memId),
              if (condition != null) condition, // coverage:ignore-line
            ],
          ),
        ),
        {
          "memId": memId,
          "condition": condition,
        },
      );

  @override
  Future<List<SavedAct>> ship({
    int? memId,
    DateAndTimePeriod? period,
    ActOrderBy? actOrderBy,
    Condition? condition,
    List<OrderBy>? orderBy,
    int? offset,
    int? limit,
  }) =>
      v(
        () => super.ship(
          condition: And(
            [
              if (memId != null) Equals(defFkActsMemId.name, memId),
              if (period != null)
                GraterThanOrEqual(defColActsStart, period.start),
              if (period != null) LessThan(defColActsStart, period.end),
              if (condition != null) condition,
            ],
          ),
          orderBy: [
            if (actOrderBy != null) actOrderBy.toQuery,
            if (orderBy != null) ...orderBy, // coverage:ignore-line
          ],
          offset: offset,
          limit: limit,
        ),
        {
          "memId": memId,
          "period": period,
          "condition": condition,
          "orderBy": orderBy,
          "offset": offset,
          "limit": limit,
        },
      );

  Future<List<SavedAct>> shipActive() => v(
        () async => await ship(condition: IsNull(defColActsEnd.name)),
      );

  Future<List<SavedAct>> shipActiveByMemId(
    int memId,
  ) =>
      v(
        () async => await ship(
          condition: And([
            Equals(defFkActsMemId.name, memId),
            IsNull(defColActsEnd.name),
          ]),
        ),
        {
          "memId": memId,
        },
      );

  @override
  SavedAct pack(Map<String, dynamic> tuple) => SavedAct(
        tuple[defFkActsMemId.name],
        DateAndTimePeriod(
          start: DateAndTime.from(
            tuple[defColActsStart.name],
            timeOfDay: tuple[defColActsStartIsAllDay.name]
                ? null
                : tuple[defColActsStart.name],
          ),
          end: tuple[defColActsEnd.name] == null
              ? null
              : DateAndTime.from(
                  tuple[defColActsEnd.name],
                  timeOfDay: tuple[defColActsEndIsAllDay.name]
                      ? null
                      : tuple[defColActsEnd.name],
                ),
        ),
      )..pack(tuple);

  @override
  Map<String, dynamic> unpack(Act entity) {
    final map = {
      defFkActsMemId.name: entity.memId,
      defColActsStart.name: entity.period.start,
      defColActsStartIsAllDay.name: entity.period.start?.isAllDay,
      defColActsEnd.name: entity.period.end,
      defColActsEndIsAllDay.name: entity.period.end?.isAllDay,
    };

    if (entity is SavedAct) {
      map.addAll(entity.unpack());
    }

    return map;
  }

  ActRepository._() : super(defTableActs);

  static ActRepository? _instance;

  factory ActRepository() => v(
        () => _instance ??= ActRepository._(),
      );
}
