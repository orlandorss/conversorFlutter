import 'dart:core';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var request = Uri.parse("https://api.hgbrasil.com/finance?key=88e2f184");

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController  = TextEditingController();
  final dollarController  = TextEditingController();
  final euroController  = TextEditingController();

   double  dollar =0.0 ;
   double euro =0.0;

  void _realChanged(String text){
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dollarChanged(String text){
    double dollar = double.parse(text);
    realController.text = (dollar* this.dollar).toStringAsFixed(2);
    euroController.text = (dollar* this.dollar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro* this.euro).toStringAsFixed(2);
    dollarController.text = (euro* this.euro/dollar).toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor\$\$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        //CRIAMOS UM FUTURE BUILDER PARA NO FUTURO RETORNARMOS ALGO DO NOSSO JSON
        future: getData(), //DECLARAÇÃO DOS DADOS A SEREM ACESSADOS NO FUTURO
        builder: (context, snapshot) {
          //ESPECIFICA O QUE VAI ACONTECER NA TELA ATE QUE OS DADOS ESTEJAM CARREGADOS
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                child:
                Text(
                  "Erro ao carregar dados",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                );
              } else {
                dollar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                dollar = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:<Widget>[
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),

                      buildText("Reais", "R\$", realController,_realChanged),
                      Divider(),
                      buildText("Dólar", "US\$",dollarController,_dollarChanged),
                      Divider(),
                      buildText("Euro", "€",euroController,_euroChanged)
                    ],
                  ),
                );
              }
              return Text("data");
          }
        },
      ),
    );
  }
}

Widget  buildText(String label, String prefix, TextEditingController controller,  void Function(String text) fun   ){
  return TextField(
    controller:  controller,
        decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
      style: TextStyle(
          color: Colors.amber,
                fontSize: 25.0),
    onChanged: fun,
    keyboardType: TextInputType.numberWithOptions(),
  );


}