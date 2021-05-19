import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/domain/mem_service.dart';

import '../domain/mem.dart';

class MemDetailModel extends StateNotifier<Mem> {
  MemDetailModel(Mem state) : super(state);

  void fetch(int memId) async {
    state = await MemService().fetchByIdIs(memId);
  }

  void save() async {
    state = await MemService().save(state);
  }
}

final memDetailModelProvider =
    StateNotifierProvider<MemDetailModel, Mem>(
  (ref) => MemDetailModel(null),
);
