
//CRUD
import 'package:filmes_mvc_app/models/item.model.dart';

import 'package:filmes_mvc_app/repositories/item.repository.dart';

class ItemController{
  List<Item> list = new List<Item>();
  ItemRepository repository = new ItemRepository();

  Future<void> getAll() async{

    list.clear();
    list = await repository.readData();
    _ordenarLista();
  }
  Future<void> create(Item item) async{
    list.add(item);

    await repository.saveData(list);
    await getAll();
  }
  Future<void> update(int i,bool c) async{
    list[i].concluido = c;

    await repository.saveData(list);
    await getAll();
  }
  Future<void> delete(int i) async{

    list.removeAt(i);

    await repository.saveData(list);
    await getAll();
  }
  _ordenarLista(){
    list.sort((a,b){
      if(a.concluido && !b.concluido) return 1;
      else if(!a.concluido && b.concluido) return -1;
      else return 0;
    });
  }
}