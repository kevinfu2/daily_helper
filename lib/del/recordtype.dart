import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

final String tableRecordType = "recordtype";
final String tableRecord = "record";
final String columnId = "_id";
final String columnName = "name";
final String columnCate = "category";
final String columnLat = "latitude";
final String columnLot = "longtitude";
final String columnStartTime = "starttime";
final String columnEndTime = "endtime";
final String columnLocation = "location";

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

class Record {
  String id;
  String name;
  String category;
  double latitude;
  double longitude;
  DateTime startTime;
  DateTime endTime;
  String location;
  Record(this.id, this.name, this.category, this.latitude, this.longitude,
      this.startTime, this.location);

  @override
  bool operator ==(other) {
    // Dart ensures that operator== isn't called with null
    // if(other == null) {
    //   return false;
    // }
    if (other is! Record) {
      return false;
    }
    return id == (other as Record).id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnName: name,
      columnCate: category,
      columnLat: latitude,
      columnLot: longitude,
      columnStartTime: startTime.toIso8601String(),
      columnEndTime: endTime == null ? null : endTime.toIso8601String(),
      columnLocation: location,
    };
    return map;
  }

  Record.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    category = map[columnCate];
    latitude = map[columnLat];
    longitude = map[columnLot];
    startTime = DateTime.parse(map[columnStartTime]);
    endTime = map[columnEndTime] == null
        ? DateTime.now()
        : DateTime.parse(map[columnEndTime]);
    location = map[columnLocation];
  }

  static Record init() {
    return new Record(
        new Uuid().v4(), "loading", "default", 0.0, 0.0, DateTime.now(), "未知");
  }
}

class RecordDBProvider {
  Database db;
  final _lock = new Lock();
  Future open(String path) async {
    if (db == null) {
      await _lock.synchronized(() async {
        db = await openDatabase(path, version: 2,
            onCreate: (Database db, int version) async {
          await db.execute('''
                          create table $tableRecordType ( 
                            $columnId integer primary key autoincrement, 
                            $columnName text not null)
                          ''');
          await db.execute('''
                          create table $tableRecord ( 
                            $columnId text primary key, 
                            $columnName text not null,
                            $columnCate text not null,
                            $columnLat real not null,
                            $columnLot real not null,
                            $columnStartTime text not null,
                            $columnEndTime text,
                            $columnLocation text not null)
                          ''');
        });
      });
    }
  }

  void SyncToFireBase() async {
    Set<Record> sqliteRecords = (await getRecords()).toSet();
    var querySnap =
        await Firestore.instance.collection('record').getDocuments();
    Set<Record> firebaseRecords =
        querySnap.documents.map((f) => Record.fromMap(f.data)).toSet();
    firebaseRecords.difference(sqliteRecords).forEach((f) => insertRecord(f));
    sqliteRecords
        .difference(firebaseRecords)
        .forEach((f) => Firestore.instance.collection('record').add(f.toMap()));
  }

  Future<Record> insertRecord(Record record) async {
    await db.insert(tableRecord, record.toMap());
    return record;
  }

  Future<int> updateRecord(Record record) async {
    return await db.update(tableRecord, record.toMap(),
        where: "$columnId = ?", whereArgs: [record.id]);
  }

  Future<int> deleteRecord(String id) async {
    return await db
        .delete(tableRecord, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<List<Record>> getRecords({int limit}) async {
    List<Map> maps = await db.query(
      tableRecord,
      columns: [
        columnId,
        columnName,
        columnCate,
        columnLat,
        columnLot,
        columnStartTime,
        columnEndTime,
        columnLocation,
      ],
      orderBy: "$columnStartTime desc",
      limit: limit,
    );
    if (maps.length > 0) {
      return maps.map((f) => Record.fromMap(f)).toList();
    }
    return null;
  }

  Future<Record> getStartedRecord() async {
    List<Map> maps = await db.query(tableRecord,
        columns: [
          columnId,
          columnName,
          columnCate,
          columnLat,
          columnLot,
          columnStartTime,
          columnEndTime,
          columnLocation,
        ],
        where: "$columnEndTime  IS NULL");
    if (maps.length > 0) {
      return new Record.fromMap(maps.first);
    }
    return null;
  }

  Future<RecordType> insertRecordType(RecordType recordType) async {
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

  Future<List<RecordType>> getRecordTypes() async {
    List<Map> maps = await db.query(tableRecordType, columns: [
      columnId,
      columnName,
    ]);
    if (maps.length > 0) {
      return maps.map((f) => RecordType.fromMap(f)).toList();
    }
    return null;
  }

  Future<int> deleteRecordType(int id) async {
    return await db
        .delete(tableRecordType, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateRecordType(RecordType recordType) async {
    return await db.update(tableRecordType, recordType.toMap(),
        where: "$columnId = ?", whereArgs: [recordType.id]);
  }

  Future close() async => db.close();
}
