import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sky_cast/app.dart';
import 'package:sky_cast/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App should start with splash screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SkyCastApp());

    // Verify that splash screen is displayed
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('App should have proper theme colors', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(const SkyCastApp());

    // Get the theme
    final theme = Theme.of(tester.element(find.byType(MaterialApp)));

    // Verify theme properties - check if it's not null
    expect(theme.scaffoldBackgroundColor, isNotNull);
  });
}
