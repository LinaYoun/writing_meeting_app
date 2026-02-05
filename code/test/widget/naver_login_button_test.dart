import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curation/widgets/auth/naver_login_button.dart';

void main() {
  group('NaverLoginButton', () {
    testWidgets('should display Naver logo and text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NaverLoginButton(
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('네이버 로그인'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have Naver green color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NaverLoginButton(
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style;
      final bgColor = style?.backgroundColor?.resolve({});

      expect(bgColor, const Color(0xFF03C75A));
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NaverLoginButton(
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NaverLoginButton(
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('네이버 로그인'), findsNothing);
    });

    testWidgets('should be disabled when isLoading is true', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NaverLoginButton(
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, false);
    });
  });
}
