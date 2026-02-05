import 'package:flutter_test/flutter_test.dart';
import 'package:curation/models/auth/user.dart';

void main() {
  group('User', () {
    group('construction', () {
      test('should create user with all required fields', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        expect(user.id, 'user_123');
        expect(user.name, '홍길동');
        expect(user.email, 'hong@naver.com');
        expect(user.profileImageUrl, 'https://example.com/profile.jpg');
      });

      test('should allow null profileImageUrl', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        expect(user.profileImageUrl, isNull);
      });
    });

    group('fromNaverAccount', () {
      test('should create user from Naver account data', () {
        final naverData = {
          'id': 'naver_user_123',
          'name': '김네이버',
          'email': 'kim@naver.com',
          'profile_image': 'https://phinf.naver.net/profile.jpg',
        };

        final user = User.fromNaverAccount(naverData);

        expect(user.id, 'naver_user_123');
        expect(user.name, '김네이버');
        expect(user.email, 'kim@naver.com');
        expect(user.profileImageUrl, 'https://phinf.naver.net/profile.jpg');
      });

      test('should handle missing profile_image in Naver data', () {
        final naverData = {
          'id': 'naver_user_123',
          'name': '김네이버',
          'email': 'kim@naver.com',
        };

        final user = User.fromNaverAccount(naverData);

        expect(user.id, 'naver_user_123');
        expect(user.profileImageUrl, isNull);
      });

      test('should handle nickname when name is missing', () {
        final naverData = {
          'id': 'naver_user_123',
          'nickname': '닉네임유저',
          'email': 'nickname@naver.com',
        };

        final user = User.fromNaverAccount(naverData);

        expect(user.name, '닉네임유저');
      });
    });

    group('copyWith', () {
      test('should create a copy with updated name', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        final updated = user.copyWith(name: '김철수');

        expect(updated.id, 'user_123');
        expect(updated.name, '김철수');
        expect(updated.email, 'hong@naver.com');
      });

      test('should preserve all fields when no arguments provided', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        final copy = user.copyWith();

        expect(copy.id, user.id);
        expect(copy.name, user.name);
        expect(copy.email, user.email);
        expect(copy.profileImageUrl, user.profileImageUrl);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        final json = user.toJson();

        expect(json['id'], 'user_123');
        expect(json['name'], '홍길동');
        expect(json['email'], 'hong@naver.com');
        expect(json['profileImageUrl'], 'https://example.com/profile.jpg');
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'id': 'user_123',
          'name': '홍길동',
          'email': 'hong@naver.com',
          'profileImageUrl': 'https://example.com/profile.jpg',
        };

        final user = User.fromJson(json);

        expect(user.id, 'user_123');
        expect(user.name, '홍길동');
        expect(user.email, 'hong@naver.com');
        expect(user.profileImageUrl, 'https://example.com/profile.jpg');
      });

      test('should round-trip correctly', () {
        final original = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        final json = original.toJson();
        final restored = User.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.email, original.email);
        expect(restored.profileImageUrl, original.profileImageUrl);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final user1 = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );
        final user2 = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        expect(user1, equals(user2));
      });

      test('should not be equal when id differs', () {
        final user1 = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );
        final user2 = User(
          id: 'user_456',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        expect(user1, isNot(equals(user2)));
      });
    });
  });
}
