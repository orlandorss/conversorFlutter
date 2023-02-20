import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var request = Uri.parse("https://api.hgbrasil.com/finance?key=88e2f184");

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor\$\$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(//CRIAMOS UM FUTURE BUILDER PARA NO FUTURO RETORNARMOS ALGO DO NOSSO JSON
        future: getData(),//DECLARAÇÃO DOS DADOS A SEREM ACESSADOS NO FUTURO
        builder: (context, snapshot) {//ESPECIFICA O QUE VAI ACONTECER NA TELA ATE QUE OS DADOS ESTEJAM CARREGADOS
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
              if  (snapshot.hasError){
                child: Text(
                  "Erro ao carregar dados",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                );
              }else{
                return Container(color: Colors.deepOrange);
              }
          }
          return Text("NONONO");
        },
      ),
    );
  }
}