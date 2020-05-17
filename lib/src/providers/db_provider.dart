
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutterscannerapp/src/models/ScanModel.dart';
export 'package:flutterscannerapp/src/models/ScanModel.dart';

class DBProvider{

  //Utilizaremos el patron singleton, solo para tener una instancia de la clase

  static Database _database; 

  static final DBProvider db = DBProvider._(); //Constructor privado.

  DBProvider._();

  Future<Database> get database async {

    if( _database != null ) return _database;

    _database = await initDB();

    return _database;

  }

  initDB() async {

    //definir el path donde se encuentra la base de datos sqlite:
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Ahora necesitamos el nombre del archivo:
    final path = join( documentsDirectory.path, 'ScanDB.db'); //Nombre del archivo de la base de datos.

    //Comandos para crear la db:
    return await openDatabase( 
      path, 
      version: 1, 
      onOpen: (db) {}, 
      onCreate: ( Database db, int version ) async { //aqui db ya es la base de datos creada.
          await db.execute(
            'CREATE TABLE Scans ('
              'id INTEGER PRIMARY KEY,'
              'tipo TEXT,'
              'valor TEXT'
            ')'
          );     
      }
    );
  }

  //CREAR REGISTROS EN DB:
  nuevoScanRaw(ScanModel nuevoScan) async {

    final db = await database;

    final result = await db.rawInsert( 

        "INSERT Into Scans (id, tipo, valor ) "
        "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' ) "

    );

    return result;

  }


  nuevoScan( ScanModel nuevoScan ) async {

    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }


  //SELECT: obtener informacion
 Future<ScanModel>  getScanbId( int id ) async {

      final db = await database;

      final res = await db.query('Scans', where: 'id = ?', whereArgs: [ id ]);

      return res.isNotEmpty ? ScanModel.fromJson(res.first) :  null;
}


  Future<List<ScanModel>> getTodosLosScans() async {

    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty ? res.map( (c) => ScanModel.fromJson(c) ).toList() : [];

    return list;
  }

    
  Future<List<ScanModel>> getTodosLosTipos(String tipo) async {

    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'  ");

    List<ScanModel> list = res.isNotEmpty ? res.map( (c) => ScanModel.fromJson(c) ).toList() : [];

    return list;
  }

  //Actualizar registros:

    Future<int> updateScan( ScanModel nuevoScan ) async {
      final db = await database;

      final res = await db.update('Scans', nuevoScan.toJson(), where: 'id= ?', whereArgs: [nuevoScan.id]);

      return res;
    }
    
    
  //ELiminar registros:

  Future<int> deleteScan( int id ) async {
    
    final db = await database;
    
    final res = await db.delete('Scans', where: 'id = ?', whereArgs:  [ id ] );

    return res;
    
}


  Future<int> deleteAll() async {

    final db = await database;

    final res = await db.rawDelete("DELETE FROM Scans");

    return res;

  }


}