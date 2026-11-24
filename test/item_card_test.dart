import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

import 'package:myportofolio_mobile/widgets/project_card.dart';

double contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  return (math.max(firstLuminance, secondLuminance) + 0.05) /
      (math.min(firstLuminance, secondLuminance) + 0.05);
}

void main() {
  testWidgets('Action cards have distinct backgrounds and readable labels', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    final cards = find.byType(ItemCard);
    expect(cards, findsNWidgets(4));
    final backgrounds = <Color>{};

    for (var index = 0; index < 4; index++) {
      final card = cards.at(index);
      final item = tester.widget<ItemCard>(card).item;
      final material = tester.widget<Material>(
        find.descendant(of: card, matching: find.byType(Material)),
      );
      final label = tester.widget<Text>(
        find.descendant(of: card, matching: find.text(item.name)),
      );
      final icon = tester.widget<Icon>(
        find.descendant(of: card, matching: find.byIcon(item.icon)),
      );

      expect(material.color, item.color);
      backgrounds.add(material.color!);
      expect(
        contrastRatio(material.color!, label.style!.color!),
        greaterThanOrEqualTo(4.5),
      );
      expect(icon.color, label.style!.color);
    }

    expect(backgrounds, hasLength(4));
    expect(tester.takeException(), isNull);
  });

  for (final sample in [
    (background: const Color(0xFF102A43), foreground: Colors.white),
    (background: const Color(0xFFFFECB3), foreground: Colors.black),
  ]) {
    testWidgets(
      'Custom card uses ${sample.background} and a readable foreground',
      (tester) async {
        final item = ItemHomepage('Aksi Uji', Icons.star, sample.background);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(width: 180, height: 140, child: ItemCard(item)),
            ),
          ),
        );
        final card = find.byType(ItemCard);
        final material = tester.widget<Material>(
          find.descendant(of: card, matching: find.byType(Material)),
        );
        final label = tester.widget<Text>(find.text('Aksi Uji'));
        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(material.color, sample.background);
        expect(label.style!.color, sample.foreground);
        expect(icon.color, sample.foreground);
        expect(
          contrastRatio(material.color!, label.style!.color!),
          greaterThanOrEqualTo(4.5),
        );

        await tester.tap(card);
        await tester.pumpAndSettle();
        expect(
          find.text('Kamu telah menekan tombol Aksi Uji!'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
