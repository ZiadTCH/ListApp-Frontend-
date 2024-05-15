import 'package:namer_app/backend/backend.dart';
import 'package:namer_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'create_new_item_test.mocks.dart';

const _backend = "http://127.0.0.1:8080/item";

// Generiere Mock-Objekt für http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('Create New Item', () {
    test('Test: Wirft Exception, falls Http Aufruf mit Fehler 404 endet.', () {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .post(Uri.parse(_backend),
              body: anyNamed('body'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(backend.createItem(client, "new item", "new item"), throwsException);
    });
    test('Test: Neues Item anlegen', () async {
    final client = MockClient();

    // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
    when(client
            .post(Uri.parse(_backend),
            body: anyNamed('body'),
            headers: anyNamed('headers')))
        .thenAnswer((_) async =>
            http.Response('{"id": 1, "name": "item1", "description": "description1"}', 200));

        Item item = await backend.createItem(client, "item1", "description1");
        expect(item, isA<Item>());
        expect(1, item.id);
        expect("item1", item.name);
        expect("description1", item.description);
      });
    });

    
}

