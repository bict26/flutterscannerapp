import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutterscannerapp/src/models/ScanModel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Coordenadas"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.my_location), onPressed: (){},)
        ],
      ),
      body: _crearFlutterMap(scan),
    );
  }

 Widget _crearFlutterMap(ScanModel scan) {

    return FlutterMap(
      options: MapOptions(
      center: scan.getLatLng(),
        zoom: 10
      ),
      layers: [
        _crearMapa()
      ],

    );

 }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.tiles.mapbox.com/v4/'
        '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':'pk.eyJ1IjoiYm9yaXNpc2FhY3giLCJhIjoiY2thN3h1eGRjMDJ1YzJybWh5Y25vZ3d5ZiJ9.NpXfK4uHWmj5v82h1u--MQ',
          'id': 'mapbox.streets'
        }
    );
  }

}
