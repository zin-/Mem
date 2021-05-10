import 'dart:developer';

import 'package:mem/mem.dart';
import 'package:mem/mem_dao.dart';

class MemService {
  Future<Mem> save(Mem mem) async => Mem(
        await MemDao().insert(mem.toEntity()),
        mem.name,
        mem.remarks,
      );

  Future<Mem> fetchByIdIs(int memId) async {
    log("meId: $memId");
    return Mem.fromEntity(
      await MemDao().selectWhereId(memId),
    );
  }

  static MemService _instance;

  const MemService._();

  factory MemService() {
    return _instance ?? MemService._();
  }
}
