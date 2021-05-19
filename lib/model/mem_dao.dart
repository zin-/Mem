import 'package:mem/model/database.dart';

class MemDao {
  Future<int> insert(MemTable memTable) async =>
      await memTable.save();

  Future<MemTable> selectWhereId(int id) async =>
      MemTable().getById(id);

  static MemDao _instance;

  const MemDao._();

  factory MemDao() {
    return _instance ?? MemDao._();
  }
}
