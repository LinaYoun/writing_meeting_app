import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Security Configuration Tests', () {
    group('network_security_config.xml', () {
      late String configContent;

      setUpAll(() {
        // Read the network security config file
        final configFile = File(
          'android/app/src/main/res/xml/network_security_config.xml',
        );
        expect(configFile.existsSync(), true,
            reason: 'network_security_config.xml should exist');
        configContent = configFile.readAsStringSync();
      });

      test('should have cleartextTrafficPermitted=false in base-config', () {
        expect(
          configContent,
          contains('cleartextTrafficPermitted="false"'),
          reason: 'Cleartext traffic should be disabled',
        );
      });

      test('should have pin-set for certificate pinning', () {
        expect(
          configContent,
          contains('<pin-set'),
          reason: 'Certificate pinning should be configured',
        );
      });

      test('should have SHA-256 digest pins', () {
        expect(
          configContent,
          contains('digest="SHA-256"'),
          reason: 'SHA-256 digest should be used for pins',
        );
      });

      test('should have expiration date for pin-set', () {
        expect(
          RegExp(r'<pin-set\s+expiration="[0-9]{4}-[0-9]{2}-[0-9]{2}"')
              .hasMatch(configContent),
          true,
          reason: 'Pin-set should have a valid expiration date',
        );
      });

      test('should have at least 2 pins for backup', () {
        final pinCount = '<pin digest='.allMatches(configContent).length;
        expect(
          pinCount,
          greaterThanOrEqualTo(2),
          reason: 'At least 2 pins required (primary + backup)',
        );
      });

      test('should include nid.naver.com domain', () {
        expect(
          configContent,
          contains('nid.naver.com'),
          reason: 'nid.naver.com should be configured',
        );
      });

      test('should include openapi.naver.com domain', () {
        expect(
          configContent,
          contains('openapi.naver.com'),
          reason: 'openapi.naver.com should be configured',
        );
      });

      test('should have valid base64 encoded pins', () {
        // Base64 pattern: alphanumeric + / + ending with = padding
        final pinPattern = RegExp(
          r'<pin digest="SHA-256">([A-Za-z0-9+/]+=*)</pin>',
        );
        final matches = pinPattern.allMatches(configContent);

        expect(matches.length, greaterThanOrEqualTo(2));

        for (final match in matches) {
          final pin = match.group(1)!;
          // SHA-256 base64 encoded should be 44 characters (32 bytes -> 44 base64 chars)
          expect(
            pin.length,
            44,
            reason: 'SHA-256 pin should be 44 characters: $pin',
          );
        }
      });
    });

    group('AndroidManifest.xml Security', () {
      late String manifestContent;

      setUpAll(() {
        final manifestFile = File('android/app/src/main/AndroidManifest.xml');
        expect(manifestFile.existsSync(), true,
            reason: 'AndroidManifest.xml should exist');
        manifestContent = manifestFile.readAsStringSync();
      });

      test('should have allowBackup=false', () {
        expect(
          manifestContent,
          contains('android:allowBackup="false"'),
          reason: 'Backup should be disabled for security',
        );
      });

      test('should reference network_security_config', () {
        expect(
          manifestContent,
          contains('networkSecurityConfig'),
          reason: 'Network security config should be referenced',
        );
      });
    });
  });
}
