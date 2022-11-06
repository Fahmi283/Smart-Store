import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:smart_store/model/items_model.dart';
import 'package:smart_store/provider/items_provider.dart';
import 'package:smart_store/provider/selling_provider.dart';
import 'package:smart_store/provider/theme_provider.dart';
import 'package:smart_store/widget/list_item.dart';
import '../widget/list_items_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemsProvider>(),
  MockSpec<SellingProvider>(),
  MockSpec<ThemeProvider>()
])
void main() {
  testWidgets(
    'List Data Inventory Test',
    (WidgetTester tester) async {
      final MockItemsProvider mockViewModel = MockItemsProvider();
      when(mockViewModel.state).thenReturn(ViewState.none);
      when(mockViewModel.items).thenReturn([
        Items(name: 'test', price: 10000, barcode: 123456, stock: 10),
      ]);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ItemsProvider>(
              create: (context) => mockViewModel,
            ),
            ChangeNotifierProvider<SellingProvider>(
              create: (context) => MockSellingProvider(),
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => MockThemeProvider(),
            )
          ],
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(body: ListItems()),
              );
            },
          )));
      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    },
  );

  testWidgets(
    'Show When Data empty ',
    (WidgetTester tester) async {
      final MockItemsProvider mockViewModel = MockItemsProvider();
      when(mockViewModel.state).thenReturn(ViewState.none);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ItemsProvider>(
              create: (context) => mockViewModel,
            ),
            ChangeNotifierProvider<SellingProvider>(
              create: (context) => MockSellingProvider(),
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => MockThemeProvider(),
            )
          ],
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(body: ListItems()),
              );
            },
          )));
      expect(find.text('List is Empty'), findsOneWidget);
    },
  );

  testWidgets(
    'Show When State error ',
    (WidgetTester tester) async {
      final MockItemsProvider mockViewModel = MockItemsProvider();
      when(mockViewModel.state).thenReturn(ViewState.error);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ItemsProvider>(
              create: (context) => mockViewModel,
            ),
            ChangeNotifierProvider<SellingProvider>(
              create: (context) => MockSellingProvider(),
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => MockThemeProvider(),
            )
          ],
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(body: ListItems()),
              );
            },
          )));
      expect(find.text('Gagal memuat data'), findsOneWidget);
    },
  );
}
