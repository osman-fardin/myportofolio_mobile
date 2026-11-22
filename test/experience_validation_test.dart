import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/forms/experience_validation.dart';

void main() {
  group('Experience text and categories', () {
    test('Title rejects null, empty, and whitespace-only input', () {
      for (final value in [null, '', ' \n\t ']) {
        expect(ExperienceValidation.title(value), isNotNull);
      }
      expect(ExperienceValidation.title(' Teaching Assistant '), isNull);
    });

    test('Title accepts 255 characters and rejects 256', () {
      expect(ExperienceValidation.title('a' * 255), isNull);
      expect(ExperienceValidation.title('a' * 256), isNotNull);
    });

    test('Title length counts Unicode characters rather than UTF-16 units', () {
      expect(ExperienceValidation.title('🎓' * 255), isNull);
      expect(ExperienceValidation.title('🎓' * 256), isNotNull);
    });

    test('Description requires actual content and supports multiple lines', () {
      for (final value in [null, '', ' \n\t ']) {
        expect(ExperienceValidation.description(value), isNotNull);
      }
      expect(
        ExperienceValidation.description('Memandu praktikum.\nMenilai tugas.'),
        isNull,
      );
    });

    test('All six backend category values and its default are supported', () {
      const expected = {
        'internship': 'Internship',
        'research': 'Research',
        'volunteer': 'Volunteer',
        'part-time': 'Part-Time',
        'full-time': 'Full-Time',
        'freelance': 'Freelance',
      };
      expect(ExperienceValidation.categories, expected);
      for (final category in expected.keys) {
        expect(ExperienceValidation.category(category), isNull);
      }
      expect(ExperienceValidation.defaultCategory, 'full-time');
    });

    test('Unknown, display-label, and empty category values are rejected', () {
      for (final value in [null, '', 'other', 'Full-Time']) {
        expect(ExperienceValidation.category(value), isNotNull);
      }
    });
  });

  group('Optional thumbnail URL', () {
    test('Empty thumbnail is allowed', () {
      for (final value in [null, '', '  ']) {
        expect(ExperienceValidation.thumbnail(value), isNull);
      }
    });

    test('Complete HTTP and HTTPS URLs are accepted', () {
      for (final value in [
        'https://example.com/photo.jpg',
        ' http://example.com/photo.png?size=400 ',
      ]) {
        expect(ExperienceValidation.thumbnail(value), isNull);
      }
    });

    test(
      'Unsupported schemes, incomplete URLs, and whitespace are rejected',
      () {
        for (final value in [
          'example.com/photo.jpg',
          '/photo.jpg',
          'https://',
          'https://bad host.example/photo.jpg',
          'javascript:alert(1)',
          'ftp://example.com/photo.jpg',
          'https://[invalid',
        ]) {
          expect(
            ExperienceValidation.thumbnail(value),
            isNotNull,
            reason: value,
          );
        }
      },
    );

    test('URL length follows the model default maximum of 200 characters', () {
      const prefix = 'https://example.com/';
      final valid = prefix + 'a' * (200 - prefix.length);
      expect(ExperienceValidation.thumbnail(valid), isNull);
      expect(ExperienceValidation.thumbnail('${valid}a'), isNotNull);
    });
  });

  group('Experience date and time', () {
    final start = DateTime(2026, 11, 22, 9, 30);

    test(
      'Start is required without imposing an extra past-only constraint',
      () {
        expect(ExperienceValidation.startedAt(null), isNotNull);
        expect(ExperienceValidation.startedAt(start), isNull);
        expect(ExperienceValidation.startedAt(DateTime(2030, 1, 1)), isNull);
      },
    );

    test('Empty end is allowed for an ongoing experience', () {
      expect(ExperienceValidation.endedAt(null, startedAt: start), isNull);
    });

    test('End earlier by a minute is rejected even on the same date', () {
      expect(
        ExperienceValidation.endedAt(
          start.subtract(const Duration(minutes: 1)),
          startedAt: start,
        ),
        isNotNull,
      );
    });

    test('Equal and later end instants are accepted', () {
      for (final end in [start, start.add(const Duration(minutes: 1))]) {
        expect(ExperienceValidation.endedAt(end, startedAt: start), isNull);
      }
    });

    test('Comparison respects UTC offsets rather than calendar labels', () {
      final localOffset = DateTime.parse('2026-11-22T09:30:00+07:00');
      final sameInstant = DateTime.parse('2026-11-22T02:30:00Z');
      expect(
        ExperienceValidation.endedAt(sameInstant, startedAt: localOffset),
        isNull,
      );
      expect(
        ExperienceValidation.endedAt(
          sameInstant.subtract(const Duration(minutes: 1)),
          startedAt: localOffset,
        ),
        isNotNull,
      );
    });
  });
}
