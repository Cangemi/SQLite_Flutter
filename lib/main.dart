import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async{

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados,"banco.db");

    var bd = await openDatabase(

      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
          db.execute(sql);
      }
    );
    //print("aberto: " + bd.isOpen.toString());
    return bd;
  }

  _salvar()async{

    Database bd =  await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "leticia loyola",
      "idade": 69
    };


    int id = await bd.insert("usuarios", dadosUsuario);

    print("Salvo: $id");

  }



  _listarusuarios() async{

    Database bd =  await _recuperarBancoDados();

    String filtro = "Cangemi";
    String sql = "SELECT * FROM usuarios WHERE nome LIKE '%"+ filtro +"%' ";
    //String sql = "SELECT * FROM usuarios";

    List usuarios = await bd.rawQuery(sql);

    for(var usuario in usuarios){

      print(
        "item id:" + usuario['id'].toString() +
          " nome: " + usuario['nome'] +
          " idade: "+ usuario['idade'].toString()
      );
    }

   // print("usuarios: "+ usuarios.toString());

  }

  _recuperarUsuarioPeloId(int id)async{

    Database bd =  await _recuperarBancoDados();

    List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "nome", "idade"],
      where: "id = ?",
      whereArgs: [id]
    );

    for(var usuario in usuarios){

      print(
          "item id:" + usuario['id'].toString() +
              " nome: " + usuario['nome'] +
              " idade: "+ usuario['idade'].toString()
      );
    }

  }

  _excluirUsuario(int id) async{
    
    Database bd =  await _recuperarBancoDados();

    
    bd.delete(
      "usuarios",
      where: "id = ?",
      whereArgs: [id]
    );
  }


  _atualizarUsuario(int id) async{

    Database bd =  await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Pedro Cangemi alterado",
      "idade": 30
    };

    bd.update(
        "usuarios",
          dadosUsuario,
      where: "id = ?",
      whereArgs: [id]
    );
  }


  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_listarusuarios();
   // _recuperarUsuarioPeloId(2);
   // _excluirUsuario(2);
    _atualizarUsuario(1);
    _recuperarUsuarioPeloId(1);
    return Container();
  }
}



