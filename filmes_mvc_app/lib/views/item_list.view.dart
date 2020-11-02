
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filmes_mvc_app/controller/item.controller.dart';
import 'package:filmes_mvc_app/models/item.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemListView extends StatefulWidget {
  @override
  _ItemListView createState() => _ItemListView();

}

class _ItemListView extends State<ItemListView> {
  final _formKey = GlobalKey<FormState>();
  var _itemController = TextEditingController();
  String _theme = 'Light';
  var _themeData = ThemeData.light();

  List<Item> _lista = new List<Item>();


  ItemController controller = new ItemController();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAll().then((data) {
        setState(() {
          _lista = controller.list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Filmes'),
        centerTitle: true, //Coloca o titulo no centro
        actions: [
          _popupMenuButton()
        ],
        /*actions: [
          IconButton(
            icon: Icon(CupertinoIcons.ellipsis_vertical),

            onPressed: () async {
                _PopupMenuButton();
            },
          )
        ],*/
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for(int i = 0; i < _lista.length; i++)
              ListTile(
                  title: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: _lista[i].concluido
                        ?
                    Text(_lista[i].nome,
                      style: TextStyle(decoration: TextDecoration.lineThrough),)
                        :
                    Text(_lista[i].nome),
                    value: _lista[i].concluido,
                    secondary: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20.0,
                        color: Colors.yellow[800],
                      ),
                      onPressed: () {
                        controller.delete(i).then((data) {
                          setState(() {
                            _lista = controller.list;
                          });
                        });
                      },
                    ),
                    onChanged: (c) {
                      controller.update(i, c).then((data) {
                        setState(() {
                          _lista = controller.list;
                        });
                      });
                    },
                  )),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayDialog(
            context), // expressao lambda ex: (a,b) => { print(a, b);}

      ),
    ); //Container - Cernter - Row - Column - Scaffold
  }

  _displayDialog(context) async {
    return showDialog(
        context: context,

        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(right:10.0, left: 10.0),

            content: Form(

              key: _formKey,
              child: TextFormField(
                controller: _itemController,
                validator: (s) {
                  if (s.isEmpty)
                    return "Digite um Filme";
                  else
                    return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Filme"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    controller.create(
                        Item(nome: _itemController.text, concluido: false))
                        .then((data) {
                      setState(() {
                        _lista = controller.list;
                      });
                    });

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        }
    );
  }


// Carregando o tema salvo pelo usuário
  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = (prefs.getString('theme') ?? 'Light');
      _themeData = _theme == 'Dark' ? ThemeData.dark() : ThemeData.light();
    });
  }
// Carregando o tema salvo pelo usuário
  _setTheme(theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = theme;
      _themeData = theme == 'Dark' ? ThemeData.dark() : ThemeData.light();
      prefs.setString('theme', theme);
    });
  }
  _popupMenuButton(){
    return PopupMenuButton(
      onSelected: (value) => _setTheme(value) ,
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
              child: Text("Configurar Tema")
          ),
        );
        list.add(
          PopupMenuDivider(
            height: 10,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text("Light"),
            value: 'Light',
            checked: _theme == 'Light',
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text("Dark"),
            value: 'Dark',
            checked: _theme == 'Dark',
          ),
        );
        return list;
      },
    );
  }

}
