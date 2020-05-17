import 'dart:async';

import 'package:flutterscannerapp/src/models/ScanModel.dart';
import 'package:flutterscannerapp/src/providers/db_provider.dart';

class ScansBloc {

   static final ScansBloc _singleton = new ScansBloc._internal();

   factory ScansBloc(){
     return _singleton;
   }

   ScansBloc._internal(){
     //obtener los scans de la base de datos
     obtenerScans();
   }

   //en varios lugares  de la app estaran escuchando este broadcast!!
   final _scanController = StreamController<List<ScanModel>>.broadcast();

   //Siempre debemos especificar que tipo de informacion estara en el flujo de steam.
   Stream<List<ScanModel>> get scansStreams => _scanController.stream;

   //Obtener scans
   obtenerScans() async {
     _scanController.sink.add( await DBProvider.db.getTodosLosScans() );
   }

   agregarScans(ScanModel scan) async{
     await DBProvider.db.nuevoScan(scan);
     obtenerScans();
   }

   borrarScans( int id ) async {
     await DBProvider.db.deleteScan(id);
     obtenerScans();
   }

   borrarTodosLosScans() async {
     await DBProvider.db.deleteAll();
     obtenerScans();
   }

   dispose(){
     _scanController?.close();
   }

}