import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableRecordType = "recordtype";
final String columnId = "_id";
final String columnName = "name";

class RecordType {
  int id;
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RecordType(this.name);

  RecordType.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
  }
}

class RecordTypeProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableRecordType ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null)
''');
    });
  }

  Future<RecordType> insert(RecordType recordType) async {
    recordType.id = await db.insert(tableRecordType, recordType.toMap());
    return recordType;
  }

  Future<RecordType> getRecordType(int id) async {
    List<Map> maps = await db.query(tableRecordType,
        columns: [
          columnId,
          columnName,
        ],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new RecordType.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableRecordType, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(RecordType recordType) async {
    return await db.update(tableRecordType, recordType.toMap(),
        where: "$columnId = ?", whereArgs: [recordType.id]);
  }

  Future close() async => db.close();
}
