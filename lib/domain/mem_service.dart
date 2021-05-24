import 'package:mem/domain/mem.dart';
import 'package:mem/database/mem_dao.dart';
import 'package:mem/database/models.dart';

class MemService {
  final MemDao _memDao;

  Future<Mem> save(Mem mem) async {
    print("save(mem: ${mem.toString()})");
    final savedId = await _memDao.insert(mem.toEntity());
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
      await _memDao.selectWhereId(memId) ?? MemTable(),
    );
    print("fetchedMem: ${fetchedMem?.toString()}");
    return fetchedMem;
  }

  static MemService _instance;

  const MemService._(this._memDao);

  factory MemService({MemDao memDao}) {
    return _instance ?? MemService._(memDao ?? MemDao());
  }
}
