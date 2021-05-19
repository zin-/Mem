import 'package:mem/domain/mem.dart';
import 'package:mem/model/mem_dao.dart';
import 'package:mem/model/database.dart';

class MemService {
  Future<Mem> save(Mem mem) async {
    print("save(mem: ${mem.toString()})");
    final savedId = await MemDao().insert(mem.toEntity());
    print("savedId: $savedId");
    return Mem(
      savedId,
      mem.name,
      mem.remarks,
    );
  }

  Future<Mem> fetchByIdIs(int memId) async {
    print("fetchByIdIs(memId: $memId)");
    final fetchedMem = Mem.fromEntity(
      await MemDao().selectWhereId(memId) ?? MemTable(),
    );
    print("fetchedMem: ${fetchedMem?.toString()}");
    return fetchedMem;
  }

  static MemService _instance;

  const MemService._();

  factory MemService() {
    return _instance ?? MemService._();
  }
}
