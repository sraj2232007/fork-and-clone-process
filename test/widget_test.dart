import 'package:flutter_test/flutter_test.dart';

import 'package:busiserve_auth/main.dart';

void main() {
  testWidgets('shows the animated splash before opening login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('BUSINESS, MOVING FORWARD.'), findsOneWidget);
    expect(
      find.bySemanticsLabel('BusiServe Infotech Solution logo'),
      findsOneWidget,
    );
    expect(find.text('Welcome Back!'), findsNothing);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
