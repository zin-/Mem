import 'package:mem/model/database.dart';

class Mem {
  int id;
  String name;
  String remarks;

  Mem(this.id, this.name, this.remarks);

  Mem.withoutId(this.name, this.remarks);

  Mem.fromEntity(MemTable memTable)
      : this(
          memTable.id,
          memTable.name,
          memTable.remarks,
        );

  MemTable toEntity() => MemTable.withId(
        id,
        name,
        remarks,
        false,
      );
}
