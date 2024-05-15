import 'package:namer_app/backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'delete_item_test.mocks.dart'; // Generiert durch build_runner

const _backend = "http://127.0.0.1:8080/item";

@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('Delete Item Tests', () {
    // Testfall für erfolgreiches Löschen eines Eintrags
    test('Delete an existing item successfully', () async {
      final client = MockClient();

      // Setup mock response
      when(client.delete(Uri.parse('$_backend/1')))
          .thenAnswer((_) async => http.Response('', 200));

      // Perform delete operation and expect no issues
      await backend.deleteItem(client, 1);
      // Da keine Werte zurückgegeben werden, überprüfen wir, ob die Methode ohne Fehler ausgeführt wird
      expect(backend.deleteItem(client, 1), completes);
    });

    // Testfall für Fehler beim Löschen aufgrund eines Serverfehlers
    test('Throws exception on failed item deletion due to server error', () async {
      final client = MockClient();

      // Setup mock response for error
      when(client.delete(Uri.parse('$_backend/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Check if the method throws an exception
      expect(backend.deleteItem(client, 1), throwsA(isA<Exception>()));
    });
  });
}
