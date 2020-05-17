import 'package:flutter/material.dart';
import 'package:flutterscannerapp/src/bloc/scans_bloc.dart';
import 'package:flutterscannerapp/src/models/ScanModel.dart';
import 'package:flutterscannerapp/src/utils/utils.dart';


class MapaPage extends StatelessWidget {

  final scanBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scanBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
        stream: scanBloc.scansStreams,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> dataSnap){

          if (!dataSnap.hasData ){
            return Center(child: CircularProgressIndicator(),);
          }

          final scans = dataSnap.data;

          if(scans.length == 0){
            return Center(child: Text("No hay información"),);
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              onDismissed: (direcion) => scanBloc.borrarScans( scans[i].id ), //item en su posición a eliminar
              background: Container(color: Colors.red,),
              child: ListTile(
                leading: Icon(Icons.cloud_queue, color: Colors.blueAccent,),
                title: Text(scans[i].valor),
                subtitle: Text("ID ${ scans[i].id } "),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                onTap: (){
                  launchURL(scans[i], context);
                },
              ),
            ),
          );
        },
    );
  }
}
