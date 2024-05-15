import 'package:flutter/material.dart';
import 'package:namer_app/backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/model/item.dart';

class EditItemPage extends StatefulWidget {
  final Backend _backend;
  final http.Client _client;
  final int itemId; // Hier speichern wir die ID anstelle des ganzen Items

  const EditItemPage(this._backend, this._client, this.itemId);

  @override
  EditItemPageState createState() => EditItemPageState();
}

class EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  void fetchItem() async {
    try {
      Item item = await widget._backend.fetchItemData(widget._client, widget.itemId);
      if(!mounted) return;
      setState(() {
        nameController = TextEditingController(text: item.name);
        descriptionController = TextEditingController(text: item.description);
      });
    } catch (e) {
      if(!mounted) return;
      // Fehlerbehandlung, Anzeigen einer Snackbar mit der Fehlermeldung
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Laden des Artikels'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      key: Key("ItemNameField"),
      controller: nameController,
      decoration: InputDecoration(labelText: "Item Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte geben Sie den Artikelnamen ein';
        }
        return null;
      },
    );

    final descriptionField = TextFormField(
      key: Key("ItemDescriptionField"),
      controller: descriptionController,
      maxLines: 4,
      decoration: InputDecoration(labelText: "Item Beschreibung"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte geben Sie eine Beschreibung ein';
        }
        return null;
      },
    );

    final saveButton = ElevatedButton(
      key: Key("SaveButton"),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget._backend.editItem(
              widget._client,
              widget.itemId,
              nameController.text,
              descriptionController.text
          ).then((updatedItem) {
            Navigator.pop(context, updatedItem);
          }).catchError((error) {
            final snackBar = SnackBar(content: Text('Fehler beim Aktualisieren des Artikels: $error'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        }
      },
      child: Text('Änderungen speichern'),
    );

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: <Widget>[
          nameField,
          descriptionField,
          saveButton
        ],
      ),
    );
  }
}
