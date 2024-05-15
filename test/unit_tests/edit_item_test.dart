import 'package:namer_app/backend/backend.dart';
import 'package:namer_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'edit_item_test.mocks.dart'; // Dies wird generiert durch build_runner

// Diese Konstante wird verwendet, um den URL-Pfad für Tests zu definieren
const _backend = "http://127.0.0.1:8080/item";

@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('Edit Item Tests', () {
    test('Edit an existing item successfully', () async {
      final client = MockClient();

      // Setup mock response
      when(client.put(
        Uri.parse('$_backend/1'), // Verwenden der Test-Konstante
        headers: anyNamed('headers'),
        body: anyNamed('body')
      )).thenAnswer((_) async => http.Response('{"id": 1, "name": "updated name", "description": "updated description"}', 200));

      // Attempt to edit the item
      Item updatedItem = await backend.editItem(client, 1, "updated name", "updated description");

      expect(updatedItem, isA<Item>());
      expect(updatedItem.name, equals("updated name"));
      expect(updatedItem.description, equals("updated description"));
    });

    test('Throws exception on failed item edit due to server error', () async {
      final client = MockClient();

      // Setup mock response for error
      when(client.put(
        Uri.parse('$_backend/1'), // Verwenden der Test-Konstante
        headers: anyNamed('headers'),
        body: anyNamed('body')
      )).thenAnswer((_) async => http.Response('Server Error', 500));

      // Check if the method throws an exception
      expect(backend.editItem(client, 1, "updated name", "updated description"), throwsA(isA<Exception>()));
    });
  });

}
