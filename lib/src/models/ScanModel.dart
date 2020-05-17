import 'package:latlong/latlong.dart';
class ScanModel {
    
    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      if(this.valor.contains('http')){
        this.tipo = 'http';
      }else{
        this.tipo = 'geo';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };

    getLatLng(){
      //geo:48.8588377,2.2770205,12
      final latlng = valor.substring(4).split(",");
      final lat = double.parse(latlng[0]);
      final lng = double.parse(latlng[1]);
      return LatLng(lat, lng);
    }

}
