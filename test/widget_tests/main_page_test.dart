import 'package:flutter/material.dart';
import 'package:namer_app/backend/backend.dart';
import 'package:namer_app/screen/main_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'main_page_test.mocks.dart';
import 'package:http/http.dart' as http;


// Wrapper Klasse für Widget. Definiert Scaffold und Mock-Objekte.
class TestWrapperAppMainPage1 extends StatelessWidget {

  static const _backend = "http://127.0.0.1:8080/items";     

  @override
  Widget build(BuildContext context) {

    final mockClient = MockClient();

    when(mockClient
        .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[{"id": 1, "name": "item1", "description": "description1"}, {"id": 2,"name": "item2","description": "description2"} ]', 200));


    return MaterialApp(
      theme: ThemeData (
        useMaterial3: true,
      ),
      home: Scaffold(
        body: MainPage(Backend(), mockClient),
      ),
    );
  }
}

// Wrapper Klasse für Widget. Definiert Scaffold und Mock-Objekte.
class TestWrapperAppMainPage2 extends StatelessWidget {

  static const _backend = "http://127.0.0.1:8080/items";     

  @override
  Widget build(BuildContext context) {

    final mockClient = MockClient();

    when(mockClient
        .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[]', 200));          

    return MaterialApp(
      theme: ThemeData (
        useMaterial3: true,
      ),
      home: Scaffold(
        body: MainPage(Backend(), mockClient),
      ),
    );
  }
}


@GenerateMocks([http.Client])
void main() {


  testWidgets('Test: Laden von zwei Items', (tester) async {
    await tester.pumpWidget(TestWrapperAppMainPage1());
    expect(find.byType(MainPage), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
   testWidgets('Test: Laden einer leeren Item Liste', (tester) async {
    await tester.pumpWidget(TestWrapperAppMainPage2());
    expect(find.byType(MainPage), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(Card), findsNWidgets(0));
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
  testWidgets('Test: Items haben Delete Icon', (tester) async {
    await tester.pumpWidget(TestWrapperAppMainPage1());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
  });

  testWidgets('Test: Items haben Edit Icon', (tester) async {
    await tester.pumpWidget(TestWrapperAppMainPage1());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byIcon(Icons.edit), findsNWidgets(2));
  });


  testWidgets('Dialog zum Hinzufügen eines neuen Items und Überprüfung, ob setState aufgerufen wird', (tester) async {
    await tester.pumpWidget(TestWrapperAppMainPage1());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Simuliere das Hinzufügen eines neuen Items und Überprüfung der UI-Änderung
    // navigatorObserver.mockPop(newItem);

    await tester.pump(); // Warte auf den setState, der nach dem Hinzufügen des Items aufgerufen wird
  });
  
}