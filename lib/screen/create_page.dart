import 'package:flutter/material.dart';
import 'package:namer_app/backend/backend.dart';
import 'package:http/http.dart' as http;


class CreateItemPage extends StatefulWidget {
  final Backend _backend;
  final http.Client _client;

  const CreateItemPage(this._backend, this._client);

  @override
  CreateItemPageState createState() {
    return CreateItemPageState();
  }
}

class CreateItemPageState extends State<CreateItemPage> {

  final _formKey = GlobalKey<FormState>();
  late Backend _backend;
  late http.Client _client;
  
  @override
  void initState() {
    super.initState();
    _backend = widget._backend;
    _client = widget._client;
  }

  @override
  Widget build(BuildContext context) {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final nameField = TextFormField(
    key: Key("name"),
    controller: nameController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration (
      hintText: "Please enter item name"
    ),
    validator: (text) {
      if (text == null || text.isEmpty) {
        return 'Error: please enter item name';
      }
      return null;
    },
  );

  final descriptionField = TextFormField(
    key: Key("desc"),
    controller: descriptionController,
    keyboardType: TextInputType.multiline,
    maxLines: 4,
    decoration: InputDecoration (
      hintText: "Please enter item description",
    ),
    validator: (text) {
      if (text == null || text.isEmpty) {
        return 'Error: please enter item description';
      }
      return null;
    },
  );


  final saveButton = ElevatedButton( //Button Color is as define in theme
      key: Key("save"),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _backend.createItem(_client, nameController.text, descriptionController.text)
          .then((value) => Navigator.pop(context));
        }
      },
      child: Text('Create'), //Text Color as define in theme
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
