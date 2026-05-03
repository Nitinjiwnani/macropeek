import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macropeek/main.dart';

void main() {
  testWidgets('renders the MacroPeek app shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MacroPeekApp()));

    await tester.pump();

    expect(find.text('Splash Screen'), findsOneWidget);
  });
}
