import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_software_test/feature/bg_color_change/ui/hello_there.dart';
import 'package:solid_software_test/feature/bg_color_change/utils/message_list.dart';

void main() {
  final Widget rootWidget = MaterialApp(
    title: 'Solid Software test',
    theme: ThemeData(),
    home: const HelloThere(),
  );
  group('HelloThere', () {
    testWidgets('displays "Hello there" phrase', (WidgetTester tester) async {
      await tester.pumpWidget(rootWidget);
      await tester.pump();
      expect(find.text('Hello there'), findsOneWidget);
    });

    testWidgets('changes background color on tap', (WidgetTester tester) async {
      const initialColor = Colors.black;

      await tester.pumpWidget(rootWidget);

      // Tap the screen
      await tester.tap(find.byType(Scaffold));
      await tester.pump();

      final containerFinder =
          find.byWidgetPredicate((widget) => widget is AnimatedContainer);
      final decoration =
          tester.widget<AnimatedContainer>(containerFinder).decoration;
      final bgColor = (decoration as BoxDecoration?)?.color;

      expect(bgColor, isNot(initialColor));
    });

    testWidgets('changes message on tap', (WidgetTester tester) async {
      await tester.pumpWidget(rootWidget);

      // Tap the screen once
      await tester.tap(find.byType(Scaffold));
      await tester.pumpFrames(rootWidget, const Duration(seconds: 2));

      final firstMessage = words.first;
      final secondMessage = words[1];
      final thirdMessage = words[2];

      expect(find.text(firstMessage), findsNothing);
      expect(find.text(secondMessage), findsOneWidget);

      // Tap the screen again
      await tester.tap(find.byType(Scaffold));
      await tester.pumpFrames(rootWidget, const Duration(seconds: 2));

      expect(find.text(firstMessage), findsNothing);
      expect(find.text(secondMessage), findsNothing);
      expect(find.text(thirdMessage), findsOneWidget);
    });

    testWidgets('changes text color based on luminance',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(rootWidget);

      // Get the initial background color
      final containerFinder =
          find.byWidgetPredicate((widget) => widget is AnimatedContainer);
      final decoration =
          tester.widget<AnimatedContainer>(containerFinder).decoration;
      final initialColor = (decoration as BoxDecoration?)?.color;

      // Tap the screen to change the color
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpFrames(rootWidget, const Duration(seconds: 2));

      // Get the new background color
      final newContainerFinder =
          find.byWidgetPredicate((widget) => widget is AnimatedContainer);
      final newDecoration =
          tester.widget<AnimatedContainer>(newContainerFinder).decoration;
      Color? newColor = (newDecoration as BoxDecoration?)?.color;
      const double redUmbral = 0.299;
      const double greenUmbral = 0.299;
      const double blueUmbral = 0.299;
      const double colorBitsLimit = 255;
      const double luminanceLimit = 0.7;

      // Get the new text color based on luminance
      if (newColor != null) {
        newColor = (redUmbral * newColor.red +
                        greenUmbral * newColor.green +
                        blueUmbral * newColor.blue) /
                    colorBitsLimit >
                luminanceLimit
            ? Colors.black
            : Colors.white;
      }

      // Verify that the color has changed and the text color is correct
      expect(newColor, isNot(initialColor));
      expect(
        (tester.widget<Text>(find.byType(Text))).style?.color,
        newColor,
      );
    });
  });
}
