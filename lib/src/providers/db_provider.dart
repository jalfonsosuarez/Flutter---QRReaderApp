

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();

    return _database;

  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory(); 

    final path = join( documentsDirectory.path, 'scansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,' 
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );

  }

  // CREAR REGISTROS


  Future<int> nuevoScanRaw( ScanModel nuevoScan ) async {
    final db  = await database;
    final res = await db.rawInsert(
      "INSERT INTO Scans ( id, tipo, valor ) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );
    return res;

  }

  Future<int> nuevoScan( ScanModel nuevoScan) async {

    final db  = await database;
    final res = await  db.insert('Scans', nuevoScan.toJson() );
    return res;

  }

  // SELECT

  Future<ScanModel> getScanId( int id ) async {

    final db  = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [ id ] );
    return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;

  }

  Future<List<ScanModel>> getTodosScans() async {

    final db  = await database;
    final res = await db.query('Scans');
    
    List<ScanModel> list = res.isNotEmpty ? res.map( (c) => ScanModel.fromJson(c) ).toList() : [];

    return list;

  }

  Future<List<ScanModel>> getScansPorTipo( String tipo ) async {

    final db  = await database;
    final res = await db.rawQuery( "SELECT FROM Scans WHERE tipo = '${tipo}'" );
    
    List<ScanModel> list = res.isNotEmpty ? res.map( (c) => ScanModel.fromJson(c) ).toList() : [];

    return list;

  }

  // ACTUALIZAR REGISTROS

  Future<int> updateScans( ScanModel scan ) async {

    final db  = await database;
    final res = await db.update('Scans', scan.toJson(), where: 'id = ?', whereArgs: [scan.id] );
    return res;

  }

  // BORRAR REGISTROS

  Future<int> deleteScan( int id ) async {

    final db  = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id] );
    return res;

  }


  Future<int> deleteAll() async {

    final db  = await database;
    final res = await db.rawDelete( 'DELETE FROM Scans' );
    return res;

  }

}