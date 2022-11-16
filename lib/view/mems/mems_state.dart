import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/gui/state_notifier.dart';

final initialized = StateNotifierProvider<ValueStateNotifier<bool>, bool>(
    (ref) => ValueStateNotifier(false));
