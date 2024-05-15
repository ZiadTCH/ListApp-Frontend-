import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/backend/backend.dart';
import 'package:namer_app/screen/edit_item_page.dart';
import 'edit_item_widget_test.mocks.dart';


final mockClient = MockClient();

// Wrapper Klasse für Widget. Definiert Scaffold und Mock-Objekte.
class TestWrapperAppEditItemPage extends StatelessWidget {
  static const _backend = "http://127.0.0.1:8080/item"; 
  final int itemId;

  TestWrapperAppEditItemPage({required this.itemId});

  @override
  Widget build(BuildContext context) {
    when(mockClient.get(Uri.parse('$_backend/$itemId')))
        .thenAnswer((_) async => http.Response('{"id": $itemId, "name": "Existing Item", "description": "Existing Description"}', 200));

    when(mockClient.put(Uri.parse('$_backend/$itemId'), headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('{"id": $itemId, "name": "Updated Name", "description": "Updated Descriptionn"}', 200));

    return MaterialApp(
      theme: ThemeData (
        useMaterial3: true,
      ),
      home: Scaffold(
        body: EditItemPage(Backend(), mockClient, itemId),
      ),
    );
  }
}

@GenerateMocks([http.Client])
void main() {
  testWidgets('Test: Initialisiert die Felder mit vorhandenen Daten', (WidgetTester tester) async {
    await tester.pumpWidget(TestWrapperAppEditItemPage(itemId: 1));
    await tester.pump(); // Pump bis Futures abgeschlossen sind

    // Überprüfen der initialen Werte in den Textfeldern
    expect(find.text('Existing Item'), findsOneWidget);
    expect(find.text('Existing Description'), findsOneWidget);
  });

  testWidgets('Test: Anzeigen einer Fehlermeldung bei Fehler beim Laden', (WidgetTester tester) async {
    final mockClient = MockClient();
    when(mockClient.get(Uri.parse('http://127.0.0.1:8080/items/1')))
        .thenThrow(Exception('Failed to fetch data'));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EditItemPage(Backend(), mockClient, 1),
      ),
    ));
    await tester.pump(); // Pump zum Abfangen der Fehler

    // Überprüfung der Fehlermeldung auf der Snackbar
    expect(find.text('Fehler beim Laden des Artikels'), findsOneWidget);
  });

  testWidgets('Test: Speichern der Änderungen mit validierten Daten', (WidgetTester tester) async {
    await tester.pumpWidget(TestWrapperAppEditItemPage(itemId: 1));

    
    await tester.pump(); // Pump für die Initialisierung

    // Texteingabe und Speichern
    await tester.enterText(find.byType(TextFormField).at(0), 'Updated Name');
    await tester.enterText(find.byType(TextFormField).at(1), 'Updated Description');
    await tester.tap(find.text('Änderungen speichern'));
    await tester.pump(); // Pump für das Senden der Daten

    // Überprüfung, ob die Daten erfolgreich gespeichert wurden
    expect(find.text('Updated Name'), findsOneWidget); 
    expect(find.text('Updated Description'), findsOneWidget); 
  });
}