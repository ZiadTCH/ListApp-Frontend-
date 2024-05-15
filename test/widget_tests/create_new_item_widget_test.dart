import 'package:flutter/material.dart';
import 'package:namer_app/backend/backend.dart';
import 'package:namer_app/screen/create_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// Wrapper Klasse für Widget. Definiert Scaffold. Mock-Objekt ist hier nicht notwendig.
class TestWrapperAppCreateItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData (
        useMaterial3: true,
      ),
      home: Scaffold(
        body: CreateItemPage(Backend(), http.Client()),
      ),
    );
  }
}

void main() {
  testWidgets('Test: zwei Textfelder und ein Button mit Text Create sind vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Create'), findsOneWidget);
  });

  testWidgets('Test: Seite hat nicht gewechselt bei fehlendem Namen', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    await tester.enterText(find.byKey(Key("desc")), 'description');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(CreateItemPage), findsOneWidget);
  });

  testWidgets('Test: Seite hat nicht gewechselt bei fehlender Beschreibung', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    await tester.enterText(find.byKey(Key("name")), 'name');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(CreateItemPage), findsOneWidget);
  });

 testWidgets('Test: Hint für Textfeld Name ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    await tester.enterText(find.byKey(Key("desc")), 'description');
    final textFormField = find.byKey(Key("name"));
    final textFinder = find.text('Please enter item name');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Please enter item name');
  });

  testWidgets('Test: Hint für Textfeld Description ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    await tester.enterText(find.byKey(Key("name")), 'name');
    final textFormField = find.byKey(Key("desc"));
    final textFinder = find.text('Please enter item description');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Please enter item description');
  });

  testWidgets('Test: Validation Text bei leerem Namen ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    await tester.enterText(find.byKey(Key("name")), '');
    await tester.enterText(find.byKey(Key("desc")), 'description');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("name"));
    final textFinder = find.text('Error: please enter item name');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: please enter item name');
  });

  testWidgets('Test: Validation Text bei leerer Beschreibung ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperAppCreateItem());
    await tester.enterText(find.byKey(Key("name")), 'name');
    await tester.enterText(find.byKey(Key("desc")), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("desc"));
    final textFinder = find.text('Error: please enter item description');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Error: please enter item description');
  });


}