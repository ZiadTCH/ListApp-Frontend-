import 'package:flutter/material.dart';
import 'package:namer_app/backend/backend.dart';
import 'package:namer_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'create_page.dart';
import 'edit_item_page.dart';

class MainPage extends StatefulWidget {

  final Backend _backend;
  final http.Client _client;

  const MainPage(this._backend, this._client);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // access to backend proxy
  late Backend _backend;
  
  // access to http stack
  late http.Client _client;
  
  @override
  void initState() {
    super.initState();
    _backend = widget._backend;
    _client = widget._client;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Center(
            child: Text('Basic Item App'),
          ),
        ),
        body: FutureBuilder<List<Item>>(
                future:  _backend.fetchItemList(_client),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (_, int position) {
                            final item = snapshot.data?[position];
                            return Card(
                              child: ListTile(
                                title: Text(item!.name),
                                subtitle: Text(item.description),
                                trailing: Row(          
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  IconButton(
                                    key: Key("edit"),
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit Item',
                                    onPressed: () => showDialog<Item>(
                                      context: context,
                                      builder: (BuildContext context) => Dialog.fullscreen(
                                        child: EditItemPage(_backend, _client, item.id),
                                      ),
                                    ).then((updatedItem) {
                                      if (updatedItem != null) {
                                        setState((){});
                                      }
                                      }),
                                  ),
                                  IconButton(
                                    key: Key("delete"),
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete Item',
                                    onPressed: () {
                                      _backend.deleteItem(_client, item.id).then((_) => setState(() {
                                        
                                      }));
                                    }
                                  ),
                                ])
                              ),
                            );
                          },
                        ) : Center(
                          child: CircularProgressIndicator(),
                        );
                },
            ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'New',
          onPressed: () => showDialog<bool>(
            context: context,
            builder: (BuildContext context) => Dialog.fullscreen(
              child: CreateItemPage(_backend, _client),
            ),
          ).then((_) => setState((){})),
          child: Icon(Icons.add),
        ),
    );
  }
}