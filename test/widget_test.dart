import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:macropeek/main.dart';

void main() {
  testWidgets('renders the MacroPeek app shell', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const ProviderScope(child: MacroPeekApp()));

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Track daily progress'), findsOneWidget);
  });
}
