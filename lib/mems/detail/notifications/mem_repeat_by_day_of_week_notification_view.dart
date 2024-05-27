import 'package:collection/collection.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mem/core/mem_notification.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/mems/detail/states.dart';

const keyMemRepeatByDaysOfWeekNotification =
    Key("mem-repeat-by-days-of-week-notification");

class MemRepeatByDaysOfWeekNotificationView extends ConsumerWidget {
  final int? _memId;

  const MemRepeatByDaysOfWeekNotificationView(this._memId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => v(
        () {
          final daysOfWeek =
              ref.watch(memNotificationsByMemIdProvider(_memId).select(
            (value) => value.where((element) => element.isRepeatByDayOfWeek()),
          ));

          return _MemRepeatByDaysOfWeekNotificationView(
            daysOfWeek.map((e) => e.time!).sorted((a, b) => a.compareTo(b)),
            (selected) => v(
              () => ref
                  .read(memNotificationsByMemIdProvider(_memId).notifier)
                  .upsertAll(
                    selected.map(
                      (e) =>
                          daysOfWeek.singleWhereOrNull(
                              (element) => element.time == e) ??
                          MemNotification.repeatByDayOfWeek(_memId, e),
                    ),
                    (current, updating) =>
                        current.type == updating.type &&
                        current.time == updating.time,
                    removeWhere: (current) =>
                        current.type == MemNotificationType.repeatByDayOfWeek &&
                        current.memId == _memId &&
                        !selected.contains(current.time),
                  ),
              {'selected': selected, 'daysOfWeek': daysOfWeek},
            ),
          );
        },
        {
          "_memId": _memId,
        },
      );
}

class _MemRepeatByDaysOfWeekNotificationView extends StatelessWidget {
  final List<int> _daysOfWeek = [0, 1, 2, 3, 4, 5, 6];

  final List<int> _repeatByDaysOfWeek;
  final void Function(Iterable<int> selected) _onChanged;

  _MemRepeatByDaysOfWeekNotificationView(
    this._repeatByDaysOfWeek,
    this._onChanged,
  );

  @override
  Widget build(BuildContext context) => v(
        () {
          // FIXME ここなんとかならんかな
          final dateFormat = DateFormat.E();
          final now = DateTime.now();
          final theme = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: SelectWeekDays(
              onSelect: (List<String> e) =>
                  _onChanged(e.map((e) => int.parse(e))),
              days: _daysOfWeek
                  .map((e) => now.add(Duration(days: e)))
                  .sorted((a, b) => a.weekday.compareTo(b.weekday))
                  .map((e) => dateFormat.format(e))
                  .mapIndexed((index, e) => DayInWeek(e,
                      dayKey: index.toString(),
                      isSelected: _repeatByDaysOfWeek.contains(index)))
                  .toList(growable: false),
              backgroundColor: theme.canvasColor,
              daysFillColor: theme.primaryColor,
              selectedDayTextColor: theme.indicatorColor,
              unSelectedDayTextColor: theme.unselectedWidgetColor,
              border: false,
            ),
          );
        },
        {
          '_daysOfWeek': _repeatByDaysOfWeek,
        },
      );
}
