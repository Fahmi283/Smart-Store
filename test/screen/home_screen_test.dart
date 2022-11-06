import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:smart_store/provider/items_provider.dart';
import 'package:smart_store/provider/selling_provider.dart';
import 'package:smart_store/provider/theme_provider.dart';
import 'package:smart_store/screen/home_screen.dart';

import 'home_screen_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemsProvider>(),
  MockSpec<SellingProvider>(),
  MockSpec<ThemeProvider>()
])
void main() {
  testWidgets(
    'Home Screen Test',
    (widgetTester) async {
      await widgetTester.pumpWidget(MultiProvider(
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
          builder: (_) => const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      ));
      expect(find.text('SMART STORE'), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(BottomBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsNothing);
    },
  );
}
