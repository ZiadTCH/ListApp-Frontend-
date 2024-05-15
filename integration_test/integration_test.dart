import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:namer_app/screen/create_page.dart';
import 'package:namer_app/screen/edit_item_page.dart';
import 'package:namer_app/screen/main_page.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Test: create item',
      (tester) async {
        // Start auf MainPage
        await tester.pumpWidget(const MyApp());
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(ListView).evaluate().length, 0);
        // Wechsel auf CreateItemPage
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byType(CreateItemPage), findsOneWidget);
        await tester.enterText(find.byKey(Key("name")), 'item name');
        await tester.enterText(find.byKey(Key("desc")), 'item description');
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle(Duration(seconds: 2));
        // Item speichern und Wechsel zurück auf MainPage
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(ListView).evaluate().length, 1);
        expect(find.text('item name'), findsOneWidget);
        expect(find.text('item description'), findsOneWidget);
        // delete
        await tester.tap(find.byKey(Key("delete")));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.text('new item name'), findsNothing);
        expect(find.text('new item description'), findsNothing);
  });
  
  testWidgets('Test: edit item',
      (tester) async {
        // Start auf MainPage
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Wechsel auf CreateItemPage
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byType(CreateItemPage), findsOneWidget);
        await tester.enterText(find.byKey(Key("name")), 'item name');
        await tester.enterText(find.byKey(Key("desc")), 'item description');
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Item speichern und Wechsel zurück auf MainPage
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(ListView).evaluate().length, 1);
        expect(find.text('item name'), findsOneWidget);
        expect(find.text('item description'), findsOneWidget);

        await tester.tap(find.byKey(Key("edit")));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byType(EditItemPage), findsOneWidget);
        await tester.enterText(find.byKey(Key("ItemNameField")), 'item name2');
        await tester.enterText(find.byKey(Key("ItemDescriptionField")), 'item description2');
        await tester.tap(find.byKey(Key("SaveButton")));

        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byType(MainPage), findsOneWidget);

        expect(find.text('item name'), findsNothing);
        expect(find.text('item description'), findsNothing);
        expect(find.text('item name2'), findsOneWidget);
        expect(find.text('item description2'), findsOneWidget);
  });

  testWidgets('Test: delete item',
      (tester) async {
        // Start auf MainPage
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle(Duration(seconds: 2));

        await tester.tap(find.byKey(Key("delete")));
        await tester.pumpAndSettle(Duration(seconds: 6));
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.text('item name2'), findsNothing);
        expect(find.text('item description2'), findsNothing);
        
  });
}