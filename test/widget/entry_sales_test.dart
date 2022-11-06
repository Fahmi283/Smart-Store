import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:smart_store/provider/items_provider.dart';
import 'package:smart_store/provider/selling_provider.dart';
import 'package:smart_store/provider/theme_provider.dart';
import 'package:smart_store/widget/entry_sales.dart';
import '../widget/entry_sales_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemsProvider>(),
  MockSpec<SellingProvider>(),
  MockSpec<ThemeProvider>()
])
void main() {
  testWidgets(
    'Entry Data Penjualan Test',
    (WidgetTester tester) async {
      final MockSellingProvider mockViewModel = MockSellingProvider();
      when(mockViewModel.state).thenReturn(DataState.none);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ItemsProvider>(
              create: (context) => MockItemsProvider(),
            ),
            ChangeNotifierProvider<SellingProvider>(
              create: (context) => mockViewModel,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => MockThemeProvider(),
            )
          ],
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(body: EntrySales()),
              );
            },
          )));
      expect(find.text('Gagal memuat data'), findsNothing);
      expect(find.text('Add Data'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.text('Masukan Data Penjualan'), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
    },
  );

  testWidgets(
    'Show error when state error',
    (WidgetTester tester) async {
      final MockSellingProvider mockViewModel = MockSellingProvider();
      when(mockViewModel.state).thenReturn(DataState.error);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ItemsProvider>(
              create: (context) => MockItemsProvider(),
            ),
            ChangeNotifierProvider<SellingProvider>(
              create: (context) => mockViewModel,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => MockThemeProvider(),
            )
          ],
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(body: EntrySales()),
              );
            },
          )));
      expect(find.text('Gagal memuat data'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    },
  );
}
