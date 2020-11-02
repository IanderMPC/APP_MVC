import 'package:flutter/material.dart';

import 'package:filmes_mvc_app/views/item_list.view.dart';


void main() {
  runApp(MaterialApp(
    title:'Lista de Filmes',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
    home: ItemListView(),
  ));
}

