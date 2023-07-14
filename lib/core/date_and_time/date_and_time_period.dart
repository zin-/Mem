import 'date_and_time.dart';

abstract class DateAndTimePeriod implements Comparable<DateAndTimePeriod> {
  DateAndTime? get start;

  DateAndTime? get end;

  DateAndTimePeriod._();

  factory DateAndTimePeriod({DateAndTime? start, DateAndTime? end}) {
    if (start != null && end == null) {
      return _WithStartOnly(start);
    } else if (start == null && end != null) {
      return _WithEndOnly(end);
    } else if (start != null && end != null) {
      return _WithStartAndEnd(start, end);
    }

    throw ArgumentError(
      {
        'start': start,
        'end': end,
      }.toString(),
    );
  }

  factory DateAndTimePeriod.startNow({bool allDay = false}) {
    return _WithStartOnly(DateAndTime.now(allDay: allDay));
  }

  @override
  String toString() => {'start': start, 'end': end}.toString();
}

class _WithStartOnly extends DateAndTimePeriod
    implements Comparable<DateAndTimePeriod> {
  @override
  final DateAndTime start;

  @override
  Null get end => null;

  _WithStartOnly(this.start) : super._();

  @override
  int compareTo(DateAndTimePeriod other) {
    if (other is _WithStartOnly) {
      return start.compareTo(other.start);
    } else if (other is _WithEndOnly) {
      return start.isBefore(other.end) ? -1 : 1;
    } else {
      other as _WithStartAndEnd;
      return -other.compareTo(this);
    }
  }
}

class _WithEndOnly extends DateAndTimePeriod
    implements Comparable<DateAndTimePeriod> {
  @override
  Null get start => null;

  @override
  final DateAndTime end;

  _WithEndOnly(this.end) : super._();

  @override
  int compareTo(DateAndTimePeriod other) {
    if (other is _WithStartOnly) {
      return end.isAfter(other.start) ? 1 : -1;
    } else if (other is _WithEndOnly) {
      return end.compareTo(other.end);
    } else {
      other as _WithStartAndEnd;
      return -other.compareTo(this);
    }
  }
}

class _WithStartAndEnd extends DateAndTimePeriod
    implements Comparable<DateAndTimePeriod> {
  @override
  final DateAndTime start;

  @override
  final DateAndTime end;

  _WithStartAndEnd(this.start, this.end) : super._() {
    if (start.compareTo(end) > 0) {
      throw ArgumentError(
        {
          'start': start,
          'end': end,
        }.toString(),
      );
    }
  }

  @override
  int compareTo(DateAndTimePeriod other) {
    if (other is _WithStartOnly) {
      return start.isAfter(other.start) ? 1 : -1;
    } else if (other is _WithEndOnly) {
      return end.isAfter(other.end) ? 1 : -1;
    } else {
      other as _WithStartAndEnd;
      final c = start.compareTo(other.start);
      if (c != 0) {
        return c;
      } else {
        return end.compareTo(other.end);
      }
    }
  }
}