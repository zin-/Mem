import 'package:flutter/material.dart';
import 'package:mem/gui/date_and_time/date_and_time_period_view.dart';

import '../../core/act.dart';

class ActListItemView extends ListTile {
  final Act act;

  ActListItemView(this.act, {super.key})
      : super(
          title: DateAndTimePeriodTexts(act.period),
        );
}
