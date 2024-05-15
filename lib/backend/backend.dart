import 'package:namer_app/model/item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Backend {

  // use IP 10.0.2.2 to access localhost from emulator.
  // static const _backend = "http://10.0.2.2:8080/";

  // use IP 127.0.0.1 to access localhost from windows device.
  static const _backend = "http://127.0.0.1:8080/";

  Future<List<Item>> fetchItemList(http.Client client) async {
    final response = await client.get(Uri.parse('${_backend}items'));
    
    if (response.statusCode == 200) {
      return List<Item>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => Item.fromJson(x)));
    } else {
      throw Exception('Failed to load Itemlist');
    }
  }


  Future<Item> createItem(http.Client client, String name, String description) async {

    Map data = {
      'name': name,
      'description': description,
    };

    var response = await client.post(Uri.parse('${_backend}item'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data)
    );

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create item');
    }

  }

  Future<Item> fetchItemData(http.Client client, int id) async {

    final response = await client.get(Uri.parse('${_backend}item/$id'));

    if (response.statusCode == 200) {
      var tmp = Item.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      return tmp;
      //return Item.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load Item');
    }
  }

  Future<void> deleteItem(http.Client client, int id) async {
    final response = await client.delete(Uri.parse('${_backend}item/$id'));

    if (response.statusCode == 200) {
      // Item erfolgreich gelöscht
    } else {
      // Loggen oder anzeigen der Fehlerantwort
      print('Fehler beim Löschen des Items: ${response.statusCode}');
      throw Exception('Failed to delete item: ${response.body}');
    }
  }

  Future<Item> editItem(http.Client client, int id, String name, String description) async {
    Map data = {
      'name': name,
      'description': description,
    };

    var response = await client.put(
      Uri.parse('${_backend}item/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to edit item');
    }
  }

}
