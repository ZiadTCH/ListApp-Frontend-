
import 'package:namer_app/model/item.dart';
import 'package:namer_app/backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'fetch_item_list_test.mocks.dart';

const _backend = "http://127.0.0.1:8080/items";

// Generiere Mock-Objekt für http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('Fetch Item List', () {
    test('Test: Wirft Exception, falls Http Aufruf mit Fehler 404 endet.', () {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(backend.fetchItemList(client), throwsException);
    });
    test('Test: Liefert eine nicht leere Liste von Items vom Server.', () async {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[{"id": 1, "name": "item1", "description": "description1"}, {"id": 2, "name": "item2", "description": "description2"}]', 200));
      
      List<Item> result = await backend.fetchItemList(client);
      expect(result, isA<List<Item>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].name, "item1");
      expect(result[0].description, "description1");
      expect(result[1].id, 2);
      expect(result[1].name, "item2");
      expect(result[1].description, "description2");
    });
    test('Test: Liefert eine leere Liste von Items vom Server.', () async {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[]', 200));

      List<Item> result = await backend.fetchItemList(client);
      expect(result, isA<List<Item>>());
      expect(result.length, 0);
    });
  });
}

