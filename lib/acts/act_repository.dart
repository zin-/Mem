import 'package:mem/core/act.dart';
import 'package:mem/core/date_and_time/date_and_time.dart';
import 'package:mem/core/date_and_time/date_and_time_period.dart';
import 'package:mem/databases/table_definitions/acts.dart';
import 'package:mem/framework/repository/order_by.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/framework/repository/database_tuple_repository.dart';
import 'package:mem/framework/repository/condition/conditions.dart';

class ActRepository extends DatabaseTupleRepository<Act, SavedAct, int> {
  Future<List<SavedAct>> shipByMemId(
    int memId, {
    DateAndTimePeriod? period,
    List<OrderBy>? orderBy,
    int? offset,
    int? limit,
  }) =>
      v(
        () async {
          if (period == null) {
            return await ship(
              condition: Equals(defFkActsMemId.name, memId),
            );
          } else {
            return await ship(
              condition: And([
                Equals(defFkActsMemId.name, memId),
                GraterThanOrEqual(defColActsStart, period.start),
                LessThan(defColActsStart, period.end),
              ]),
              orderBy: orderBy,
              offset: offset,
              limit: limit,
            );
          }
        },
        {'memId': memId, 'period': period},
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
