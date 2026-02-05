import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:curation/main.dart';

void main() {
  testWidgets('Curation app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: CurationApp()));

    // Verify that the app title is present
    expect(find.text('Curation'), findsOneWidget);
  });
}
