import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:smart_store/provider/items_provider.dart';
import 'package:smart_store/provider/selling_provider.dart';
import 'package:smart_store/provider/theme_provider.dart';
import 'package:smart_store/widget/settings.dart';

import '../widget/settings_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemsProvider>(),
  MockSpec<SellingProvider>(),
  MockSpec<ThemeProvider>()
])
void main() {
  testWidgets(
    'List Data Inventory Test',
    (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ItemsProvider>(
              create: (context) => MockItemsProvider(),
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
                home: Scaffold(body: Settings()),
              );
            },
          )));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    },
  );
}
