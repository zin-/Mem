import 'package:flutter/material.dart';
import 'package:mem/domains/date_and_time.dart';
import 'package:mem/logger.dart';
import 'package:mem/views/atoms/date_and_time_view.dart';
import 'package:mem/views/atoms/date_text_form_field.dart';
import 'package:mem/views/atoms/time_of_day_text_form_field.dart';

@Deprecated('use V2')
class DateAndTimeTextFormField extends StatelessWidget {
  final DateTime? date;
  final TimeOfDay? timeOfDay;
  final Function(DateTime? pickedDate, TimeOfDay? pickedTimeOfDay) onChanged;

  const DateAndTimeTextFormField({
    required this.date,
    required this.timeOfDay,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => v(
        {'date': date, 'timeOfDay': timeOfDay},
        () {
          final allDay = timeOfDay == null;

          return Row(
            children: [
              Expanded(
                child: DateTextFormField(
                  date: date,
                  onChanged: (date) => onChanged(date, timeOfDay),
                ),
              ),
              allDay
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: TimeOfDayTextFormField(
                        timeOfDay: timeOfDay,
                        onChanged: (timeOfDay) => onChanged(date, timeOfDay),
                      ),
                    ),
              Switch(
                value: allDay,
                onChanged: (value) {
                  if (value) {
                    onChanged(date, null);
                  } else {
                    onChanged(date, TimeOfDay.now());
                  }
                },
              ),
              date == null && timeOfDay == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () => onChanged(null, null),
                      icon: const Icon(Icons.clear),
                    ),
            ],
          );
        },
      );
}

class DateAndTimeTextFormFieldV2 extends StatelessWidget {
  final DateAndTime? _dateAndTime;
  final void Function(DateAndTime? pickedDateAndTime) _onChanged;

  const DateAndTimeTextFormFieldV2(
    this._dateAndTime,
    this._onChanged, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => v(
        {'_dateAndTime': _dateAndTime},
        () {
          final dateAndTime = _dateAndTime;

          return Row(
            children: [
              Expanded(
                child: DateTextFormFieldV2(
                  dateAndTime,
                  (pickedDate) {},
                ),
              ),
              dateAndTime == null || dateAndTime.isAllDay
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: TimeOfDayTextFormFieldV2(
                        TimeOfDay.fromDateTime(dateAndTime),
                        (pickedTimeOfDay) {},
                      ),
                    ),
              dateAndTime == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () => _onChanged(null),
                      icon: const Icon(Icons.clear),
                    ),
            ],
          );
        },
      );
}
