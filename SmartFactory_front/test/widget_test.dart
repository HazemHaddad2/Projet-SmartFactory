import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartfactory_front/main.dart';

void main() {
  testWidgets('SmartFactory app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartFactoryApp());

    // Verify that the app starts with splash screen
    expect(find.byIcon(Icons.factory), findsOneWidget);
    expect(find.text('SmartFactory Monitor'), findsOneWidget);
  });
}
