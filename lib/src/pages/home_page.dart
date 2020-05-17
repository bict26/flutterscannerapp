import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterscannerapp/src/bloc/scans_bloc.dart';
import 'package:flutterscannerapp/src/models/ScanModel.dart';
import 'package:flutterscannerapp/src/pages/direcciones_page.dart';
import 'package:flutterscannerapp/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutterscannerapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scanBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon : Icon(Icons.delete_forever),
            onPressed: (){
              scanBloc.borrarTodosLosScans();
            },
          ),
          IconButton(
            icon : Icon(Icons.map),
            onPressed: (){

            },
          ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () {
          _scanQR(context);
        },
      ),
    );
  }

   Widget _crearBottomNavigationBar() {

      return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex  = index;
          });
        }, //index: posicon del item donde se hizo click
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Mapa")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5),
              title: Text("Direcciones")
          ),
        ],
      );
   }

  Widget _callPage(int paginaActual) {
    switch(paginaActual){
      case 0:return MapaPage();
      case 1: return DireccionesPage();
      default:
        return MapaPage();
    }

  }

  void _scanQR(BuildContext context)  async {
    String futureString ='https://borisisaac.com';
  /*  try {
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString=e.toString();
    }*/

    if(futureString != null){

      print('Future String: ${futureString}');

      final scan = ScanModel(valor: futureString);
      scanBloc.agregarScans(scan);

      //geo:48.8588377,2.2770205,12
      final scangeo = ScanModel(valor: 'geo:48.8588377,2.2770205,12');
      scanBloc.agregarScans(scangeo);

      if ( Platform.isIOS ){
        Future.delayed(Duration(milliseconds: 750), (){
          utils.launchURL(scan, context);
        });
      }else{
        utils.launchURL(scan, context);
      }
    }
  }
}
