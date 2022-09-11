import 'package:mem/logger.dart';
import 'package:mem/repositories/mem_item_repository.dart';
import 'package:mem/repositories/mem_repository.dart';

class MemService {
  Future<MemEntity> create(
          Map<String, dynamic> memMap, List<MemItemEntity> memItems) =>
      t(
        {'memMap': memMap, 'memItems': memItems},
        () async {
          final receivedMem = await MemRepository().receive(memMap);
          for (var memItem in memItems) {
            await MemItemRepository().receive({
              memIdColumnName: receivedMem.id,
              memDetailTypeColumnName: memItem.type.toString(),
              memDetailValueColumnName: memItem.value,
            });
          }

          return receivedMem;
        },
      );
}
